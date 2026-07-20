<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Disease extends Model
{
    use HasFactory;

    protected $fillable = [
        'name',
        'scientific_name',
        'species_affected',
        'symptoms',
        'transmission',
        'treatment',
        'prevention',
        'severity',
        'outbreak_risk',
        'incubation_period',
        'vaccine_available',
        'is_active',
    ];

    protected $casts = [
        'vaccine_available' => 'boolean',
        'is_active' => 'boolean',
    ];

    const SEVERITIES = ['low', 'medium', 'high', 'critical'];
    const RISKS = ['low', 'medium', 'high'];

    public function sicknessReports()
    {
        return $this->hasMany(SicknessReport::class);
    }

    public function scopeActive($query)
    {
        return $query->where('is_active', true);
    }

    public function scopeSeverity($query, $severity)
    {
        return $query->where('severity', $severity);
    }

    public function scopeHighRisk($query)
    {
        return $query->where('outbreak_risk', 'high');
    }

    public function isHighRisk()
    {
        return $this->severity === 'high' || $this->severity === 'critical';
    }
}