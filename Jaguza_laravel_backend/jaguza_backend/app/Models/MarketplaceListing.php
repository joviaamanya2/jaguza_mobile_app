<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class MarketplaceListing extends Model
{
    use HasFactory;

    protected $fillable = [
        'seller_id',
        'title',
        'description',
        'category',
        'price',
        'currency',
        'location',
        'images',
        'status',
        'views_count',
        'expires_at',
    ];

    protected $casts = [
        'images' => 'array',
        'price' => 'decimal:2',
        'views_count' => 'integer',
        'expires_at' => 'datetime',
    ];

    const STATUSES = ['active', 'pending', 'sold', 'expired'];
    const CATEGORIES = ['livestock', 'poultry', 'feed', 'medicine', 'equipment', 'services', 'other'];

    public function seller()
    {
        return $this->belongsTo(User::class, 'seller_id');
    }

    public function scopeActive($query)
    {
        return $query->where('status', 'active')
            ->where(function($q) {
                $q->where('expires_at', '>=', now())
                  ->orWhereNull('expires_at');
            });
    }

    public function scopeCategory($query, $category)
    {
        return $query->where('category', $category);
    }

    public function incrementViews()
    {
        $this->increment('views_count');
    }

    public function isActive()
    {
        return $this->status === 'active' && 
               ($this->expires_at === null || $this->expires_at->isFuture());
    }
}