<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class DecisionSupport extends Model
{
    use HasFactory;

    protected $table = 'decision_support';

    protected $fillable = [
        'title',
        'category',
        'sub_category',
        'content',
        'summary',
        'keywords',
        'image',
        'video_url',
        'document_url',
        'difficulty_level',
        'views_count',
        'helpful_count',
        'is_featured',
        'is_published',
        'created_by',
    ];

    protected $casts = [
        'keywords' => 'array',
        'is_featured' => 'boolean',
        'is_published' => 'boolean',
        'views_count' => 'integer',
        'helpful_count' => 'integer',
    ];

    // Categories
    const CATEGORIES = [
        'cattle' => 'Cattle',
        'goat' => 'Goat',
        'sheep' => 'Sheep',
        'pig' => 'Pig',
        'poultry' => 'Poultry',
        'rabbit' => 'Rabbit',
        'general' => 'General',
    ];

    const SUB_CATEGORIES = [
        'feeding' => 'Feeding & Nutrition',
        'health' => 'Health & Disease',
        'breeding' => 'Breeding & Reproduction',
        'marketing' => 'Marketing & Sales',
        'management' => 'Farm Management',
        'housing' => 'Housing & Facilities',
        'general' => 'General Advice',
    ];

    public function creator()
    {
        return $this->belongsTo(User::class, 'created_by');
    }

    public function scopeFeatured($query)
    {
        return $query->where('is_featured', true);
    }

    public function scopePublished($query)
    {
        return $query->where('is_published', true);
    }

    public function scopeCategory($query, $category)
    {
        return $query->where('category', $category);
    }
}