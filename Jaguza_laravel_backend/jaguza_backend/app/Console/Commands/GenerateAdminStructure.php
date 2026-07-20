<?php

namespace App\Console\Commands;

use Illuminate\Console\Command;
use Illuminate\Filesystem\Filesystem;

class GenerateAdminStructure extends Command
{
    protected $signature = 'admin:generate-structure';
    protected $description = 'Generate the complete admin dashboard folder structure';

    public function handle(Filesystem $filesystem)
    {
        $directories = [
            // Layouts
            'resources/views/admin/layouts',
            
            // Dashboard
            'resources/views/admin/dashboard',
            'resources/views/admin/partials',
            
            // Main modules
            'resources/views/admin/users',
            'resources/views/admin/doctors',
            'resources/views/admin/messages',
            'resources/views/admin/notifications',
            'resources/views/admin/farms',
            'resources/views/admin/livestock',
            'resources/views/admin/gestation',
            'resources/views/admin/vaccinations',
            'resources/views/admin/sickness',
            'resources/views/admin/disease',
            'resources/views/admin/decision',
            'resources/views/admin/marketplace',
            'resources/views/admin/videos',
            'resources/views/admin/ads',
            'resources/views/admin/weather',
            'resources/views/admin/aichat',
            'resources/views/admin/settings',
            'resources/views/admin/modals',
        ];

        foreach ($directories as $directory) {
            if (!$filesystem->isDirectory($directory)) {
                $filesystem->makeDirectory($directory, 0755, true);
                $this->info("Created directory: {$directory}");
            }
        }

        $this->info('Admin structure generated successfully!');
    }
}