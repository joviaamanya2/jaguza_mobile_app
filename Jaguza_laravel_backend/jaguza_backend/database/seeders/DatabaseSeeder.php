<?php

namespace Database\Seeders;

use App\Models\User;
use App\Models\Farm;
use App\Models\Animal;
use Illuminate\Database\Seeder;

class DatabaseSeeder extends Seeder
{
    public function run(): void
    {
        // Create admin user
        $admin = User::create([
            'name' => 'Admin',
            'email' => 'admin@jaguza.com',
            'password' => bcrypt('password123'),
            'role' => 'admin',
        ]);

        // Create some farmers
        $farmers = User::factory(5)->create(['role' => 'farmer']);

        // Create farms
        foreach ($farmers as $farmer) {
            $farm = Farm::create([
                'name' => $farmer->name . "'s Farm",
                'owner_id' => $farmer->id,
                'location' => 'Kampala, Uganda',
            ]);

            // Create animals for each farm
            Animal::factory(10)->create(['farm_id' => $farm->id, 'owner_id' => $farmer->id]);
        }
    }
}