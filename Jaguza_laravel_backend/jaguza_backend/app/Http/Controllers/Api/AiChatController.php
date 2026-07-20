<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\AiChatMessage;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;

class AiChatController extends Controller
{
    public function history(Request $request)
    {
        $user = $request->user();
        $history = AiChatMessage::where('user_id', $user->id ?? 1)
            ->orderBy('created_at', 'asc')
            ->get();

        return response()->json([
            'success' => true,
            'data' => $history
        ]);
    }

    public function sendMessage(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'message' => 'required|string',
        ]);

        if ($validator->fails()) {
            return response()->json(['success' => false, 'errors' => $validator->errors()], 422);
        }

        $userId = $request->user()->id ?? 1;

        // Save user message
        $userMsg = AiChatMessage::create([
            'user_id' => $userId,
            'sender' => 'user',
            'message' => $request->message,
        ]);

        // Mock AI reply
        $reply = "Thank you for your message! This is JaguzaAI. Please check with an available doctor if symptoms persist.";
        $aiMsg = AiChatMessage::create([
            'user_id' => $userId,
            'sender' => 'ai',
            'message' => $reply,
        ]);

        return response()->json([
            'success' => true,
            'user_message' => $userMsg,
            'ai_response' => $aiMsg
        ]);
    }

    public function clearHistory(Request $request)
    {
        $userId = $request->user()->id ?? 1;
        AiChatMessage::where('user_id', $userId)->delete();
        return response()->json(['success' => true, 'message' => 'Chat history cleared successfully']);
    }

    public function feedback(Request $request, $id)
    {
        $message = AiChatMessage::find($id);
        if (!$message) {
            return response()->json(['success' => false, 'message' => 'Message not found'], 404);
        }

        $message->update(['feedback' => $request->feedback ?? 'helpful']);

        return response()->json([
            'success' => true,
            'message' => 'Feedback saved successfully',
            'data' => $message
        ]);
    }
}
