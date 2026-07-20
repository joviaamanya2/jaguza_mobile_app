<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Message;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;

class MessageController extends Controller
{
    public function index()
    {
        return response()->json([
            'success' => true,
            'data' => Message::with('sender')->orderBy('created_at', 'desc')->get()
        ]);
    }

    public function store(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'receiver_id' => 'nullable|exists:users,id',
            'message' => 'required|string',
        ]);

        if ($validator->fails()) {
            return response()->json(['success' => false, 'errors' => $validator->errors()], 422);
        }

        $msg = Message::create([
            'sender_id' => $request->user()->id ?? 1,
            'receiver_id' => $request->receiver_id ?? 1,
            'message' => $request->message,
            'is_read' => false
        ]);

        return response()->json([
            'success' => true,
            'message' => 'Message sent successfully',
            'data' => $msg
        ], 201);
    }

    public function destroy($id)
    {
        $msg = Message::find($id);
        if (!$msg) {
            return response()->json(['success' => false, 'message' => 'Message not found'], 404);
        }
        $msg->delete();
        return response()->json(['success' => true, 'message' => 'Message deleted successfully']);
    }
}
