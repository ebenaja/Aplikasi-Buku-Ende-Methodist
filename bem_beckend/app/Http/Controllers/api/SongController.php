<?php

namespace App\Http\Controllers\api;

use Illuminate\Support\Facades\DB;

class SongController
{
    public function index()
    {
        // Kita gunakan JOIN agar mendapatkan nama kategori dari tabel sebelah
        $songs = DB::table('songs')
            ->leftJoin('categories', 'songs.category_id', '=', 'categories.id')
            ->select(
                'songs.id',
                'songs.number',
                'songs.title',
                'songs.lyrics',
                'songs.key_note',
                'categories.name as category_name' // Kita ambil nama kategorinya
            )
            ->get();

        return response()->json([
            'status' => true,
            'data' => $songs
        ]);
    }

    public function create()
    {
        // 1. Buat Kategori Baru
        $catPujianId = DB::table('categories')->insertGetId([
            'name' => 'Puji-pujian',
            'created_at' => now(),
            'updated_at' => now()
        ]);

        $catPenghiburanId = DB::table('categories')->insertGetId([
            'name' => 'Penghiburan',
            'created_at' => now(),
            'updated_at' => now()
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
