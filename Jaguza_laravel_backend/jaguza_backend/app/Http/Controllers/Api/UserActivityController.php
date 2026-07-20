<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\UserActivityLog;
use Illuminate\Http\Request;

class UserActivityController extends Controller
{
    public function index()
    {
        return response()->json([
            'success' => true,
            'data' => UserActivityLog::with('user')->orderBy('created_at', 'desc')->get()
        ]);
    }

    public function userLogs($userId)
    {
        return response()->json([
            'success' => true,
            'data' => UserActivityLog::where('user_id', $userId)->orderBy('created_at', 'desc')->get()
        ]);
    }
}
