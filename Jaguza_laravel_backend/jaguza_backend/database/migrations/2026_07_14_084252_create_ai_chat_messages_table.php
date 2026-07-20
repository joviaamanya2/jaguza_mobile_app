<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('ai_chat_messages', function (Blueprint $table) {
            $table->id();
            $table->foreignId('user_id')->constrained()->onDelete('cascade');
            $table->text('user_message');
            $table->text('bot_response');
            $table->json('metadata')->nullable(); // e.g., sentiment, intent, confidence
            $table->string('intent')->nullable(); // e.g., 'diagnose', 'advice', 'info'
            $table->decimal('confidence_score', 5, 2)->nullable();
            $table->enum('feedback', ['helpful', 'not_helpful'])->nullable();
            $table->string('session_id')->nullable();
            $table->boolean('is_archived')->default(false);
            $table->timestamps();
            
            $table->index(['user_id', 'session_id']);
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('ai_chat_messages');
    }
};