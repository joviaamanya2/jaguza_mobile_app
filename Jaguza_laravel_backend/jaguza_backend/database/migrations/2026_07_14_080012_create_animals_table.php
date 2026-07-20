<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('animals', function (Blueprint $table) {
            $table->id();
            $table->string('identification_number')->unique();
            $table->string('name')->nullable();
            $table->enum('type', ['cattle', 'goat', 'sheep', 'pig', 'poultry', 'rabbit', 'horse', 'other']);
            $table->string('breed')->default('other');
            $table->enum('gender', ['male', 'female']);
            $table->integer('age');
            $table->decimal('weight', 10, 2)->nullable();
            $table->enum('health_status', ['healthy', 'sick', 'treatment', 'quarantine', 'recovering', 'critical'])->default('healthy');
            $table->foreignId('farm_id')->constrained()->onDelete('cascade');
            $table->foreignId('owner_id')->constrained('users')->onDelete('cascade');
            $table->string('photo')->nullable();
            $table->date('date_bought')->nullable();
            $table->decimal('purchase_price', 10, 2)->nullable();
            $table->text('notes')->nullable();
            $table->boolean('is_active')->default(true);
            $table->timestamps();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('animals');
    }
};