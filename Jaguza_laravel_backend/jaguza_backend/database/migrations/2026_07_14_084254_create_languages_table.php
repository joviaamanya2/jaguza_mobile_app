<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('languages', function (Blueprint $table) {
            $table->id();
            $table->string('code', 10)->unique(); // e.g., 'en', 'sw', 'lg'
            $table->string('name');
            $table->string('native_name')->nullable();
            $table->string('flag')->nullable(); // Emoji or URL
            $table->string('direction')->default('ltr'); // ltr, rtl
            $table->string('timezone')->nullable();
            $table->string('date_format')->nullable();
            $table->string('currency')->nullable();
            $table->string('currency_symbol')->nullable();
            $table->integer('order')->default(0);
            $table->boolean('is_active')->default(true);
            $table->boolean('is_default')->default(false);
            $table->json('translations')->nullable(); // Store translations as JSON
            $table->timestamps();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('languages');
    }
};