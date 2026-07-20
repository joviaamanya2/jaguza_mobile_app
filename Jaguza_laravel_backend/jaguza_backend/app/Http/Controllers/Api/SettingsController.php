<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Setting;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;

class SettingsController extends Controller
{
    public function index()
    {
        return response()->json([
            'success' => true,
            'data' => Setting::pluck('value', 'key')->toArray()
        ]);
    }

    public function public()
    {
        $publicKeys = ['app_name', 'app_version', 'currency', 'country'];
        return response()->json([
            'success' => true,
            'data' => Setting::whereIn('key', $publicKeys)->pluck('value', 'key')->toArray()
        ]);
    }

    public function store(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'settings' => 'required|array',
        ]);

        if ($validator->fails()) {
            return response()->json(['success' => false, 'errors' => $validator->errors()], 422);
        }

        foreach ($request->settings as $key => $value) {
            Setting::updateOrCreate(['key' => $key], ['value' => $value]);
        }

        return response()->json([
            'success' => true,
            'message' => 'Settings saved successfully',
            'data' => Setting::pluck('value', 'key')->toArray()
        ]);
    }

    public function show($key)
    {
        $setting = Setting::where('key', $key)->first();
        if (!$setting) {
            return response()->json(['success' => false, 'message' => 'Setting not found'], 404);
        }
        return response()->json(['success' => true, 'data' => $setting]);
    }

    public function update(Request $request, $key)
    {
        $setting = Setting::where('key', $key)->first();
        if (!$setting) {
            return response()->json(['success' => false, 'message' => 'Setting not found'], 404);
        }

        $setting->update(['value' => $request->value]);

        return response()->json([
            'success' => true,
            'message' => 'Setting updated successfully',
            'data' => $setting
        ]);
    }

    public function destroy($key)
    {
        $setting = Setting::where('key', $key)->first();
        if (!$setting) {
            return response()->json(['success' => false, 'message' => 'Setting not found'], 404);
        }
        $setting->delete();
        return response()->json(['success' => true, 'message' => 'Setting deleted successfully']);
    }
}
