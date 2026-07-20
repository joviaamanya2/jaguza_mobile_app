<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class AiChatMessage extends Model
{
    use HasFactory;

    protected $fillable = [
        'user_id',
        'user_message',
        'bot_response',
        'metadata',
        'intent',
        'confidence_score',
        'feedback',
        'session_id',
        'is_archived',
    ];

    protected $casts = [
        'metadata' => 'array',
        'confidence_score' => 'decimal:2',
        'is_archived' => 'boolean',
    ];

    public function user()
    {
        return $this->belongsTo(User::class);
    }

    public function scopeSession($query, $sessionId)
    {
        return $query->where('session_id', $sessionId);
    }

    public function scopeByUser($query, $userId)
    {
        return $query->where('user_id', $userId);
    }

    public function scopeHelpful($query)
    {
        return $query->where('feedback', 'helpful');
    }

    public function scopeNotHelpful($query)
    {
        return $query->where('feedback', 'not_helpful');
    }
}