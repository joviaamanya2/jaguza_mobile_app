<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Advertisement;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;

class AdvertisementController extends Controller
{
    public function index()
    {
        return response()->json([
            'success' => true,
            'data' => Advertisement::all()
        ]);
    }

    public function store(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'title' => 'required|string|max:255',
            'description' => 'nullable|string',
            'type' => 'required|in:' . implode(',', Advertisement::TYPES),
            'budget' => 'nullable|numeric|min:0',
            'start_date' => 'required|date',
            'end_date' => 'nullable|date|after_or_equal:start_date',
        ]);

        if ($validator->fails()) {
            return response()->json(['success' => false, 'errors' => $validator->errors()], 422);
        }

        $ad = Advertisement::create(array_merge(
            $request->all(),
            [
                'created_by' => $request->user()->id ?? 1,
                'status' => 'pending',
                'views_count' => 0,
                'clicks_count' => 0
            ]
        ));

        return response()->json([
            'success' => true,
            'message' => 'Ad created successfully',
            'data' => $ad
        ], 201);
    }

    public function show($id)
    {
        $ad = Advertisement::find($id);
        if (!$ad) {
            return response()->json(['success' => false, 'message' => 'Ad not found'], 404);
        }
        return response()->json(['success' => true, 'data' => $ad]);
    }

    public function update(Request $request, $id)
    {
        $ad = Advertisement::find($id);
        if (!$ad) {
            return response()->json(['success' => false, 'message' => 'Ad not found'], 404);
        }

        $validator = Validator::make($request->all(), [
            'title' => 'required|string|max:255',
            'description' => 'nullable|string',
        ]);

        if ($validator->fails()) {
            return response()->json(['success' => false, 'errors' => $validator->errors()], 422);
        }

        $ad->update($request->all());

        return response()->json([
            'success' => true,
            'message' => 'Ad updated successfully',
            'data' => $ad
        ]);
    }

    public function destroy($id)
    {
        $ad = Advertisement::find($id);
        if (!$ad) {
            return response()->json(['success' => false, 'message' => 'Ad not found'], 404);
        }
        $ad->delete();
        return response()->json(['success' => true, 'message' => 'Ad deleted successfully']);
    }

    public function approve(Request $request, $id)
    {
        $ad = Advertisement::find($id);
        if (!$ad) {
            return response()->json(['success' => false, 'message' => 'Ad not found'], 404);
        }

        $ad->update([
            'status' => 'active',
            'approved_by' => $request->user()->id ?? 1,
            'approved_at' => now(),
        ]);

        return response()->json([
            'success' => true,
            'message' => 'Ad approved successfully',
            'data' => $ad
        ]);
    }

    public function trackClick($id)
    {
        $ad = Advertisement::find($id);
        if (!$ad) {
            return response()->json(['success' => false, 'message' => 'Ad not found'], 404);
        }
        $ad->incrementClicks();
        return response()->json(['success' => true, 'message' => 'Click tracked successfully']);
    }
}
