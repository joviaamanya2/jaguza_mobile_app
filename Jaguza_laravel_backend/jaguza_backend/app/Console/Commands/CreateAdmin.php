<?php

namespace App\Console\Commands;

use App\Models\User;
use Illuminate\Console\Command;
use Illuminate\Support\Facades\Hash;

class CreateAdmin extends Command
{
    protected $signature = 'admin:create';
    protected $description = 'Create an admin user';

    public function handle()
    {
        $this->info('🔐 Create Admin User');
        $this->line('─────────────────────────────');
        
        // Get email
        $email = $this->ask('Enter admin email');
        
        // Validate email
        while (!filter_var($email, FILTER_VALIDATE_EMAIL)) {
            $this->error('❌ Invalid email format.');
            $email = $this->ask('Enter admin email');
        }
        
        // Check if email exists
        if (User::where('email', $email)->exists()) {
            $this->error('❌ A user with this email already exists!');
            return 1;
        }
        
        // Get name
        $name = $this->ask('Enter admin full name');
        
        while (empty(trim($name))) {
            $this->error('❌ Name cannot be empty.');
            $name = $this->ask('Enter admin full name');
        }
        
        // Get password (hidden)
        $password = $this->secret('Enter admin password (min 8 chars)');
        
        while (strlen($password) < 8) {
            $this->error('❌ Password must be at least 8 characters.');
            $password = $this->secret('Enter admin password (min 8 chars)');
        }
        
        // Confirm password
        $confirm = $this->secret('Confirm password');
        while ($password !== $confirm) {
            $this->error('❌ Passwords do not match.');
            $confirm = $this->secret('Confirm password');
        }
        
        // Show summary
        $this->line('');
        $this->info('📋 Admin Details:');
        $this->line("   Name:  {$name}");
        $this->line("   Email: {$email}");
        $this->line('');
        
        if (!$this->confirm('Confirm create admin user?', true)) {
            $this->info('❌ Admin creation cancelled.');
            return 0;
        }
        
        // Create admin
        try {
            User::create([
                'name' => $name,
                'email' => $email,
                'password' => Hash::make($password),
                'role' => 'admin',
                'is_active' => true,
            ]);
            
            $this->line('');
            $this->info('✅ Admin created successfully!');
            $this->line('');
            $this->info('📋 Login Credentials:');
            $this->line("   Email:    {$email}");
            $this->line("   Password: ******** (hidden)");
            $this->line('');
            // Fixed: Show correct URL with port
            $this->info('🔗 Login URL: http://127.0.0.1:8000/login');
            
            return 0;
            
        } catch (\Exception $e) {
            $this->error('❌ Failed to create admin: ' . $e->getMessage());
            return 1;
        }
    }
}