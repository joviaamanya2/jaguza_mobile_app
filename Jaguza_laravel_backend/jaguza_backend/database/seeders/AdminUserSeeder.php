<?php

namespace Database\Seeders;

use App\Models\User;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\Hash;

class AdminUserSeeder extends Seeder
{
    public function run(): void
    {
        // Change these to your credentials
        $email = 'admin@jaguza.com';  // CHANGE THIS
        $password = 'jovia1234';         // CHANGE THIS
        $name = 'Jovia';                 // CHANGE THIS
        
        // Check if user already exists
        $user = User::where('email', $email)->first();
        
        if (!$user) {
            User::create([
                'name' => $name,
                'email' => $email,
                'password' => Hash::make($password),
                'role' => 'admin',
                'is_active' => true,
            ]);
            $this->command->info('✅ Admin user created successfully!');
            $this->command->info("Email: {$email}");
            $this->command->info("Password: {$password}");
        } else {
            $this->command->info('⚠️ User already exists!');
            $this->command->info("Email: {$email}");
        }
    }
}