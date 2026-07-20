<?php

namespace App\Console\Commands;

use Illuminate\Console\Command;

class GenerateAllModules extends Command
{
    protected $signature = 'admin:generate-all';
    protected $description = 'Generate all admin modules';

    public function handle()
    {
        $modules = ['User', 'Doctor', 'Farm', 'Animal', 'Report', 'Video', 'Ad'];
        
        foreach ($modules as $module) {
            $this->call('admin:generate-module', [
                'name' => $module,
                '--fields' => ['name', 'description', 'status']
            ]);
        }
        
        $this->info('All modules generated!');
    }
}