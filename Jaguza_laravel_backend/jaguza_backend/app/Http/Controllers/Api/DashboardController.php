<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;

use App\Models\Animal;
use App\Models\Farm;
use App\Models\User;
use App\Models\Doctor;
use App\Models\SicknessReport;
use App\Models\Video;
use App\Models\Advertisement;
use App\Models\WeatherUpdate;
use App\Models\DecisionSupport;
use App\Models\GestationRecord;
use App\Models\VaccinationRecord;
use App\Models\MarketplaceListing;
use App\Models\Notification;
use App\Models\Message;
use App\Models\Setting;
use App\Models\Disease;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class DashboardController extends Controller
{
    public function index()
    {
        // Get all data for the dashboard
        $stats = $this->getStats();
        $recentReports = $this->getRecentReports();
        $livestockByType = $this->getLivestockByType();
        $recentVideos = $this->getRecentVideos();
        $activeAds = $this->getActiveAds();
        $weatherUpdates = $this->getWeatherUpdates();
        $decisionSupport = $this->getDecisionSupport();
        $dueGestations = $this->getDueGestations();
        $users = $this->getUsers();
        $doctors = $this->getDoctors();
        $diseases = $this->getDiseases();
        $farms = $this->getFarms();
        $animals = $this->getAnimals();
        $vaccinations = $this->getVaccinations();
        $messages = $this->getMessages();
        $notifications = $this->getNotifications();
        $marketplaceListings = $this->getMarketplaceListings();
        $settings = $this->getSettings();
        $weatherAdvisories = $this->getWeatherAdvisories();
        
        // Chart data
        $chartData = $this->getChartData();
        $months = $chartData['months'];
        $sicknessData = $chartData['sicknessData'];
        $userData = $chartData['userData'];
        $marketData = $chartData['marketData'];
        
        // Calculate growth percentages
        $userGrowthPercent = $this->calculateGrowth(User::class);
        $sicknessGrowthPercent = $this->calculateGrowth(SicknessReport::class);
        $farmGrowthPercent = $this->calculateGrowth(Farm::class);
        $livestockGrowthPercent = $this->calculateGrowth(Animal::class);
        
        $newDoctors = Doctor::whereMonth('created_at', now()->month)
            ->whereYear('created_at', now()->year)
            ->count();
            
        $newVideosThisWeek = Video::whereBetween('created_at', [now()->startOfWeek(), now()->endOfWeek()])->count();
        $expiredAds = Advertisement::where('status', 'expired')->count();
        $dueGestationsCount = GestationRecord::whereBetween('expected_delivery_date', [now(), now()->addDays(7)])
            ->whereNull('actual_delivery_date')
            ->count();
        $dueGestationsThisMonth = GestationRecord::whereBetween('expected_delivery_date', [now(), now()->addMonth()])
            ->whereNull('actual_delivery_date')
            ->count();

        // Return the view with all data
        return view('dashboard', compact(
            'stats',
            'recentReports',
            'livestockByType',
            'recentVideos',
            'activeAds',
            'weatherUpdates',
            'decisionSupport',
            'dueGestations',
            'users',
            'doctors',
            'diseases',
            'farms',
            'animals',
            'vaccinations',
            'messages',
            'notifications',
            'marketplaceListings',
            'settings',
            'weatherAdvisories',
            'months',
            'sicknessData',
            'userData',
            'marketData',
            'userGrowthPercent',
            'sicknessGrowthPercent',
            'farmGrowthPercent',
            'livestockGrowthPercent',
            'newDoctors',
            'newVideosThisWeek',
            'expiredAds',
            'dueGestationsCount',
            'dueGestationsThisMonth'
        ));
    }

    private function getStats()
    {
        return [
            'total_users' => User::count(),
            'total_farms' => Farm::count(),
            'total_animals' => Animal::count(),
            'total_doctors' => Doctor::count(),
            'open_reports' => SicknessReport::where('status', 'open')->count(),
            'under_treatment' => SicknessReport::where('status', 'treating')->count(),
            'resolved_reports' => SicknessReport::where('status', 'resolved')->count(),
            'total_videos' => Video::where('is_published', true)->count(),
            'active_ads' => Advertisement::where('status', 'active')->count(),
            'total_gestations' => GestationRecord::count(),
        ];
    }

    private function getRecentReports()
    {
        return SicknessReport::with(['animal', 'reporter', 'doctor'])
            ->orderBy('created_at', 'desc')
            ->limit(10)
            ->get();
    }

    private function getLivestockByType()
    {
        return Animal::select('type', DB::raw('count(*) as count'))
            ->groupBy('type')
            ->pluck('count', 'type')
            ->toArray();
    }

    private function getChartData()
    {
        $months = [];
        $sicknessData = [];
        $userData = [];
        $marketData = [];
        
        for ($i = 6; $i >= 0; $i--) {
            $month = now()->subMonths($i);
            $months[] = $month->format('M');
            
            $sicknessData[] = SicknessReport::whereMonth('created_at', $month->month)
                ->whereYear('created_at', $month->year)
                ->count();
                
            $userData[] = User::whereMonth('created_at', $month->month)
                ->whereYear('created_at', $month->year)
                ->count();
                
            $marketData[] = Advertisement::whereMonth('created_at', $month->month)
                ->whereYear('created_at', $month->year)
                ->count();
        }

        return [
            'months' => $months,
            'sicknessData' => $sicknessData,
            'userData' => $userData,
            'marketData' => $marketData,
        ];
    }

    private function getRecentVideos()
    {
        return Video::with('category')
            ->where('is_published', true)
            ->orderBy('created_at', 'desc')
            ->limit(6)
            ->get();
    }

    private function getActiveAds()
    {
        return Advertisement::where('status', 'active')
            ->where('start_date', '<=', now())
            ->where(function($q) {
                $q->where('end_date', '>=', now())
                  ->orWhereNull('end_date');
            })
            ->orderBy('created_at', 'desc')
            ->limit(4)
            ->get();
    }

    private function getWeatherUpdates()
    {
        return WeatherUpdate::orderBy('weather_data_time', 'desc')
            ->limit(4)
            ->get();
    }

    private function getDecisionSupport()
    {
        return DecisionSupport::where('is_published', true)
            ->orderBy('is_featured', 'desc')
            ->orderBy('created_at', 'desc')
            ->limit(6)
            ->get();
    }

    private function getDueGestations()
    {
        return GestationRecord::with('animal')
            ->whereNull('actual_delivery_date')
            ->whereBetween('expected_delivery_date', [now(), now()->addDays(7)])
            ->limit(4)
            ->get();
    }

    private function getUsers()
    {
        return User::orderBy('created_at', 'desc')->limit(10)->get();
    }

    private function getDoctors()
    {
        return Doctor::with('user')->orderBy('created_at', 'desc')->limit(10)->get();
    }

    private function getDiseases()
    {
        return Disease::orderBy('name')->limit(10)->get();
    }

    private function getFarms()
    {
        return Farm::with('owner')->orderBy('created_at', 'desc')->limit(10)->get();
    }

    private function getAnimals()
    {
        return Animal::with(['farm', 'owner'])->orderBy('created_at', 'desc')->limit(10)->get();
    }

    private function getVaccinations()
    {
        return VaccinationRecord::with(['animal', 'administeredBy'])->orderBy('created_at', 'desc')->limit(10)->get();
    }

    private function getMessages()
    {
        return Message::with('sender')->orderBy('created_at', 'desc')->limit(10)->get();
    }

    private function getNotifications()
    {
        return Notification::orderBy('created_at', 'desc')->limit(10)->get();
    }

    private function getMarketplaceListings()
    {
        return MarketplaceListing::with('seller')->orderBy('created_at', 'desc')->limit(10)->get();
    }

    private function getSettings()
    {
        return Setting::pluck('value', 'key')->toArray();
    }

    private function getWeatherAdvisories()
    {
        return WeatherUpdate::whereNotNull('advisory')
            ->orderBy('created_at', 'desc')
            ->limit(3)
            ->get();
    }

    private function calculateGrowth($model)
    {
        $current = $model::whereMonth('created_at', now()->month)
            ->whereYear('created_at', now()->year)
            ->count();
            
        $previous = $model::whereMonth('created_at', now()->subMonth()->month)
            ->whereYear('created_at', now()->subMonth()->year)
            ->count();
            
        if ($previous == 0) return 0;
        return round((($current - $previous) / $previous) * 100, 1);
    }
}