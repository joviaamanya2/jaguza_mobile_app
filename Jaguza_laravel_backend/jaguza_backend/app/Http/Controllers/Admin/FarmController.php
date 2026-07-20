<?php

namespace App\Http\Controllers\Admin;

use App\Models\Farm;
use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
use Illuminate\Support\Facades\Validator;

class FarmController extends Controller
{
    public function index()
    {
        $farms = Farm::all();
        return view('admin.farms.index', compact('farms'));
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
        
        $item = Farm::create($request->all());
        
        return response()->json([
            'success' => true,
            'data' => $item,
            'message' => 'Created successfully'
        ]);
    }
    
    public function show($id)
    {
        $item = Farm::find($id);
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
        $item = Farm::find($id);
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
        $item = Farm::find($id);
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