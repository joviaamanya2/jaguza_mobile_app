<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('advertisements', function (Blueprint $table) {
            $table->id();
            $table->string('title');
            $table->text('description');
            $table->string('image_url')->nullable();
            $table->string('video_url')->nullable();
            $table->string('link_url')->nullable();
            $table->enum('type', ['banner', 'sponsored', 'video', 'popup'])->default('banner');
            $table->string('position')->nullable(); // e.g., 'sidebar', 'header', 'footer'
            $table->enum('status', ['active', 'pending', 'expired', 'draft'])->default('draft');
            $table->integer('views_count')->default(0);
            $table->integer('clicks_count')->default(0);
            $table->decimal('budget', 10, 2)->nullable();
            $table->decimal('cost_per_click', 10, 2)->nullable();
            $table->decimal('cost_per_view', 10, 2)->nullable();
            $table->timestamp('start_date')->nullable();
            $table->timestamp('end_date')->nullable();
            $table->json('target_audience')->nullable(); // e.g., {'location': 'Kampala', 'age': '18-35'}
            $table->json('target_categories')->nullable(); // e.g., ['cattle', 'goat']
            $table->foreignId('created_by')->constrained('users')->onDelete('cascade');
            $table->foreignId('approved_by')->nullable()->constrained('users')->nullOnDelete();
            $table->timestamp('approved_at')->nullable();
            $table->timestamps();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('advertisements');
    }
};