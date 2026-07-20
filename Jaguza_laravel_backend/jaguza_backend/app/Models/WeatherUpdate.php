<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class WeatherUpdate extends Model
{
    use HasFactory;

    protected $fillable = [
        'location',
        'region',
        'country',
        'temperature',
        'feels_like',
        'condition',
        'icon',
        'humidity',
        'wind_speed',
        'wind_direction',
        'precipitation',
        'uv_index',
        'forecast',
        'advisory',
        'weather_data_time',
        'sunrise',
        'sunset',
        'last_fetched_at',
        'source',
    ];

    protected $casts = [
        'forecast' => 'array',
        'advisory' => 'array',
        'temperature' => 'decimal:1',
        'feels_like' => 'decimal:1',
        'wind_speed' => 'decimal:2',
        'precipitation' => 'decimal:2',
        'uv_index' => 'decimal:1',
        'weather_data_time' => 'datetime',
        'sunrise' => 'datetime',
        'sunset' => 'datetime',
        'last_fetched_at' => 'datetime',
    ];

    public function scopeLocation($query, $location)
    {
        return $query->where('location', 'like', "%{$location}%");
    }

    public function scopeRecent($query)
    {
        return $query->orderBy('weather_data_time', 'desc');
    }

    public function getTemperatureCelsiusAttribute()
    {
        return $this->temperature;
    }

    public function getTemperatureFahrenheitAttribute()
    {
        return round(($this->temperature * 9/5) + 32, 1);
    }

    public function isRaining()
    {
        return in_array(strtolower($this->condition), ['rain', 'showers', 'thunderstorm']);
    }

    public function isHot()
    {
        return $this->temperature > 30;
    }

    public function isCold()
    {
        return $this->temperature < 15;
    }
}