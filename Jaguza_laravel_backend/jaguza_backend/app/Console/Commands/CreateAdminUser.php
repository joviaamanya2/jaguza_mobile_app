<?php

namespace App\Console\Commands;

use App\Models\User;
use Illuminate\Console\Command;
use Illuminate\Support\Facades\Hash;

class CreateUser extends Command
{
    /**
     * The name and signature of the console command.
     *
     * @var string
     */
    protected $signature = 'user:create 
                            {--name= : Full name of the user}
                            {--email= : Email address}
                            {--password= : Password (will prompt if not provided)}
                            {--role=admin : User role (admin, vet, farmer, user)}';

    /**
     * The console command description.
     *
     * @var string
     */
    protected $description = 'Create a new user with custom credentials';

    /**
     * Execute the console command.
     */
    public function handle()
    {
        $this->info("\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");
        $this->info("    🔐 CREATE NEW USER");
        $this->info("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n");

        // Get name
        $name = $this->option('name');
        if (!$name) {
            $name = $this->ask('👤 Full Name');
        }

        // Get email
        $email = $this->option('email');
        if (!$email) {
            $email = $this->ask('📧 Email Address');
        }

        // Validate email
        if (User::where('email', $email)->exists()) {
            $this->error("❌ User with email '{$email}' already exists!");
            return 1;
        }

        // Get password
        $password = $this->option('password');
        if (!$password) {
            $password = $this->secret('🔑 Password (min 8 characters)');
            $confirmPassword = $this->secret('🔑 Confirm Password');
            
            if ($password !== $confirmPassword) {
                $this->error('❌ Passwords do not match!');
                return 1;
            }
        }

        // Get role
        $role = $this->option('role');
        if (!$role) {
            $role = $this->choice('🎭 Select Role', ['admin', 'vet', 'farmer', 'user'], 0);
        }

        // Show summary
        $this->info("\n────────────────────────────────────────────");
        $this->info("📋 Review:");
        $this->info("  Name: $name");
        $this->info("  Email: $email");
        $this->info("  Password: " . str_repeat('•', strlen($password)));
        $this->info("  Role: $role");
        $this->info("────────────────────────────────────────────");

        if (!$this->confirm('✅ Create this user?', true)) {
            $this->info('❌ User creation cancelled.');
            return 0;
        }

        // Create user
        try {
            $user = User::create([
                'name' => $name,
                'email' => $email,
                'password' => Hash::make($password),
                'role' => $role,
                'is_active' => true,
            ]);

            $this->info("\n✅ User created successfully!");
            $this->info("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");
            $this->info("📧 Email: " . $user->email);
            $this->info("🔑 Password: " . $password);
            $this->info("👤 Name: " . $user->name);
            $this->info("🎭 Role: " . $user->role);
            $this->info("🆔 ID: " . $user->id);
            $this->info("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");
            $this->info("\n🔗 Login at: http://localhost:8000/login");

            return 0;
        } catch (\Exception $e) {
            $this->error('❌ Error: ' . $e->getMessage());
            return 1;
        }
    }
}