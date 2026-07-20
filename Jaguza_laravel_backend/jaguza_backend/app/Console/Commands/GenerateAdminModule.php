<?php

namespace App\Console\Commands;

use Illuminate\Console\Command;
use Illuminate\Filesystem\Filesystem;
use Illuminate\Support\Str;

class GenerateAdminModule extends Command
{
    protected $signature = 'admin:generate-module 
                            {name : The module name (e.g., Doctor)} 
                            {--fields=* : Fields for the module}
                            {--all : Generate all modules at once}';
    
    protected $description = 'Generate a complete admin module with CRUD';

    protected $filesystem;

    public function __construct(Filesystem $filesystem)
    {
        parent::__construct();
        $this->filesystem = $filesystem;
    }

    public function handle()
    {
        if ($this->option('all')) {
            $this->generateAllModules();
            return;
        }

        $name = $this->argument('name');
        
        // Fix: Properly parse fields - handle both string and array formats
        $fields = $this->getFieldsFromInput();
        
        // If no fields provided, use defaults
        if (empty($fields)) {
            $fields = ['name', 'description', 'status'];
        }
        
        $this->generateModule($name, $fields);
    }

    /**
     * Properly parse fields from input
     */
    private function getFieldsFromInput()
    {
        $fields = [];
        $rawFields = $this->option('fields');
        
        foreach ($rawFields as $field) {
            // If field is like "name:string", extract just "name"
            if (str_contains($field, ':')) {
                $parts = explode(':', $field);
                $fields[] = $parts[0];
            } 
            // If field is like "name" (simple string)
            else if (is_string($field) && !is_array($field)) {
                $fields[] = $field;
            }
            // If field is somehow an array, skip it
            else if (is_array($field)) {
                foreach ($field as $subField) {
                    if (is_string($subField)) {
                        if (str_contains($subField, ':')) {
                            $parts = explode(':', $subField);
                            $fields[] = $parts[0];
                        } else {
                            $fields[] = $subField;
                        }
                    }
                }
            }
        }
        
        return array_unique($fields);
    }

    private function generateAllModules()
    {
        $modules = [
            'Doctor' => ['name', 'specialization', 'location', 'phone', 'license_number'],
            'Farm' => ['name', 'location', 'owner_id', 'size'],
            'Animal' => ['name', 'type', 'breed', 'age', 'farm_id'],
            'Report' => ['title', 'description', 'status', 'animal_id'],
            'Video' => ['title', 'url', 'duration', 'views'],
            'Ad' => ['title', 'description', 'status', 'expires_at'],
        ];

        foreach ($modules as $name => $fields) {
            $this->info("Generating module: {$name}");
            $this->generateModule($name, $fields);
            $this->info("✓ Module {$name} generated");
            $this->newLine();
        }

        $this->info('All modules generated successfully!');
        $this->info('Don\'t forget to run: php artisan migrate');
    }

    private function generateModule($name, $fields)
    {
        $slug = Str::snake(Str::plural($name));
        $studly = Str::studly($name);
        $plural = Str::plural($studly);
        $variable = Str::camel($plural);
        $lower = Str::lower($name);
        
        // 1. Create directory structure
        $this->createDirectories($slug);
        
        // 2. Generate Model
        $this->generateModel($studly, $fields);
        
        // 3. Generate Migration
        $this->generateMigration($slug, $fields);
        
        // 4. Generate Controller
        $this->generateController($studly, $slug, $variable);
        
        // 5. Generate View files
        $this->generateIndexView($studly, $slug, $variable, $fields);
        $this->generateModalsView($studly, $slug, $fields);
        
        // 6. Update routes
        $this->updateRoutes($slug, $studly);
        
        // 7. Update sidebar
        $this->updateSidebar($name, $slug);
    }

    private function createDirectories($slug)
    {
        $directories = [
            "resources/views/admin/{$slug}",
        ];

        foreach ($directories as $dir) {
            if (!$this->filesystem->isDirectory($dir)) {
                $this->filesystem->makeDirectory($dir, 0755, true);
                $this->line("Created directory: {$dir}");
            }
        }
    }

    private function generateModel($name, $fields)
    {
        $fillable = array_map(function($field) {
            return "'" . trim($field) . "'";
        }, $fields);
        
        $fillableString = implode(",\n        ", $fillable);
        
        $modelContent = <<<PHP
<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class {$name} extends Model
{
    use HasFactory;

    protected \$fillable = [
        {$fillableString}
    ];

    protected \$casts = [
        // Add casts here if needed
    ];

    // Add relationships here
}
PHP;

        $this->filesystem->put("app/Models/{$name}.php", $modelContent);
        $this->line("Created Model: app/Models/{$name}.php");
    }

