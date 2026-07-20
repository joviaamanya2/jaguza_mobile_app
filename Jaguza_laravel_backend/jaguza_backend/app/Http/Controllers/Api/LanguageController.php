<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Language;
use Illuminate\Http\Request;

class LanguageController extends Controller
{
    public function index()
    {
        return response()->json([
            'success' => true,
            'data' => Language::all()
        ]);
    }

    public function active()
    {
        return response()->json([
            'success' => true,
            'data' => Language::where('is_active', true)->get()
        ]);
    }

    public function setDefault($id)
    {
        $language = Language::find($id);
        if (!$language) {
            return response()->json(['success' => false, 'message' => 'Language not found'], 404);
        }

        Language::query()->update(['is_default' => false]);
        $language->update(['is_default' => true, 'is_active' => true]);

        return response()->json([
            'success' => true,
            'message' => 'Default language updated successfully',
            'data' => $language
        ]);
    }
}
