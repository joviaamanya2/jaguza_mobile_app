<?php

namespace App\Http\Controllers\Admin;

use App\Models\Doctor;
use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
use Illuminate\Support\Facades\Validator;

class DoctorController extends Controller
{
    public function index()
    {
        $doctors = Doctor::all();
        return view('admin.doctors.index', compact('doctors'));
    }
    
    public function store(Request $request)
    {
        $validator = Validator::make($request->all(), [
            // Add validation rules here
        ]);
        
        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'errors' => $validator->errors()
            ], 422);
        }
        
        $item = Doctor::create($request->all());
        
        return response()->json([
            'success' => true,
            'data' => $item,
            'message' => 'Created successfully'
        ]);
    }
    
    public function show($id)
    {
        $item = Doctor::find($id);
        if (!$item) {
            return response()->json([
                'success' => false,
                'message' => 'Not found'
            ], 404);
        }
        return response()->json([
            'success' => true,
            'data' => $item
        ]);
    }
    
    public function update(Request $request, $id)
    {
        $item = Doctor::find($id);
        if (!$item) {
            return response()->json([
                'success' => false,
                'message' => 'Not found'
            ], 404);
        }
        
        $validator = Validator::make($request->all(), [
            // Add validation rules here
        ]);
        
        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'errors' => $validator->errors()
            ], 422);
        }
        
        $item->update($request->all());
        
        return response()->json([
            'success' => true,
            'data' => $item,
            'message' => 'Updated successfully'
        ]);
    }
    
    public function destroy($id)
    {
        $item = Doctor::find($id);
        if (!$item) {
            return response()->json([
                'success' => false,
                'message' => 'Not found'
            ], 404);
        }
        $item->delete();
        
        return response()->json([
            'success' => true,
            'message' => 'Deleted successfully'
        ]);
    }
}