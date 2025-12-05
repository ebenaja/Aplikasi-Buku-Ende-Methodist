<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
public function up()
{
    Schema::create('songs', function (Blueprint $table) {
        $table->id();

        // INI BAGIAN RELASINYA
        // constrained() artinya menyambung ke tabel 'categories'
        // nullOnDelete() artinya jika kategori dihapus, lagunya tetap ada tapi kategorinya jadi kosong
        $table->foreignId('category_id')
              ->nullable()
              ->constrained('categories')
              ->nullOnDelete();

        $table->integer('number');
        $table->string('title');
        $table->text('lyrics');
        $table->string('key_note')->nullable();
        $table->string('category')->nullable(); // (Opsional) Boleh dihapus jika sudah pakai category_id
        $table->timestamps();
    });
}

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('songs');
    }
};
