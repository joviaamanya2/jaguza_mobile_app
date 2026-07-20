<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\AuthController;
use App\Http\Controllers\DashboardController;

// Guest routes (public)
Route::middleware(['guest'])->group(function () {
    Route::get('/login', [AuthController::class, 'showLogin'])->name('login');
    Route::post('/login', [AuthController::class, 'login']);
});

// Protected admin routes
Route::middleware(['auth', 'admin'])->group(function () {
    Route::get('/dashboard', [DashboardController::class, 'index'])->name('dashboard');
    Route::get('/', function () {
        return redirect('/dashboard');
    });
    Route::post('/logout', [AuthController::class, 'logout'])->name('logout');

    // Admin CRUD routes
    Route::prefix('admin')->name('admin.')->group(function () {
        // Users
        Route::post('/users', [\App\Http\Controllers\Api\UserController::class, 'store']);
        Route::put('/users/{id}', [\App\Http\Controllers\Api\UserController::class, 'update']);
        Route::delete('/users/{id}', [\App\Http\Controllers\Api\UserController::class, 'destroy']);
        Route::post('/users/{id}/toggle-status', [\App\Http\Controllers\Api\UserController::class, 'toggleStatus']);
        
        // Animals
        Route::post('/animals', [\App\Http\Controllers\Admin\AdminAnimalController::class, 'store']);
        Route::put('/animals/{id}', [\App\Http\Controllers\Admin\AdminAnimalController::class, 'update']);
        Route::delete('/animals/{id}', [\App\Http\Controllers\Admin\AdminAnimalController::class, 'destroy']);
        Route::post('/animals/{id}/update-health', [\App\Http\Controllers\Admin\AdminAnimalController::class, 'updateHealth']);

        // Sickness Reports
        Route::post('/reports', [\App\Http\Controllers\Api\ReportController::class, 'store']);
        Route::put('/reports/{id}', [\App\Http\Controllers\Api\ReportController::class, 'update']);
        Route::delete('/reports/{id}', [\App\Http\Controllers\Api\ReportController::class, 'destroy']);
        Route::post('/reports/{id}/assign-doctor', [\App\Http\Controllers\Api\ReportController::class, 'assignDoctor']);
        Route::post('/reports/{id}/resolve', [\App\Http\Controllers\Api\ReportController::class, 'resolve']);

        // Doctors
        Route::post('/doctors', [\App\Http\Controllers\Api\DoctorController::class, 'store']);
        Route::put('/doctors/{id}', [\App\Http\Controllers\Api\DoctorController::class, 'update']);
        Route::delete('/doctors/{id}', [\App\Http\Controllers\Api\DoctorController::class, 'destroy']);
        Route::post('/doctors/{id}/availability', [\App\Http\Controllers\Api\DoctorController::class, 'updateAvailability']);

        // Diseases
        Route::post('/diseases', [\App\Http\Controllers\Api\DiseaseController::class, 'store']);
        Route::put('/diseases/{id}', [\App\Http\Controllers\Api\DiseaseController::class, 'update']);
        Route::delete('/diseases/{id}', [\App\Http\Controllers\Api\DiseaseController::class, 'destroy']);

        // Farms
        Route::post('/farms', [\App\Http\Controllers\Api\FarmController::class, 'store']);
        Route::put('/farms/{id}', [\App\Http\Controllers\Api\FarmController::class, 'update']);
        Route::delete('/farms/{id}', [\App\Http\Controllers\Api\FarmController::class, 'destroy']);

        // Videos
        Route::post('/videos', [\App\Http\Controllers\Api\VideoController::class, 'store']);
        Route::put('/videos/{id}', [\App\Http\Controllers\Api\VideoController::class, 'update']);
        Route::delete('/videos/{id}', [\App\Http\Controllers\Api\VideoController::class, 'destroy']);

        // Advertisements
        Route::post('/advertisements', [\App\Http\Controllers\Api\AdvertisementController::class, 'store']);
        Route::put('/advertisements/{id}', [\App\Http\Controllers\Api\AdvertisementController::class, 'update']);
        Route::delete('/advertisements/{id}', [\App\Http\Controllers\Api\AdvertisementController::class, 'destroy']);
        Route::post('/advertisements/{id}/approve', [\App\Http\Controllers\Api\AdvertisementController::class, 'approve']);

        // Gestation
        Route::post('/gestation', [\App\Http\Controllers\Api\GestationController::class, 'store']);
        Route::put('/gestation/{id}', [\App\Http\Controllers\Api\GestationController::class, 'update']);
        Route::delete('/gestation/{id}', [\App\Http\Controllers\Api\GestationController::class, 'destroy']);

        // Vaccinations
        Route::post('/vaccinations', [\App\Http\Controllers\Api\VaccinationController::class, 'store']);
        Route::put('/vaccinations/{id}', [\App\Http\Controllers\Api\VaccinationController::class, 'update']);
        Route::delete('/vaccinations/{id}', [\App\Http\Controllers\Api\VaccinationController::class, 'destroy']);

        // Marketplace
        Route::post('/marketplace', [\App\Http\Controllers\Api\MarketplaceController::class, 'store']);
        Route::put('/marketplace/{id}', [\App\Http\Controllers\Api\MarketplaceController::class, 'update']);
        Route::delete('/marketplace/{id}', [\App\Http\Controllers\Api\MarketplaceController::class, 'destroy']);

        // Notifications
        Route::post('/notifications', [\App\Http\Controllers\Api\NotificationController::class, 'store']);
        Route::delete('/notifications/{id}', [\App\Http\Controllers\Api\NotificationController::class, 'destroy']);

        // Messages
        Route::post('/messages', [\App\Http\Controllers\Api\MessageController::class, 'store']);
        Route::delete('/messages/{id}', [\App\Http\Controllers\Api\MessageController::class, 'destroy']);

        // Settings
        Route::post('/settings', [\App\Http\Controllers\Api\SettingsController::class, 'store']);
    });
});

// Temporary route to create admin (REMOVE AFTER FIRST USE)
Route::get('/create-admin-now', function () {
    \App\Models\User::where('email', 'admin@jaguza.com')->delete();
    $user = \App\Models\User::create([
        'name' => 'Admin User',
        'email' => 'admin@jaguza.com',
        'password' => bcrypt('password123'),
        'role' => 'admin',
        'is_active' => true,
    ]);
    return "✅ Admin created! Email: admin@jaguza.com, Password: password123";
});