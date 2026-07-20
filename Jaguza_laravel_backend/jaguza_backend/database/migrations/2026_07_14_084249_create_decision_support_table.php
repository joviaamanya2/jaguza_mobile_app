<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('decision_support', function (Blueprint $table) {
            $table->id();
            $table->string('title');
            $table->string('category'); // e.g., 'cattle', 'goat', 'sheep', 'pig', 'poultry', 'general'
            $table->string('sub_category')->nullable(); // e.g., 'feeding', 'health', 'breeding', 'marketing'
            $table->text('content');
            $table->text('summary')->nullable();
            $table->json('keywords')->nullable();
            $table->string('image')->nullable();
            $table->string('video_url')->nullable();
            $table->string('document_url')->nullable();
            $table->enum('difficulty_level', ['beginner', 'intermediate', 'advanced'])->default('beginner');
            $table->integer('views_count')->default(0);
            $table->integer('helpful_count')->default(0);
            $table->boolean('is_featured')->default(false);
            $table->boolean('is_published')->default(true);
            $table->foreignId('created_by')->constrained('users')->onDelete('cascade');
            $table->timestamps();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('decision_support');
    }
};