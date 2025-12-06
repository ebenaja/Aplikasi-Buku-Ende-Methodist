<?php

namespace App\Console\Commands;

use Illuminate\Console\Command;
use Illuminate\Support\Facades\File;
use Illuminate\Support\Facades\DB;

class ImportSongs extends Command
{
    // Nama perintah yang nanti kita ketik di terminal
    protected $signature = 'songs:import';

    // Deskripsi perintah
    protected $description = 'Import file Markdown lagu ke Database';

    public function handle()
    {
        // 1. Lokasi folder (sesuai TAHAP 1)
        $path = storage_path('app/bem_files');

        // Cek folder ada atau tidak
        if (!File::exists($path)) {
            $this->error("Folder tidak ditemukan di: $path");
            return;
        }

        // 2. Ambil semua file .md
        $files = File::files($path);
        $this->info("Ditemukan " . count($files) . " file lagu. Mulai proses...");

        $bar = $this->output->createProgressBar(count($files));
        $bar->start();

        foreach ($files as $file) {
            // A. Baca Nama File (Contoh: "1. Nang Pe Marribu Endengki.md")
            $filename = $file->getFilename();

            // Kita pakai REGEX untuk memisahkan Nomor dan Judul
            // Pola: Angka, Titik, Spasi, Judul, .md
            if (preg_match('/^(\d+)\.\s*(.*)\.md$/i', $filename, $matches)) {
                $number = $matches[1]; // Dapat angka "1"
                $title  = $matches[2]; // Dapat judul "Nang Pe Marribu Endengki"

                // B. Baca Isi File (Lirik)
                $content = File::get($file->getPathname());

                // (Opsional) Bersihkan simbol Markdown jika ada (seperti # atau *)
                // Agar di HP tampil bersih
                $cleanLyrics = str_replace(['#', '*', '_'], '', $content);

                // C. Masukkan ke Database
                // Kita pakai updateOrCreate supaya kalau dijalankan 2x tidak duplikat
                DB::table('songs')->updateOrInsert(
                    ['number' => $number], // Cek berdasarkan nomor
                    [
                        'title' => $title,
                        'lyrics' => trim($cleanLyrics),
                        'category_id' => null, // Karena di nama file tidak ada kategori, kita kosongkan dulu
                        'created_at' => now(),
                        'updated_at' => now(),
                    ]
                );
            }

            $bar->advance();
        }

        $bar->finish();
        $this->newLine();
        $this->info("Sukses! Semua lagu berhasil di-import.");
    }
}
