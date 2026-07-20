<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Notifications\Notifiable;
use Laravel\Sanctum\HasApiTokens;

class User extends Authenticatable
{
    use HasApiTokens, HasFactory, Notifiable;

    protected $fillable = [
        'name',
        'email',
        'password',
        'role',
        'phone_number',
        'farm_name',
        'farm_location',
        'profile_image',
        'is_active',
        'is_verified',
        'last_activity',
    ];

    protected $hidden = [
        'password',
        'remember_token',
    ];

    protected $casts = [
        'email_verified_at' => 'datetime',
        'is_active' => 'boolean',
        'is_verified' => 'boolean',
        'last_activity' => 'datetime',
    ];

    // Roles
    const ROLE_ADMIN = 'admin';
    const ROLE_FARMER = 'farmer';
    const ROLE_VET = 'vet';
    const ROLE_MANAGER = 'manager';
    const ROLE_STAFF = 'staff';

    public function isAdmin()
    {
        return $this->role === self::ROLE_ADMIN;
    }

    public function isFarmer()
    {
        return $this->role === self::ROLE_FARMER;
    }

    public function isVet()
    {
        return $this->role === self::ROLE_VET;
    }

    public function getInitials()
    {
        $words = explode(' ', $this->name);
        $initials = '';
        foreach ($words as $word) {
            if (!empty($word)) {
                $initials .= strtoupper(substr($word, 0, 1));
            }
        }
        return substr($initials, 0, 2);
    }

    // Relationships
    public function farms()
    {
        return $this->hasMany(Farm::class, 'owner_id');
    }

    public function animals()
    {
        return $this->hasMany(Animal::class, 'owner_id');
    }

    public function doctorProfile()
    {
        return $this->hasOne(Doctor::class);
    }

    public function sicknessReports()
    {
        return $this->hasMany(SicknessReport::class, 'reported_by');
    }

    public function sentMessages()
    {
        return $this->hasMany(Message::class, 'sender_id');
    }

    public function receivedMessages()
    {
        return $this->hasMany(Message::class, 'receiver_id');
    }

    public function notifications()
    {
        return $this->hasMany(Notification::class);
    }
}