    private function generateMigration($slug, $fields)
    {
        $fieldDefinitions = '';
        foreach ($fields as $field) {
            $cleanField = trim($field);
            if (!empty($cleanField)) {
                $fieldDefinitions .= "            \$table->string('{$cleanField}')->nullable();\n";
            }
        }

        $migrationContent = <<<PHP
<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up()
    {
        Schema::create('{$slug}', function (Blueprint \$table) {
            \$table->id();
            {$fieldDefinitions}
            \$table->timestamps();
        });
    }

    public function down()
    {
        Schema::dropIfExists('{$slug}');
    }
};
PHP;

        $timestamp = now()->format('Y_m_d_His');
        $this->filesystem->put(
            "database/migrations/{$timestamp}_create_{$slug}_table.php",
            $migrationContent
        );
        $this->line("Created Migration: database/migrations/{$timestamp}_create_{$slug}_table.php");
    }

    private function generateController($name, $slug, $variable)
    {
        $controllerContent = <<<PHP
<?php

namespace App\Http\Controllers\Admin;

use App\Models\\{$name};
use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
use Illuminate\Support\Facades\Validator;

class {$name}Controller extends Controller
{
    public function index()
    {
        \${$variable} = {$name}::all();
        return view('admin.{$slug}.index', compact('{$variable}'));
    }
    
    public function store(Request \$request)
    {
        \$validator = Validator::make(\$request->all(), [
            // Add validation rules here
        ]);
        
        if (\$validator->fails()) {
            return response()->json([
                'success' => false,
                'errors' => \$validator->errors()
            ], 422);
        }
        
        \$item = {$name}::create(\$request->all());
        
        return response()->json([
            'success' => true,
            'data' => \$item,
            'message' => 'Created successfully'
        ]);
    }
    
    public function show(\$id)
    {
        \$item = {$name}::find(\$id);
        if (!\$item) {
            return response()->json([
                'success' => false,
                'message' => 'Not found'
            ], 404);
        }
        return response()->json([
            'success' => true,
            'data' => \$item
        ]);
    }
    
    public function update(Request \$request, \$id)
    {
        \$item = {$name}::find(\$id);
        if (!\$item) {
            return response()->json([
                'success' => false,
                'message' => 'Not found'
            ], 404);
        }
        
        \$validator = Validator::make(\$request->all(), [
            // Add validation rules here
        ]);
        
        if (\$validator->fails()) {
            return response()->json([
                'success' => false,
                'errors' => \$validator->errors()
            ], 422);
        }
        
        \$item->update(\$request->all());
        
        return response()->json([
            'success' => true,
            'data' => \$item,
            'message' => 'Updated successfully'
        ]);
    }
    
    public function destroy(\$id)
    {
        \$item = {$name}::find(\$id);
        if (!\$item) {
            return response()->json([
                'success' => false,
                'message' => 'Not found'
            ], 404);
        }
        \$item->delete();
        
        return response()->json([
            'success' => true,
            'message' => 'Deleted successfully'
        ]);
    }
}
PHP;

        $controllerPath = "app/Http/Controllers/Admin/{$name}Controller.php";
        $this->ensureDirectoryExists(dirname($controllerPath));
        $this->filesystem->put($controllerPath, $controllerContent);
        $this->line("Created Controller: {$controllerPath}");
    }

    private function ensureDirectoryExists($path)
    {
        if (!$this->filesystem->isDirectory($path)) {
            $this->filesystem->makeDirectory($path, 0755, true);
        }
    }

    private function generateIndexView($name, $slug, $variable, $fields)
    {
        // Build table headers
        $headers = '';
        $rowFields = '';
        foreach ($fields as $field) {
            $cleanField = trim($field);
            if (empty($cleanField)) continue;
            
            $header = ucfirst(str_replace('_', ' ', $cleanField));
            $headers .= "                    <th>{$header}</th>\n";
            $rowFields .= "                    <td>{{ \$item->{$cleanField} ?? 'N/A' }}</td>\n";
        }

        $viewContent = <<<PHP
@extends('admin.layouts.app')

@section('title', '{$name}s')

@section('content')
<div class="section-heading">
    <h2><i class="fas fa-{$this->getIcon($name)}" style="color:#{$this->getColor($name)};margin-right:8px;"></i>{$name}s</h2>
    <button class="btn btn-primary" onclick="openAdd{$name}Modal()">+ Add {$name}</button>
</div>

<div class="card">
    <div class="table-wrap">
        <table>
            <thead>
                <tr>
                    <th>#</th>
                    {$headers}
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                @forelse(\${$variable} as \$item)
                <tr>
                    <td>{{ \$loop->iteration }}</td>
                    {$rowFields}
                    <td>
                        <button class="btn btn-outline" style="padding:4px 10px;font-size:11px;" onclick="edit{$name}(\$item->id)">
                            <i class="fas fa-edit"></i> Edit
                        </button>
                        <button class="btn btn-outline" style="padding:4px 10px;font-size:11px;color:var(--red);" onclick="delete{$name}(\$item->id)">
                            <i class="fas fa-trash"></i>
                        </button>
                    </td>
                </tr>
                @empty
                <tr>
                    <td colspan="100%" style="text-align:center;padding:40px;color:#6a7a8a;">
                        <i class="fas fa-{$this->getIcon($name)}" style="font-size:40px;display:block;margin-bottom:10px;color:#c8d0d8;"></i>
                        No {$name}s found. Click the "Add {$name}" button to create one.
                    </td>
                </tr>
                @endforelse
            </tbody>
        </table>
    </div>
</div>
@endsection

@section('modals')
@include('admin.{$slug}.modals')
@endsection
PHP;

        $viewPath = "resources/views/admin/{$slug}/index.blade.php";
        $this->ensureDirectoryExists(dirname($viewPath));
        $this->filesystem->put($viewPath, $viewContent);
        $this->line("Created View: {$viewPath}");
    }

    private function generateModalsView($name, $slug, $fields)
    {
        // Build form fields
        $formFields = '';
        $resetFields = '';
        $jsFields = '';
        $jsSetFields = '';
        
        foreach ($fields as $field) {
            $cleanField = trim($field);
            if (empty($cleanField)) continue;
            
            $label = ucfirst(str_replace('_', ' ', $cleanField));
            $formFields .= <<<HTML
            <div class="form-group">
                <label>{$label} <span class="required">*</span></label>
                <input type="text" id="{$slug}_{$cleanField}" class="form-control" placeholder="Enter {$label}" required>
            </div>
            
HTML;
            
            $resetFields .= "        document.getElementById('{$slug}_{$cleanField}').value = '';\n";
            $jsFields .= "            {$cleanField}: document.getElementById('{$slug}_{$cleanField}').value,\n";
            $jsSetFields .= "                    document.getElementById('{$slug}_{$cleanField}').value = item.{$cleanField} || '';\n";
        }

        $viewContent = <<<PHP
<!-- ===== {$name} MODAL ===== -->
<div class="modal-overlay" id="{$slug}Modal">
    <div class="modal-box">
        <div class="modal-header">
            <h3 id="{$slug}ModalTitle">Add New {$name}</h3>
            <button class="modal-close" onclick="closeModal('{$slug}Modal')">&times;</button>
        </div>
        <form id="{$slug}Form" onsubmit="event.preventDefault(); save{$name}();">
            <input type="hidden" id="{$slug}Id">
            
            {$formFields}
            
            <div class="modal-footer">
                <button type="submit" class="btn btn-primary" id="{$slug}SubmitBtn">Save {$name}</button>
                <button type="button" class="btn btn-outline" onclick="closeModal('{$slug}Modal')">Cancel</button>
            </div>
        </form>
    </div>
</div>

@push('scripts')
<script>
    function reset{$name}Form() {
        document.getElementById('{$slug}Id').value = '';
{$resetFields}
        document.getElementById('{$slug}ModalTitle').textContent = 'Add New {$name}';
        document.getElementById('{$slug}SubmitBtn').textContent = 'Save {$name}';
    }
    
    function openAdd{$name}Modal() {
        reset{$name}Form();
        openModal('{$slug}Modal');
    }
    
    function edit{$name}(id) {
        showToast('Loading data...', 'info');
        fetch(`\${API_URL}/{$slug}/\${id}`, { headers: getHeaders() })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    const item = data.data;
                    document.getElementById('{$slug}Id').value = item.id;
{$jsSetFields}
                    document.getElementById('{$slug}ModalTitle').textContent = 'Edit {$name}';
                    document.getElementById('{$slug}SubmitBtn').textContent = 'Update {$name}';
                    openModal('{$slug}Modal');
                } else {
                    showToast(data.message || 'Error loading data', 'error');
                }
            })
            .catch(error => showToast('Error: ' + error.message, 'error'));
    }
    
    function delete{$name}(id) {
        if (!confirm('⚠️ Are you sure you want to delete this {$name}?')) return;
        fetch(`\${API_URL}/{$slug}/\${id}`, { method: 'DELETE', headers: getHeaders() })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    showToast('Deleted successfully!');
                    setTimeout(() => location.reload(), 1000);
                } else {
                    showToast(data.message || 'Error deleting', 'error');
                }
            })
            .catch(error => showToast('Error: ' + error.message, 'error'));
    }
    
    function save{$name}() {
        const id = document.getElementById('{$slug}Id').value;
        const data = {
{$jsFields}
        };
        
        const url = id ? `\${API_URL}/{$slug}/\${id}` : `\${API_URL}/{$slug}`;
        const method = id ? 'PUT' : 'POST';
        const submitBtn = document.getElementById('{$slug}SubmitBtn');
        submitBtn.disabled = true;
        submitBtn.textContent = 'Saving...';
        
        fetch(url, { 
            method: method, 
            headers: getHeaders(), 
            body: JSON.stringify(data) 
        })
        .then(response => response.json())
        .then(data => {
            submitBtn.disabled = false;
            submitBtn.textContent = id ? 'Update {$name}' : 'Save {$name}';
            if (data.success) {
                showToast(id ? 'Updated successfully!' : 'Created successfully!');
                closeModal('{$slug}Modal');
                setTimeout(() => location.reload(), 1000);
            } else {
                let errors = '';
                if (data.errors) {
                    Object.values(data.errors).forEach(error => errors += error + '\n');
                    showToast(errors, 'error');
                } else {
                    showToast(data.message || 'Error saving', 'error');
                }
            }
        })
        .catch(error => {
            submitBtn.disabled = false;
            submitBtn.textContent = id ? 'Update {$name}' : 'Save {$name}';
            showToast('Network error: ' + error.message, 'error');
        });
    }
