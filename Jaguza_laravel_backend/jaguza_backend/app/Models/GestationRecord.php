<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class GestationRecord extends Model
{
    use HasFactory;

    protected $fillable = [
        'animal_id',
        'mating_date',
        'expected_delivery_date',
        'actual_delivery_date',
        'is_verified',
        'notes',
        'vet_name',
        'is_active',
    ];

    protected $casts = [
        'mating_date' => 'date',
        'expected_delivery_date' => 'date',
        'actual_delivery_date' => 'date',
        'is_verified' => 'boolean',
        'is_active' => 'boolean',
    ];

    public function animal()
    {
        return $this->belongsTo(Animal::class);
    }

    public function scopeActive($query)
    {
        return $query->where('is_active', true);
    }

    public function scopeDue($query, $days = 7)
    {
        return $query->whereNull('actual_delivery_date')
            ->whereBetween('expected_delivery_date', [now(), now()->addDays($days)]);
    }

    public function isDue()
    {
        return $this->expected_delivery_date->isFuture() && 
               $this->expected_delivery_date->diffInDays(now()) <= 7;
    }

    public function isOverdue()
    {
        return $this->expected_delivery_date->isPast() && 
               $this->actual_delivery_date === null;
    }

    public function getProgressPercentage()
    {
        if (!$this->mating_date || !$this->expected_delivery_date) {
            return 0;
        }
        $total = $this->mating_date->diffInDays($this->expected_delivery_date);
        $passed = $this->mating_date->diffInDays(now());
        return min(100, round(($passed / $total) * 100));
    }
}