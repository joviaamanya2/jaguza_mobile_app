<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\WeatherUpdate;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;

class WeatherController extends Controller
{
    public function index()
    {
        return response()->json([
            'success' => true,
            'data' => WeatherUpdate::orderBy('weather_data_time', 'desc')->get()
        ]);
    }

    public function show($location)
    {
        $weather = WeatherUpdate::where('location', 'like', "%{$location}%")
            ->orderBy('weather_data_time', 'desc')
            ->first();

        if (!$weather) {
            return response()->json(['success' => false, 'message' => 'Weather not found for this location'], 404);
        }

        return response()->json(['success' => true, 'data' => $weather]);
    }

    public function fetch(Request $request)
    {
        // Mock API fetch
        $weather = WeatherUpdate::updateOrCreate(
            ['location' => $request->location ?? 'Kampala'],
            [
                'temperature' => rand(20, 32),
                'humidity' => rand(50, 90),
                'condition' => ['Sunny', 'Rain', 'Cloudy', 'Partly Cloudy'][rand(0, 3)],
                'wind_speed' => rand(5, 20),
                'weather_data_time' => now(),
                'advisory' => $request->advisory ?? 'Optimal farming conditions.',
            ]
        );

        return response()->json([
            'success' => true,
            'message' => 'Weather data synchronized successfully',
            'data' => $weather
        ]);
    }

    public function advisories()
    {
        return response()->json([
            'success' => true,
            'data' => WeatherUpdate::whereNotNull('advisory')->orderBy('created_at', 'desc')->get()
        ]);
    }
}
