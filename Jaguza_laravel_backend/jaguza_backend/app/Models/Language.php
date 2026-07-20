<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Language extends Model
{
    use HasFactory;

    protected $fillable = [
        'code',
        'name',
        'native_name',
        'flag',
        'direction',
        'timezone',
        'date_format',
        'currency',
        'currency_symbol',
        'order',
        'is_active',
        'is_default',
        'translations',
    ];

    protected $casts = [
        'translations' => 'array',
        'is_active' => 'boolean',
        'is_default' => 'boolean',
        'order' => 'integer',
    ];

    public function scopeActive($query)
    {
        return $query->where('is_active', true);
    }

    public function scopeDefault($query)
    {
        return $query->where('is_default', true);
    }

    public static function getDefault()
    {
        return static::where('is_default', true)->first();
    }

    public static function getTranslation($key, $langCode = null)
    {
        if (!$langCode) {
            $langCode = app()->getLocale();
        }
        
        $language = static::where('code', $langCode)->first();
        if ($language && $language->translations) {
            return $language->translations[$key] ?? $key;
        }
        
        return $key;
    }
}