<?php

use App\Http\Controllers\Api\AuthController;
use App\Http\Controllers\Api\DashboardController;
use App\Http\Controllers\Api\AnimalController;
use App\Http\Controllers\Api\FarmController;
use App\Http\Controllers\Api\ReportController;
use App\Http\Controllers\Api\DoctorController;
use App\Http\Controllers\Api\DiseaseController;
use App\Http\Controllers\Api\VideoController;
use App\Http\Controllers\Api\AdvertisementController;
use App\Http\Controllers\Api\AiChatController;
use App\Http\Controllers\Api\WeatherController;
use App\Http\Controllers\Api\SettingsController;
use App\Http\Controllers\Api\LanguageController;
use App\Http\Controllers\Api\DecisionSupportController;
use App\Http\Controllers\Api\UserController;
use App\Http\Controllers\Api\UserActivityController;
use Illuminate\Support\Facades\Route;

/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
*/

// ============================================
// PUBLIC ROUTES (No Authentication Required)
// ============================================

Route::post('/register', [AuthController::class, 'register']);
Route::post('/login', [AuthController::class, 'login']);

// ============================================
// PROTECTED ROUTES (Authentication Required)
// ============================================

Route::middleware('auth:sanctum')->group(function () {
    
    // ========== AUTH ==========
    Route::post('/logout', [AuthController::class, 'logout']);
    Route::get('/user', [AuthController::class, 'user']);
    Route::put('/user/profile', [AuthController::class, 'updateProfile']);
    
    // ========== DASHBOARD ==========
    Route::get('/dashboard/stats', [DashboardController::class, 'stats']);
    Route::get('/dashboard/chart-data', [DashboardController::class, 'chartData']);
    
    // ========== USERS CRUD ==========
    Route::get('/users', [UserController::class, 'index']);
    Route::post('/users', [UserController::class, 'store']);
    Route::get('/users/{id}', [UserController::class, 'show']);
    Route::put('/users/{id}', [UserController::class, 'update']);
    Route::delete('/users/{id}', [UserController::class, 'destroy']);
    Route::post('/users/{id}/toggle-status', [UserController::class, 'toggleStatus']);
    Route::post('/users/bulk-delete', [UserController::class, 'bulkDelete']);
    Route::get('/users/stats', [UserController::class, 'stats']);
    
    // ========== DOCTORS ==========
    Route::get('/doctors', [DoctorController::class, 'index']);
    Route::post('/doctors', [DoctorController::class, 'store']);
    Route::get('/doctors/{id}', [DoctorController::class, 'show']);
    Route::put('/doctors/{id}', [DoctorController::class, 'update']);
    Route::delete('/doctors/{id}', [DoctorController::class, 'destroy']);
    Route::post('/doctors/{id}/availability', [DoctorController::class, 'updateAvailability']);
    Route::get('/doctors/stats', [DoctorController::class, 'stats']);
    
    // ========== FARMS ==========
    Route::get('/farms', [FarmController::class, 'index']);
    Route::post('/farms', [FarmController::class, 'store']);
    Route::get('/farms/{id}', [FarmController::class, 'show']);
    Route::put('/farms/{id}', [FarmController::class, 'update']);
    Route::delete('/farms/{id}', [FarmController::class, 'destroy']);
    
    // ========== ANIMALS ==========
    Route::get('/animals', [AnimalController::class, 'index']);
    Route::post('/animals', [AnimalController::class, 'store']);
    Route::get('/animals/{id}', [AnimalController::class, 'show']);
    Route::put('/animals/{id}', [AnimalController::class, 'update']);
    Route::delete('/animals/{id}', [AnimalController::class, 'destroy']);
    Route::post('/animals/{id}/update-health', [AnimalController::class, 'updateHealth']);
    Route::get('/animals/{id}/health-history', [AnimalController::class, 'healthHistory']);
    Route::get('/animals/stats/by-type', [AnimalController::class, 'statsByType']);
    
    // ========== REPORTS ==========
    Route::get('/reports', [ReportController::class, 'index']);
    Route::post('/reports', [ReportController::class, 'store']);
    Route::get('/reports/{id}', [ReportController::class, 'show']);
    Route::put('/reports/{id}', [ReportController::class, 'update']);
    Route::delete('/reports/{id}', [ReportController::class, 'destroy']);
    Route::post('/reports/{id}/assign-doctor', [ReportController::class, 'assignDoctor']);
    Route::post('/reports/{id}/resolve', [ReportController::class, 'resolve']);
    Route::get('/reports/stats', [ReportController::class, 'stats']);
    
    // ========== DISEASES ==========
    Route::get('/diseases', [DiseaseController::class, 'index']);
    Route::post('/diseases', [DiseaseController::class, 'store']);
    Route::get('/diseases/{id}', [DiseaseController::class, 'show']);
    Route::put('/diseases/{id}', [DiseaseController::class, 'update']);
    Route::delete('/diseases/{id}', [DiseaseController::class, 'destroy']);
    
    // ========== DECISION SUPPORT ==========
    Route::get('/decision-support', [DecisionSupportController::class, 'index']);
    Route::post('/decision-support', [DecisionSupportController::class, 'store']);
    Route::get('/decision-support/{id}', [DecisionSupportController::class, 'show']);
    Route::put('/decision-support/{id}', [DecisionSupportController::class, 'update']);
    Route::delete('/decision-support/{id}', [DecisionSupportController::class, 'destroy']);
    Route::get('/decision-support/categories', [DecisionSupportController::class, 'categories']);
    Route::post('/decision-support/{id}/helpful', [DecisionSupportController::class, 'markHelpful']);
    
    // ========== VIDEOS ==========
    Route::get('/videos', [VideoController::class, 'index']);
    Route::post('/videos', [VideoController::class, 'store']);
    Route::get('/videos/{id}', [VideoController::class, 'show']);
    Route::put('/videos/{id}', [VideoController::class, 'update']);
    Route::delete('/videos/{id}', [VideoController::class, 'destroy']);
    Route::get('/videos/categories', [VideoController::class, 'categories']);
    Route::post('/videos/{id}/view', [VideoController::class, 'incrementViews']);
    
    // ========== ADVERTISEMENTS ==========
    Route::get('/advertisements', [AdvertisementController::class, 'index']);
    Route::post('/advertisements', [AdvertisementController::class, 'store']);
    Route::get('/advertisements/{id}', [AdvertisementController::class, 'show']);
    Route::put('/advertisements/{id}', [AdvertisementController::class, 'update']);
    Route::delete('/advertisements/{id}', [AdvertisementController::class, 'destroy']);
    Route::post('/advertisements/{id}/approve', [AdvertisementController::class, 'approve']);
    Route::post('/advertisements/{id}/click', [AdvertisementController::class, 'trackClick']);
    
    // ========== AI CHAT ==========
    Route::get('/ai-chat/history', [AiChatController::class, 'history']);
    Route::post('/ai-chat/send', [AiChatController::class, 'sendMessage']);
    Route::delete('/ai-chat/clear', [AiChatController::class, 'clearHistory']);
    Route::post('/ai-chat/{id}/feedback', [AiChatController::class, 'feedback']);
    
    // ========== WEATHER ==========
    Route::get('/weather', [WeatherController::class, 'index']);
    Route::get('/weather/{location}', [WeatherController::class, 'show']);
    Route::post('/weather/fetch', [WeatherController::class, 'fetch']);
    Route::get('/weather/advisories', [WeatherController::class, 'advisories']);
    
    // ========== SETTINGS ==========
    Route::get('/settings', [SettingsController::class, 'index']);
    Route::post('/settings', [SettingsController::class, 'store']);
    Route::get('/settings/{key}', [SettingsController::class, 'show']);
    Route::put('/settings/{key}', [SettingsController::class, 'update']);
    Route::delete('/settings/{key}', [SettingsController::class, 'destroy']);
    
    // ========== LANGUAGES ==========
    Route::get('/languages/active', [LanguageController::class, 'active']);
    Route::post('/languages/{id}/default', [LanguageController::class, 'setDefault']);
    
    // ========== ACTIVITY LOGS ==========
    Route::middleware('admin')->group(function () {
        Route::get('/activity-logs', [UserActivityController::class, 'index']);
        Route::get('/activity-logs/user/{userId}', [UserActivityController::class, 'userLogs']);
    });
});

// ============================================
// FALLBACK ROUTE
// ============================================

Route::fallback(function () {
    return response()->json([
        'success' => false,
        'message' => 'API endpoint not found'
    ], 404);
});