<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Animal extends Model
{
    use HasFactory;

    protected $fillable = [
        'name,type,breed,age,farm_id'
    ];

    protected $casts = [
        // Add casts here if needed
    ];

    // Add relationships here
}