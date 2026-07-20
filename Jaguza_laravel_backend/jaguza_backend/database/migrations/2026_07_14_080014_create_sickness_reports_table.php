<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        // First create the table without foreign keys
        Schema::create('sickness_reports', function (Blueprint $table) {
            $table->id();
            $table->string('report_id')->unique();
            $table->unsignedBigInteger('animal_id');
            $table->unsignedBigInteger('disease_id')->nullable();
            $table->text('symptoms');
            $table->unsignedBigInteger('reported_by');
            $table->unsignedBigInteger('doctor_id')->nullable();
            $table->enum('status', ['open', 'treating', 'resolved', 'critical', 'referred'])->default('open');
            $table->text('diagnosis')->nullable();
            $table->text('treatment')->nullable();
            $table->text('medications')->nullable();
            $table->string('test_results')->nullable();
            $table->timestamp('reported_date')->useCurrent();
            $table->timestamp('resolved_date')->nullable();
            $table->text('notes')->nullable();
            $table->timestamps();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('sickness_reports');
    }
};