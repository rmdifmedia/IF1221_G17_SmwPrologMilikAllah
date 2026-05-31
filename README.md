# UNI!
> Praktikum-Tugas Besar -- IF1221 Logika Komputasional
---
## Table of Contents
* [Deskripsi Program](#Deskripsi-Program)
* [Fitur](#Fitur)
* [Cara Bermain](#Cara-Bermain)
* [Struktur File Program](#Struktur-File-Program)
* [Kontributor](#Kontributor)

---
## Deskripsi Program
<p align="justify">UNI! adalah sebuah program simulasi permainan kartu berbasis text-based yang diimplementasikan menggunakan bahasa pemrograman deklaratif prolog (GNU Prolog). Terinspirasi dari permainan kartu populer UNO, UNI! Dapat dimainkan oleh 2-4 pemain dengan tujuan akhir dari setiap pemain adalah menjadi orang pertama yang menghabiskan seluruh kartu miliknya.</p>
<p align="justify">Projek ini dibuat untuk memenuhi praktikum/tugas besar mata kuliah Logika Komputasional IF1221 Tahun 2025/2026. Melalui projek ini, konsep-konsep berupa rekursi, backtracking, manipulasi list, penggunaan kontrol cut dan fail diterapkan secara nyata untuk menciptakan program permainan UNI! yang interaktif. </p>

---
## Fitur 
### Jenis dan Efek Kartu
| Kartu            | Deskripsi                                                                                      |
|------------------|------------------------------------------------------------------------------------------------|
| Kartu Angka      | Kartu bernomor 0–9                                                                             |
| Reverse          | Membalik arah urutan permainan                                                                 |
| Draw Two (+2)    | Memaksa pemain berikutnya mengambil 2 kartu tambahan                                           |
| Draw Four (+4)   | Memaksa pemain berikutnya mengambil 4 kartu dan pemain saat ini dapat memilih warna baru       |
| Wild             | Memungkinkan pemain memilih warna aktif baru                                                   |
| Mimic            | Menyalin efek kartu aksi sebelumnya                                                            |
### Command
| Command            | Deskripsi                                                                                      |
|--------------------|------------------------------------------------------------------------------------------------|
| `startGame.`       | Memulai inisialisasi awal permainan                                                             |
| `lihatKartu.`      | Melihat daftar kartu yang dimiliki pemain dengan giliran yang sedang berlangsung               |
| `cekInfo.`         | Melihat discard top, urutan pemain, warna aktif, nama pemain dan jumlah kartu masing-masing pemain. |
| `lihatCommand.`    | Menampilkan daftar aksi yang tersedia bagi pemain pada giliran saat ini                        |
| `mainkanKartu(X).` | Memainkan salah satu kartu di tangannya berdasarkan nomor urut (X).                            |
| `ambilKartu.`      | Mengambil satu kartu acak dari discard pile                                                     |
| `tantang.`         | Dapat digunakan ketika kartu wild draw four diturunkan. Pemain selanjutnya dapat menantang pemain pengguna kartu wild draw four. |
| `uni.`             | Memainkan kartu terakhir kedua (apabila kartu dimainkan maka menyisakan satu kartu terakhir). |
| `tangkap.`         | Menangkap pemain yang hanya memiliki satu kartu, tetapi belum menyerukan uni.                 |
| `endGame.`         | Dieksekusi secara otomatis ketika seorang pemain telah menghabiskan seluruh kartunya.         |
| `saveGame.`        | Menyimpan data permainan agar permainan dapat dilanjutkan di lain waktu.                      |
---

## Cara Bermain
1. **Persyaratan**:
   - Install [GNU Prolog](http://www.gprolog.org/).  
2. **Run UNI!**:
   - Clone repository ini
     ```bash
     git clone https://github.com/rmdifmedia/IF1221_G17_SmwPrologMilikAllah.git
     ```
   - Buka terminal dan arahkan ke direktori `src/`.
   - Jalankan permainan dengan perintah:
     ```bash
     gprolog --consult-file main.pl
     ```
   - Gunakan perintah `startGame.` untuk memulai permainan.
     ```prolog
     startGame.
     ```

   **Sebagai alternartif, bisa juga digunakan GNU Prolog Console**
   - Buka GNU Prolog Console.
   - Muat file `main.pl` dengan menjalankan console dari direktori `src/`
     ```prolog
     |?- ['main.pl'].
     ```
   - Di dalam console, ketik:
     ```prolog
     startGame.
     ```
   - Tekan `Enter` untuk memulai.
---

## Struktur File Program
```text
├── docs/
|   ├── Milestone1_G17.pdf     #Laporan Milestone 1
|   ├── Milestone2_G17.pdf     #Laporan Milestone 2
|   ├── Laporan_G17.pdf        #Laporan keseluruhan tugas
├── src/
|   ├── endgame.pl             # code untuk fitur endgame
|   ├── fact.pl               # code untuk fitur yang berhubungan dengan kartu
|   ├── helper.pl              # code untuk fungsi fungsi helper yang dibutuhkan 
|   ├── main.pl                # maincode untuk memulai permainan
|   ├── player.pl              # code untuk fitur yang berhubungan dengan pemain
|   ├── saveGame.pl            # code untuk fitur saveGame
|   ├── startGame.pl           # code untuk fitur startGame yang berhubungan dengan inisialisasi awal permainan
└── README.md
```
---

## Kontributor
<p align="justify">Projek ini dibuat oleh kelompok <strong>SmwPrologMilikAllah</strong> (G17-K01).</p>
<div align="center">

| Nama                           | NIM       |
|-------------------------------|----------:|
| Cendra Asih Chairunnisa       | 13525017  |
| Cherinette Corsane Khassyah P | 13525003  |
| Raya Medina Farrelin          | 13525057  |
| Nadia Layla Safira            | 13525073  |
