<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Video;
use App\Models\VideoCategory;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Str;

class VideoController extends Controller
{
    public function index()
    {
        return response()->json([
            'success' => true,
            'data' => Video::with('category')->get()
        ]);
    }

    public function store(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'title' => 'required|string|max:255',
            'video_url' => 'required|url',
            'category_id' => 'required|exists:video_categories,id',
        ]);

        if ($validator->fails()) {
            return response()->json(['success' => false, 'errors' => $validator->errors()], 422);
        }

        $video = Video::create(array_merge(
            $request->all(),
            [
                'slug' => Str::slug($request->title) . '-' . time(),
                'is_published' => true,
                'published_at' => now(),
                'uploaded_by' => $request->user()->id ?? 1
            ]
        ));

        return response()->json([
            'success' => true,
            'message' => 'Video uploaded successfully',
            'data' => $video
        ], 201);
    }

    public function show($id)
    {
        $video = Video::with('category')->find($id);
        if (!$video) {
            return response()->json(['success' => false, 'message' => 'Video not found'], 404);
        }
        return response()->json(['success' => true, 'data' => $video]);
    }

    public function update(Request $request, $id)
    {
        $video = Video::find($id);
        if (!$video) {
            return response()->json(['success' => false, 'message' => 'Video not found'], 404);
        }

        $validator = Validator::make($request->all(), [
            'title' => 'required|string|max:255',
            'video_url' => 'required|url',
        ]);

        if ($validator->fails()) {
            return response()->json(['success' => false, 'errors' => $validator->errors()], 422);
        }

        $video->update($request->all());

        return response()->json([
            'success' => true,
            'message' => 'Video updated successfully',
            'data' => $video
        ]);
    }

    public function destroy($id)
    {
        $video = Video::find($id);
        if (!$video) {
            return response()->json(['success' => false, 'message' => 'Video not found'], 404);
        }
        $video->delete();
        return response()->json(['success' => true, 'message' => 'Video deleted successfully']);
    }

    public function categories()
    {
        return response()->json([
            'success' => true,
            'data' => VideoCategory::all()
        ]);
    }

    public function incrementViews($id)
    {
        $video = Video::find($id);
        if (!$video) {
            return response()->json(['success' => false, 'message' => 'Video not found'], 404);
        }
        $video->incrementViews();
        return response()->json(['success' => true, 'message' => 'View incremented successfully']);
    }
}
