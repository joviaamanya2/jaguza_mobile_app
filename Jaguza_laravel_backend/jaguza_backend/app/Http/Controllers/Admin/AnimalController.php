<?php

namespace App\Http\Controllers\Admin;

use App\Models\Animal;
use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
use Illuminate\Support\Facades\Validator;

class AnimalController extends Controller
{
    public function index()
    {
        $animals = Animal::all();
        return view('admin.animals.index', compact('animals'));
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
        
        $item = Animal::create($request->all());
        
        return response()->json([
            'success' => true,
            'data' => $item,
            'message' => 'Created successfully'
        ]);
    }
    
    public function show($id)
    {
        $item = Animal::find($id);
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
        $item = Animal::find($id);
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
        $item = Animal::find($id);
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