</script>
@endpush
PHP;

        $viewPath = "resources/views/admin/{$slug}/modals.blade.php";
        $this->ensureDirectoryExists(dirname($viewPath));
        $this->filesystem->put($viewPath, $viewContent);
        $this->line("Created View: {$viewPath}");
    }

    private function updateRoutes($slug, $controller)
    {
        $routesFile = base_path('routes/api.php');
        $routeContent = "\nRoute::resource('{$slug}', Admin\\{$controller}Controller::class);";
        
        // Check if route already exists
        if ($this->filesystem->exists($routesFile)) {
            $current = $this->filesystem->get($routesFile);
            if (!str_contains($current, "Route::resource('{$slug}'")) {
                $this->filesystem->append($routesFile, $routeContent);
                $this->line("Updated routes/api.php with: Route::resource('{$slug}', Admin\\{$controller}Controller::class);");
            }
        }
    }

    private function updateSidebar($name, $slug)
    {
        $sidebarFile = 'resources/views/admin/layouts/sidebar.blade.php';
        
        if (!$this->filesystem->exists($sidebarFile)) {
            $this->warn("Sidebar file not found. Please manually add navigation for {$name}");
            return;
        }
        
        $navItem = <<<HTML
    <a class="nav-item" id="nav-{$slug}" onclick="navigate('{$slug}','{$name}s')">
        <div class="nav-icon"><i class="fas fa-{$this->getIcon($name)}"></i></div>
        <span class="nav-label">{$name}s</span>
    </a>
HTML;
        
        $current = $this->filesystem->get($sidebarFile);
        
        if (!str_contains($current, "nav-{$slug}")) {
            $insertPos = strpos($current, '<!-- Other -->');
            if ($insertPos === false) {
                $insertPos = strrpos($current, '</div>');
            }
            
            $newContent = substr($current, 0, $insertPos) . $navItem . "\n" . substr($current, $insertPos);
            $this->filesystem->put($sidebarFile, $newContent);
            $this->line("Updated sidebar with: {$name}s");
        }
    }

    private function getIcon($name)
    {
        $icons = [
            'Doctor' => 'stethoscope',
            'Farm' => 'warehouse',
            'Animal' => 'horse',
            'Report' => 'file-medical',
            'Video' => 'play-circle',
            'Ad' => 'bullhorn',
            'User' => 'users',
            'Message' => 'comments',
            'Notification' => 'bell',
            'Vaccination' => 'syringe',
            'Disease' => 'virus',
            'Marketplace' => 'store',
        ];
        return $icons[$name] ?? 'cube';
    }

    private function getColor($name)
    {
        $colors = [
            'Doctor' => '0d6efd',
            'Farm' => 'fd7e14',
            'Animal' => '4a148c',
            'Report' => 'dc3545',
            'Video' => '2e7d32',
            'Ad' => 'f57c00',
            'User' => '2e7d32',
            'Message' => '0d6efd',
            'Notification' => 'fd7e14',
            'Vaccination' => '0d6efd',
            'Disease' => 'fd7e14',
            'Marketplace' => 'fd7e14',
        ];
        return $colors[$name] ?? '6c757d';
    }
}