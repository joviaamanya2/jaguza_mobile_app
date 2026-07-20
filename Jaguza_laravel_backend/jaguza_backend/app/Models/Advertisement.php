<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Advertisement extends Model
{
    use HasFactory;

    protected $fillable = [
        'title',
        'description',
        'image_url',
        'video_url',
        'link_url',
        'type',
        'position',
        'status',
        'views_count',
        'clicks_count',
        'budget',
        'cost_per_click',
        'cost_per_view',
        'start_date',
        'end_date',
        'target_audience',
        'target_categories',
        'created_by',
        'approved_by',
        'approved_at',
    ];

    protected $casts = [
        'target_audience' => 'array',
        'target_categories' => 'array',
        'start_date' => 'datetime',
        'end_date' => 'datetime',
        'approved_at' => 'datetime',
        'views_count' => 'integer',
        'clicks_count' => 'integer',
        'budget' => 'decimal:2',
        'cost_per_click' => 'decimal:2',
        'cost_per_view' => 'decimal:2',
    ];

    const TYPES = ['banner', 'sponsored', 'video', 'popup'];
    const STATUSES = ['active', 'pending', 'expired', 'draft'];

    public function creator()
    {
        return $this->belongsTo(User::class, 'created_by');
    }

    public function approver()
    {
        return $this->belongsTo(User::class, 'approved_by');
    }

    public function scopeActive($query)
    {
        return $query->where('status', 'active')
            ->where('start_date', '<=', now())
            ->where(function ($q) {
                $q->where('end_date', '>=', now())
                  ->orWhereNull('end_date');
            });
    }

    public function scopePending($query)
    {
        return $query->where('status', 'pending');
    }

    public function incrementClicks()
    {
        $this->increment('clicks_count');
    }

    public function incrementViews()
    {
        $this->increment('views_count');
    }

    public function isExpired()
    {
        return $this->end_date && $this->end_date->isPast();
    }
}