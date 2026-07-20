<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Doctor;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Facades\Log;

class DoctorController extends Controller
{
    /**
     * Display a listing of doctors.
     */
    public function index(Request $request)
    {
        $doctors = Doctor::with('user')
            ->orderBy('created_at', 'desc')
            ->when($request->search, function ($query, $search) {
                return $query->whereHas('user', function ($q) use ($search) {
                    $q->where('name', 'like', "%{$search}%")
                      ->orWhere('email', 'like', "%{$search}%");
                })->orWhere('specialization', 'like', "%{$search}%")
                  ->orWhere('location', 'like', "%{$search}%");
            })
            ->when($request->specialization, function ($query, $specialization) {
                return $query->where('specialization', $specialization);
            })
            ->when($request->available, function ($query) {
                return $query->where('is_available', true);
            })
            ->paginate(20);

        return response()->json([
            'success' => true,
            'data' => $doctors
        ]);
    }

    /**
     * Store a newly created doctor.
     */
    public function store(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'name' => 'required|string|max:255',
            'email' => 'required|email|unique:users',
            'specialization' => 'required|string|max:255',
            'license_number' => 'required|string|unique:doctors',
            'years_of_experience' => 'nullable|integer|min:0',
            'name' => 'nullable|string|max:255',  // Clinic name
            'location' => 'nullable|string|max:255',
            'phone_number' => 'nullable|string|max:20',
            'consultation_fee' => 'nullable|numeric|min:0',
            'bio' => 'nullable|string',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'errors' => $validator->errors()
            ], 422);
        }

        try {
            // Create user account
            $user = User::create([
                'name' => $request->name,
                'email' => $request->email,
                'password' => Hash::make($request->password),
                'role' => 'vet',
                'is_active' => true,
            ]);

            // Create doctor profile
            $doctor = Doctor::create([
                'user_id' => $user->id,
                'specialization' => $request->specialization,
                'license_number' => $request->license_number,
                'years_of_experience' => $request->years_of_experience ?? 0,
                'name' => $request->clinic_name,  // Map to name field
                'location' => $request->location,
                'phone_number' => $request->phone_number,
                'consultation_fee' => $request->consultation_fee ?? 0,
                'is_available' => true,
                'bio' => $request->bio,
            ]);

            return response()->json([
                'success' => true,
                'message' => 'Doctor added successfully',
                'data' => $doctor->load('user')
            ], 201);

        } catch (\Exception $e) {
            Log::error('Doctor creation failed: ' . $e->getMessage());
            return response()->json([
                'success' => false,
                'message' => 'Failed to create doctor: ' . $e->getMessage()
            ], 500);
        }
    }

    /**
     * Display the specified doctor.
     */
    public function show($id)
    {
        try {
            $doctor = Doctor::with('user')->findOrFail($id);
            
            return response()->json([
                'success' => true,
                'data' => $doctor
            ]);

        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Doctor not found'
            ], 404);
        }
    }

    /**
     * Update the specified doctor.
     */
    public function update(Request $request, $id)
    {
        try {
            $doctor = Doctor::with('user')->findOrFail($id);
            
            $validator = Validator::make($request->all(), [
                'name' => 'sometimes|string|max:255',
                'email' => 'sometimes|email|unique:users,email,' . $doctor->user_id,
                'specialization' => 'sometimes|string|max:255',
                'license_number' => 'sometimes|string|unique:doctors,license_number,' . $id,
                'years_of_experience' => 'nullable|integer|min:0',
                'name' => 'nullable|string|max:255',
                'location' => 'nullable|string|max:255',
                'phone_number' => 'nullable|string|max:20',
                'consultation_fee' => 'nullable|numeric|min:0',
                'is_available' => 'sometimes|boolean',
                'bio' => 'nullable|string',
            ]);

            if ($validator->fails()) {
                return response()->json([
                    'success' => false,
                    'errors' => $validator->errors()
                ], 422);
            }

            // Update user
            $userData = [];
            if ($request->has('name')) {
                $userData['name'] = $request->name;
            }
            if ($request->has('email')) {
                $userData['email'] = $request->email;
            }
            if ($request->filled('password')) {
                $userData['password'] = Hash::make($request->password);
            }
            
            if (!empty($userData)) {
                $doctor->user->update($userData);
            }

            // Update doctor
            $doctorData = $request->only([
                'specialization', 
                'license_number', 
                'years_of_experience',
                'name',          // Clinic name
                'location',
                'phone_number',
                'consultation_fee', 
                'is_available', 
                'bio'
            ]);
            
            $doctor->update($doctorData);

            return response()->json([
                'success' => true,
                'message' => 'Doctor updated successfully',
                'data' => $doctor->fresh('user')
            ]);

        } catch (\Exception $e) {
            Log::error('Doctor update failed: ' . $e->getMessage());
            return response()->json([
                'success' => false,
                'message' => 'Failed to update doctor: ' . $e->getMessage()
            ], 500);
        }
    }

    /**
     * Remove the specified doctor.
     */
    public function destroy($id)
    {
        try {
            $doctor = Doctor::findOrFail($id);
            
            // Delete the user account too (cascade will handle doctor)
            $doctor->user->delete();

            return response()->json([
                'success' => true,
                'message' => 'Doctor deleted successfully'
            ]);

        } catch (\Exception $e) {
            Log::error('Doctor deletion failed: ' . $e->getMessage());
            return response()->json([
                'success' => false,
                'message' => 'Failed to delete doctor: ' . $e->getMessage()
            ], 500);
        }
    }

    /**
     * Update doctor availability.
     */
    public function updateAvailability(Request $request, $id)
    {
        try {
            $doctor = Doctor::findOrFail($id);
            
            $validator = Validator::make($request->all(), [
                'is_available' => 'required|boolean',
            ]);

            if ($validator->fails()) {
                return response()->json([
                    'success' => false,
                    'errors' => $validator->errors()
                ], 422);
            }

            $doctor->update(['is_available' => $request->is_available]);

            return response()->json([
                'success' => true,
                'message' => 'Doctor availability updated',
                'data' => $doctor
            ]);

        } catch (\Exception $e) {
            Log::error('Availability update failed: ' . $e->getMessage());
            return response()->json([
                'success' => false,
                'message' => 'Failed to update availability'
            ], 500);
        }
    }

    /**
     * Get doctor statistics.
     */
    public function stats()
    {
        return response()->json([
            'success' => true,
            'data' => [
                'total' => Doctor::count(),
                'available' => Doctor::where('is_available', true)->count(),
                'busy' => Doctor::where('is_available', false)->count(),
                'top_rated' => Doctor::with('user')
                    ->orderBy('rating', 'desc')
                    ->limit(5)
                    ->get(),
            ]
        ]);
    }
}