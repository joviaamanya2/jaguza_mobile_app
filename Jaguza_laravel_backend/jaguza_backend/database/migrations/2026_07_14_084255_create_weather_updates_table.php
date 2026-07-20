<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('weather_updates', function (Blueprint $table) {
            $table->id();
            $table->string('location');
            $table->string('region')->nullable();
            $table->string('country')->nullable();
            $table->decimal('temperature', 5, 1);
            $table->decimal('feels_like', 5, 1)->nullable();
            $table->string('condition'); // e.g., 'Sunny', 'Rain', 'Cloudy'
            $table->string('icon')->nullable();
            $table->integer('humidity')->nullable();
            $table->decimal('wind_speed', 6, 2)->nullable();
            $table->string('wind_direction')->nullable();
            $table->decimal('precipitation', 6, 2)->nullable();
            $table->decimal('uv_index', 3, 1)->nullable();
            $table->json('forecast')->nullable(); // 5-day forecast
            $table->json('advisory')->nullable(); // Farming advisories
            $table->timestamp('weather_data_time')->nullable();
            $table->timestamp('sunrise')->nullable();
            $table->timestamp('sunset')->nullable();
            $table->timestamp('last_fetched_at')->nullable();
            $table->string('source')->nullable(); // e.g., 'OpenWeather', 'WeatherAPI'
            $table->timestamps();

            $table->index(['location', 'region']);
            $table->unique(['location', 'weather_data_time']);
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('weather_updates');
    }
};