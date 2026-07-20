<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\MarketplaceListing;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;

class MarketplaceController extends Controller
{
    public function index()
    {
        return response()->json([
            'success' => true,
            'data' => MarketplaceListing::with('seller')->get()
        ]);
    }

    public function store(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'title' => 'required|string|max:255',
            'description' => 'nullable|string',
            'category' => 'required|in:' . implode(',', MarketplaceListing::CATEGORIES),
            'price' => 'required|numeric|min:0',
            'location' => 'required|string|max:255',
        ]);

        if ($validator->fails()) {
            return response()->json(['success' => false, 'errors' => $validator->errors()], 422);
        }

        $listing = MarketplaceListing::create(array_merge(
            $request->all(),
            [
                'seller_id' => $request->user()->id ?? 1,
                'currency' => 'UGX',
                'status' => 'active',
                'views_count' => 0
            ]
        ));

        return response()->json([
            'success' => true,
            'message' => 'Listing created successfully',
            'data' => $listing
        ], 201);
    }

    public function show($id)
    {
        $listing = MarketplaceListing::with('seller')->find($id);
        if (!$listing) {
            return response()->json(['success' => false, 'message' => 'Listing not found'], 404);
        }
        return response()->json(['success' => true, 'data' => $listing]);
    }

    public function update(Request $request, $id)
    {
        $listing = MarketplaceListing::find($id);
        if (!$listing) {
            return response()->json(['success' => false, 'message' => 'Listing not found'], 404);
        }

        $validator = Validator::make($request->all(), [
            'title' => 'required|string|max:255',
            'price' => 'required|numeric|min:0',
            'location' => 'required|string|max:255',
            'status' => 'required|in:' . implode(',', MarketplaceListing::STATUSES),
        ]);

        if ($validator->fails()) {
            return response()->json(['success' => false, 'errors' => $validator->errors()], 422);
        }

        $listing->update($request->all());

        return response()->json([
            'success' => true,
            'message' => 'Listing updated successfully',
            'data' => $listing
        ]);
    }

    public function destroy($id)
    {
        $listing = MarketplaceListing::find($id);
        if (!$listing) {
            return response()->json(['success' => false, 'message' => 'Listing not found'], 404);
        }
        $listing->delete();
        return response()->json(['success' => true, 'message' => 'Listing deleted successfully']);
    }
}
