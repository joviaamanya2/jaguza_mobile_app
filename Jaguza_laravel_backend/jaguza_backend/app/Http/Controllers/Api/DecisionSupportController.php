<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\DecisionSupport;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;

class DecisionSupportController extends Controller
{
    public function index()
    {
        return response()->json([
            'success' => true,
            'data' => DecisionSupport::all()
        ]);
    }

    public function store(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'title' => 'required|string|max:255',
            'content' => 'required|string',
            'category' => 'required|string',
        ]);

        if ($validator->fails()) {
            return response()->json(['success' => false, 'errors' => $validator->errors()], 422);
        }

        $article = DecisionSupport::create(array_merge(
            $request->all(),
            [
                'is_published' => true,
                'views_count' => 0,
                'helpful_count' => 0
            ]
        ));

        return response()->json([
            'success' => true,
            'message' => 'Article created successfully',
            'data' => $article
        ], 201);
    }

    public function show($id)
    {
        $article = DecisionSupport::find($id);
        if (!$article) {
            return response()->json(['success' => false, 'message' => 'Article not found'], 404);
        }
        $article->increment('views_count');
        return response()->json(['success' => true, 'data' => $article]);
    }

    public function update(Request $request, $id)
    {
        $article = DecisionSupport::find($id);
        if (!$article) {
            return response()->json(['success' => false, 'message' => 'Article not found'], 404);
        }

        $validator = Validator::make($request->all(), [
            'title' => 'required|string|max:255',
            'content' => 'required|string',
        ]);

        if ($validator->fails()) {
            return response()->json(['success' => false, 'errors' => $validator->errors()], 422);
        }

        $article->update($request->all());

        return response()->json([
            'success' => true,
            'message' => 'Article updated successfully',
            'data' => $article
        ]);
    }

    public function destroy($id)
    {
        $article = DecisionSupport::find($id);
        if (!$article) {
            return response()->json(['success' => false, 'message' => 'Article not found'], 404);
        }
        $article->delete();
        return response()->json(['success' => true, 'message' => 'Article deleted successfully']);
    }

    public function categories()
    {
        $categories = DecisionSupport::select('category')->distinct()->pluck('category');
        return response()->json([
            'success' => true,
            'data' => $categories
        ]);
    }

    public function markHelpful($id)
    {
        $article = DecisionSupport::find($id);
        if (!$article) {
            return response()->json(['success' => false, 'message' => 'Article not found'], 404);
        }
        $article->increment('helpful_count');
        return response()->json(['success' => true, 'message' => 'Marked helpful successfully']);
    }
}
