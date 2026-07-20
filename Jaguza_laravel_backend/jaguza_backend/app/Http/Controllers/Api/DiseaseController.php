<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Disease;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;

class DiseaseController extends Controller
{
    public function index()
    {
        return response()->json([
            'success' => true,
            'data' => Disease::all()
        ]);
    }

    public function store(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'name' => 'required|string|max:255|unique:diseases',
            'species_affected' => 'required|string',
            'symptoms' => 'required|string',
            'severity' => 'required|in:' . implode(',', Disease::SEVERITIES),
            'outbreak_risk' => 'required|in:' . implode(',', Disease::RISKS),
        ]);

        if ($validator->fails()) {
            return response()->json(['success' => false, 'errors' => $validator->errors()], 422);
        }

        $disease = Disease::create(array_merge(
            $request->all(),
            ['is_active' => true]
        ));

        return response()->json([
            'success' => true,
            'message' => 'Disease created successfully',
            'data' => $disease
        ], 201);
    }

    public function show($id)
    {
        $disease = Disease::find($id);
        if (!$disease) {
            return response()->json(['success' => false, 'message' => 'Disease not found'], 404);
        }
        return response()->json(['success' => true, 'data' => $disease]);
    }

    public function update(Request $request, $id)
    {
        $disease = Disease::find($id);
        if (!$disease) {
            return response()->json(['success' => false, 'message' => 'Disease not found'], 404);
        }

        $validator = Validator::make($request->all(), [
            'name' => 'required|string|max:255|unique:diseases,name,' . $id,
            'species_affected' => 'required|string',
            'symptoms' => 'required|string',
            'severity' => 'required|in:' . implode(',', Disease::SEVERITIES),
            'outbreak_risk' => 'required|in:' . implode(',', Disease::RISKS),
        ]);

        if ($validator->fails()) {
            return response()->json(['success' => false, 'errors' => $validator->errors()], 422);
        }

        $disease->update($request->all());

        return response()->json([
            'success' => true,
            'message' => 'Disease updated successfully',
            'data' => $disease
        ]);
    }

    public function destroy($id)
    {
        $disease = Disease::find($id);
        if (!$disease) {
            return response()->json(['success' => false, 'message' => 'Disease not found'], 404);
        }

        $disease->delete();
        return response()->json(['success' => true, 'message' => 'Disease deleted successfully']);
    }
}
