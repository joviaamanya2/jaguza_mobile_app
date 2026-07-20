<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Doctor extends Model
{
    use HasFactory;

    protected $fillable = [
        'user_id',
        'specialization',
        'license_number',
        'years_of_experience',
        'location',
        'phone_number',
        'consultation_fee',
        'is_available',
        'rating',
        'total_cases',
        'bio',
    ];

    protected $casts = [
        'is_available' => 'boolean',
        'consultation_fee' => 'decimal:2',
        'rating' => 'decimal:2',
        'total_cases' => 'integer',
        'years_of_experience' => 'integer',
    ];

    public function user()
    {
        return $this->belongsTo(User::class);
    }

    public function sicknessReports()
    {
        return $this->hasMany(SicknessReport::class);
    }

    public function scopeAvailable($query)
    {
        return $query->where('is_available', true);
    }

    public function scopeTopRated($query)
    {
        return $query->orderBy('rating', 'desc');
    }

    public function getFullNameAttribute()
    {
        return $this->user->name ?? 'Unknown';
    }

    public function getInitialsAttribute()
    {
        $name = $this->user->name ?? '';
        $words = explode(' ', $name);
        $initials = '';
        foreach ($words as $word) {
            if (!empty($word)) {
                $initials .= strtoupper(substr($word, 0, 1));
            }
        }
        return substr($initials, 0, 2);
    }
}