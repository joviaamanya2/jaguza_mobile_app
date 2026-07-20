<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Facades\Log;

class UserController extends Controller
{
    /**
     * Display a listing of users.
     */
    public function index(Request $request)
    {
        $users = User::orderBy('created_at', 'desc')
            ->when($request->search, function ($query, $search) {
                return $query->where('name', 'like', "%{$search}%")
                    ->orWhere('email', 'like', "%{$search}%");
            })
            ->when($request->role, function ($query, $role) {
                return $query->where('role', $role);
            })
            ->paginate(20);

        return response()->json([
            'success' => true,
            'data' => $users
        ]);
    }

    /**
     * Store a newly created user.
     */
    public function store(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'name' => 'required|string|max:255',
            'email' => 'required|string|email|max:255|unique:users',
            'password' => 'required|string|min:8',
            'role' => 'required|in:admin,farmer,vet,manager,staff',
            'phone_number' => 'nullable|string|max:15',
            'farm_name' => 'nullable|string|max:255',
            'farm_location' => 'nullable|string|max:255',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'errors' => $validator->errors()
            ], 422);
        }

        try {
            $user = User::create([
                'name' => $request->name,
                'email' => $request->email,
                'password' => Hash::make($request->password),
                'role' => $request->role,
                'phone_number' => $request->phone_number,
                'farm_name' => $request->farm_name,
                'farm_location' => $request->farm_location,
                'is_active' => true,
            ]);

            return response()->json([
                'success' => true,
                'message' => 'User created successfully',
                'data' => $user
            ], 201);

        } catch (\Exception $e) {
            Log::error('User creation failed: ' . $e->getMessage());
            return response()->json([
                'success' => false,
                'message' => 'Failed to create user: ' . $e->getMessage()
            ], 500);
        }
    }

    /**
     * Display the specified user.
     */
    public function show($id)
    {
        try {
            $user = User::findOrFail($id);
            
            return response()->json([
                'success' => true,
                'data' => $user
            ]);

        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'User not found'
            ], 404);
        }
    }

    /**
     * Update the specified user.
     */
    public function update(Request $request, $id)
    {
        try {
            $user = User::findOrFail($id);
            
            $validator = Validator::make($request->all(), [
                'name' => 'required|string|max:255',
                'email' => 'required|string|email|max:255|unique:users,email,' . $id,
                'role' => 'required|in:admin,farmer,vet,manager,staff',
                'phone_number' => 'nullable|string|max:15',
                'farm_name' => 'nullable|string|max:255',
                'farm_location' => 'nullable|string|max:255',
                'is_active' => 'sometimes|boolean',
            ]);

            if ($validator->fails()) {
                return response()->json([
                    'success' => false,
                    'errors' => $validator->errors()
                ], 422);
            }

            $data = $request->only([
                'name', 'email', 'role', 'phone_number', 
                'farm_name', 'farm_location', 'is_active'
            ]);

            // Only update password if provided
            if ($request->filled('password')) {
                $validator = Validator::make($request->all(), [
                    'password' => 'string|min:8',
                ]);
                
                if ($validator->fails()) {
                    return response()->json([
                        'success' => false,
                        'errors' => $validator->errors()
                    ], 422);
                }
                
                $data['password'] = Hash::make($request->password);
            }

            $user->update($data);

            return response()->json([
                'success' => true,
                'message' => 'User updated successfully',
                'data' => $user
            ]);

        } catch (\Exception $e) {
            Log::error('User update failed: ' . $e->getMessage());
            return response()->json([
                'success' => false,
                'message' => 'Failed to update user: ' . $e->getMessage()
            ], 500);
        }
    }

    /**
     * Remove the specified user.
     */
    public function destroy($id)
    {
        try {
            $user = User::findOrFail($id);
            
            // Prevent deleting yourself
            if (auth()->id() == $id) {
                return response()->json([
                    'success' => false,
                    'message' => 'You cannot delete your own account'
                ], 403);
            }

            // Prevent deleting the last admin
            $adminCount = User::where('role', 'admin')->count();
            if ($user->role === 'admin' && $adminCount <= 1) {
                return response()->json([
                    'success' => false,
                    'message' => 'Cannot delete the last admin user'
                ], 403);
            }

            $user->delete();

            return response()->json([
                'success' => true,
                'message' => 'User deleted successfully'
            ]);

        } catch (\Exception $e) {
            Log::error('User deletion failed: ' . $e->getMessage());
            return response()->json([
                'success' => false,
                'message' => 'Failed to delete user: ' . $e->getMessage()
            ], 500);
        }
    }

    /**
     * Toggle user active status.
     */
    public function toggleStatus($id)
    {
        try {
            $user = User::findOrFail($id);
            
            // Prevent deactivating yourself
            if (auth()->id() == $id) {
                return response()->json([
                    'success' => false,
                    'message' => 'You cannot deactivate your own account'
                ], 403);
            }

            $user->is_active = !$user->is_active;
            $user->save();

            $status = $user->is_active ? 'activated' : 'deactivated';

            return response()->json([
                'success' => true,
                'message' => "User {$status} successfully",
                'data' => $user
            ]);

        } catch (\Exception $e) {
            Log::error('User status toggle failed: ' . $e->getMessage());
            return response()->json([
                'success' => false,
                'message' => 'Failed to toggle user status'
            ], 500);
        }
    }

    /**
     * Bulk delete users.
     */
    public function bulkDelete(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'ids' => 'required|array',
            'ids.*' => 'exists:users,id',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'errors' => $validator->errors()
            ], 422);
        }

        try {
            $ids = $request->ids;
            
            // Remove current user from list
            $ids = array_filter($ids, function($id) {
                return $id != auth()->id();
            });

            if (empty($ids)) {
                return response()->json([
                    'success' => false,
                    'message' => 'Cannot delete your own account'
                ], 403);
            }

            // Check if trying to delete all admins
            $adminIds = User::where('role', 'admin')->whereIn('id', $ids)->pluck('id');
            $remainingAdmins = User::where('role', 'admin')->whereNotIn('id', $ids)->count();
            
            if ($adminIds->count() > 0 && $remainingAdmins == 0) {
                return response()->json([
                    'success' => false,
                    'message' => 'Cannot delete all admin users'
                ], 403);
            }

            User::whereIn('id', $ids)->delete();

            return response()->json([
                'success' => true,
                'message' => 'Users deleted successfully',
                'deleted_count' => count($ids)
            ]);

        } catch (\Exception $e) {
            Log::error('Bulk user deletion failed: ' . $e->getMessage());
            return response()->json([
                'success' => false,
                'message' => 'Failed to delete users: ' . $e->getMessage()
            ], 500);
        }
    }

    /**
     * Get user statistics.
     */
    public function stats()
    {
        $total = User::count();
        $admins = User::where('role', 'admin')->count();
        $farmers = User::where('role', 'farmer')->count();
        $vets = User::where('role', 'vet')->count();
        $active = User::where('is_active', true)->count();
        $inactive = User::where('is_active', false)->count();
        $newThisMonth = User::whereMonth('created_at', now()->month)
            ->whereYear('created_at', now()->year)
            ->count();

        return response()->json([
            'success' => true,
            'data' => [
                'total' => $total,
                'admins' => $admins,
                'farmers' => $farmers,
                'vets' => $vets,
                'active' => $active,
                'inactive' => $inactive,
                'new_this_month' => $newThisMonth,
            ]
        ]);
    }
}