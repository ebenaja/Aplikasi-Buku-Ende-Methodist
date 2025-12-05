<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;

class DatabaseSeeder extends Seeder
{
    use WithoutModelEvents;

    /**
     * Seed the application's database.
     */
    public function run()
    {
    // 1. Buat Kategori
    $idKategori = \Illuminate\Support\Facades\DB::table('categories')->insertGetId([
        'name' => 'Puji-pujian',
        'created_at' => now(), 'updated_at' => now(),
    ]);

    // 2. Buat Lagu pakai ID kategori di atas
    \Illuminate\Support\Facades\DB::table('songs')->insert([
        'category_id' => $idKategori,
        'number' => 1,
        'title' => 'Suci, Suci, Suci',
        'lyrics' => 'Lirik lagu disini...',
        'key_note' => 'C',
        'created_at' => now(), 'updated_at' => now(),
    ]);

        // 2. Buat Lagu yang berelasi dengan ID Kategori di atas
        DB::table('songs')->insert([
            [
                'category_id' => $catPujianId, // Relasi ke Puji-pujian
                'number' => 1,
                'title' => 'Suci, Suci, Suci',
                'lyrics' => "Suci, suci, suci\nTuhan Maha Kuasa...",
                'key_note' => 'C',
                'created_at' => now(), 'updated_at' => now()
            ],
            [
                'category_id' => $catPenghiburanId, // Relasi ke Penghiburan
                'number' => 350,
                'title' => 'Yesus Kawan Sejati',
                'lyrics' => "Yesus kawan yang sejati\nBagi kita yang lemah...",
                'key_note' => 'F',
                'created_at' => now(), 'updated_at' => now()
            ]
        ]);
    }
}
