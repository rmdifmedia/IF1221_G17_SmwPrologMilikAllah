/* kartu.pl */

/* Deklarasi Fakta */

/* Warna Kartu */

/* Kartu warna merah */
merah(merah-skip).
merah(merah-draw_two).

/* Kartu warna kuning */
kuning(kuning-skip).
kuning(kuning-draw_two).

/* Kartu warna hijau */
hijau(hijau-skip).
hijau(hijau-draw_two).

/* Kartu warna biru */
biru(biru-skip).
biru(biru-draw_two).

/* Kartu warna hitam */
hitam(hitam-wild_draw_four).

/* Jenis Kartu */

/* Kartu Skip */
skip(merah-skip).
skip(kuning-skip).
skip(hijau-skip).
skip(biru-skip).

/* Kartu Draw Two */
drawTwo(merah-draw_two).
drawTwo(kuning-draw_two).
drawTwo(hijau-draw_two).
drawTwo(biru-draw_two).

/* Kartu Wild Draw Four */
wildFour(hitam-wild_draw_four).

