<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Farm extends Model
{
    use HasFactory;

    protected $fillable = [
        'user_id',          // This maps to the user who owns the farm
        'farm_name',        // This is 'farm_name' in your DB, not 'name'
        'owner_name',
        'owner_id',         // This might be the same as user_id
        'location',
        'latitude',
        'longitude',
        'size',
        'description',
        'registration_date',
        // Add these if they exist in your DB
        'established_year',
        'coordinates',
        'facilities',
        'image',
        'is_active',
    ];

    protected $casts = [
        'facilities' => 'array',
        'is_active' => 'boolean',
        'latitude' => 'decimal:8',
        'longitude' => 'decimal:8',
        'size' => 'decimal:2',
    ];

    public function user()
    {
        return $this->belongsTo(User::class, 'user_id');
    }

    public function animals()
    {
        return $this->hasMany(Animal::class);
    }

    public function scopeActive($query)
    {
        return $query->where('is_active', true);
    }
     // Relationship to the user who owns the farm
    

    // Relationship to the owner (if owner_id is different from user_id)
    public function owner()
    {
        return $this->belongsTo(User::class, 'owner_id');
    }

    public function getTotalAnimalsAttribute()
    {
        return $this->animals()->count();
    }
}