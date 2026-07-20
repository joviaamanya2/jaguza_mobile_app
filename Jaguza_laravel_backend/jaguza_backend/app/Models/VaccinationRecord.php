<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class VaccinationRecord extends Model
{
    use HasFactory;

    protected $fillable = [
        'animal_id',
        'vaccine_name',
        'vaccine_type',
        'administered_by',
        'administered_date',
        'next_due_date',
        'batch_number',
        'notes',
        'is_completed',
    ];

    protected $casts = [
        'administered_date' => 'date',
        'next_due_date' => 'date',
        'is_completed' => 'boolean',
    ];

    public function animal()
    {
        return $this->belongsTo(Animal::class);
    }

    public function administeredBy()
    {
        return $this->belongsTo(Doctor::class, 'administered_by');
    }

    public function scopeCompleted($query)
    {
        return $query->where('is_completed', true);
    }

    public function scopePending($query)
    {
        return $query->where('is_completed', false);
    }

    public function scopeOverdue($query)
    {
        return $query->where('is_completed', false)
            ->where('next_due_date', '<', now());
    }

    public function isOverdue()
    {
        return !$this->is_completed && $this->next_due_date->isPast();
    }

    public function isDueSoon($days = 7)
    {
        return !$this->is_completed && 
               $this->next_due_date->isFuture() && 
               $this->next_due_date->diffInDays(now()) <= $days;
    }
}