<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class SicknessReport extends Model
{
    use HasFactory;

    protected $fillable = [
        'report_id',
        'animal_id',
        'disease_id',
        'symptoms',
        'reported_by',
        'doctor_id',
        'status',
        'diagnosis',
        'treatment',
        'medications',
        'reported_date',
        'resolved_date',
        'notes',
    ];

    const STATUS = ['open', 'treating', 'resolved', 'critical', 'referred'];

    public function animal()
    {
        return $this->belongsTo(Animal::class);
    }

    public function disease()
    {
        return $this->belongsTo(Disease::class);
    }

    public function reporter()
    {
        return $this->belongsTo(User::class, 'reported_by');
    }

    public function doctor()
    {
        return $this->belongsTo(Doctor::class);
    }
}