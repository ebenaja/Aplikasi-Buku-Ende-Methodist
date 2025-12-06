<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Support\Facades\DB;
use Illuminate\Http\Request;

class SongController extends Controller
{
    public function index()
    {
        $songs = DB::table('songs')
            ->leftJoin('categories', 'songs.category_id', '=', 'categories.id')
            ->select(
                'songs.id',
                'songs.number',       // Pastikan kolom ini terpilih
                'songs.title',
                'songs.lyrics',
                'songs.key_note',
                'categories.name as category_name'
            )
            // ▼▼▼ INI KUNCINYA ▼▼▼
            ->orderBy('songs.number', 'asc')
            // ▲▲▲ Mengurutkan nomor dari kecil ke besar (1, 2, 3...)

            ->get();

        return response()->json([
            'status' => true,
            'data' => $songs
        ]);
    }
}
