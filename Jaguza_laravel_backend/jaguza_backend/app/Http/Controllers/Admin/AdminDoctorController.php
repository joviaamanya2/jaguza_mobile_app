<?php

namespace App\Http\Controllers\Admin;

use App\Models\Doctor;
use App\Models\User;
use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Validator;

class DoctorController extends Controller
{
    /**
     * Display a listing of doctors
     */
    public function index()
    {
        $doctors = Doctor::with('user')->get();
        
        return response()->json([
            'success' => true,
            'data' => $doctors
        ]);
    }

    /**
     * Store a newly created doctor
     */
    public function store(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'name' => 'required|string|max:255',
            'email' => 'required|email|unique:users,email',
            'specialization' => 'required|string|max:255',
            'license_number' => 'required|string|unique:doctors,license_number',
            'years_of_experience' => 'nullable|integer|min:0',
            'location' => 'required|string|max:255',
            'phone_number' => 'required|string|max:20',
            'consultation_fee' => 'nullable|numeric|min:0',
            'bio' => 'nullable|string',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'errors' => $validator->errors()
            ], 422);
        }

        // Create user account
        $user = User::create([
            'name' => $request->name,
            'email' => $request->email,
            'password' => Hash::make('password123'),
            'role' => 'vet',
            'is_active' => true,
        ]);

        // Create doctor profile
        $doctor = Doctor::create([
            'user_id' => $user->id,
            'specialization' => $request->specialization,
            'license_number' => $request->license_number,
            'years_of_experience' => $request->years_of_experience ?? 0,
            'location' => $request->location,
            'phone_number' => $request->phone_number,
            'consultation_fee' => $request->consultation_fee ?? 0,
            'bio' => $request->bio,
            'is_available' => true,
            'rating' => 0,
            'total_cases' => 0,
        ]);

        return response()->json([
            'success' => true,
            'data' => $doctor->load('user'),
            'message' => 'Doctor created successfully'
        ], 201);
    }

    /**
     * Display the specified doctor
     */
    public function show($id)
    {
        $doctor = Doctor::with('user')->find($id);

        if (!$doctor) {
            return response()->json([
                'success' => false,
                'message' => 'Doctor not found'
            ], 404);
        }

        return response()->json([
            'success' => true,
            'data' => $doctor
        ]);
    }

    /**
     * Update the specified doctor
     */
    public function update(Request $request, $id)
    {
        $doctor = Doctor::find($id);

        if (!$doctor) {
            return response()->json([
                'success' => false,
                'message' => 'Doctor not found'
            ], 404);
        }

        $validator = Validator::make($request->all(), [
            'name' => 'nullable|string|max:255',
            'email' => 'nullable|email|unique:users,email,' . $doctor->user_id,
            'specialization' => 'nullable|string|max:255',
            'license_number' => 'nullable|string|unique:doctors,license_number,' . $id,
            'years_of_experience' => 'nullable|integer|min:0',
            'location' => 'nullable|string|max:255',
            'phone_number' => 'nullable|string|max:20',
            'consultation_fee' => 'nullable|numeric|min:0',
            'bio' => 'nullable|string',
            'is_available' => 'nullable|boolean',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'errors' => $validator->errors()
            ], 422);
        }

        // Update user
        $user = User::find($doctor->user_id);
        if ($request->has('name')) {
            $user->name = $request->name;
        }
        if ($request->has('email')) {
            $user->email = $request->email;
        }
        $user->save();

        // Update doctor
        $doctor->update($request->only([
            'specialization',
            'license_number',
            'years_of_experience',
            'location',
            'phone_number',
            'consultation_fee',
            'bio',
            'is_available',
        ]));

        return response()->json([
            'success' => true,
            'data' => $doctor->load('user'),
            'message' => 'Doctor updated successfully'
        ]);
    }

    /**
     * Remove the specified doctor
     */
    public function destroy($id)
    {
        $doctor = Doctor::find($id);

        if (!$doctor) {
            return response()->json([
                'success' => false,
                'message' => 'Doctor not found'
            ], 404);
        }

        // Delete user account
        $user = User::find($doctor->user_id);
        if ($user) {
            $user->delete();
        }

        $doctor->delete();

        return response()->json([
            'success' => true,
            'message' => 'Doctor deleted successfully'
        ]);
    }

    /**
     * Update doctor availability
     */
    public function updateAvailability(Request $request, $id)
    {
        $doctor = Doctor::find($id);

        if (!$doctor) {
            return response()->json([
                'success' => false,
                'message' => 'Doctor not found'
            ], 404);
        }

        $request->validate([
            'is_available' => 'required|boolean'
        ]);

        $doctor->is_available = $request->is_available;
        $doctor->save();

        return response()->json([
            'success' => true,
            'data' => $doctor,
            'message' => $request->is_available ? 'Doctor is now available' : 'Doctor is now busy'
        ]);
    }
}