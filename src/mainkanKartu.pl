/* include rules kartu */
:- dynamic(discardtop/2). /* cek kartu teratas */
:- dynamic(kartuPemain/1).

/*deskripsi fakta*/
warna(merah).
warna(kuning).
warna(hijau).
warna(biru).
warna(hitam).
jenis(0).
jenis(1).
jenis(2).
jenis(3).
jenis(4).
jenis(5).
jenis(6).
jenis(7).
jenis(8).
jenis(9).
jenis(skip). 
jenis(reversecard).
jenis(wild).
jenis(wild4).
jenis(plus2).
kartu(warna, jenis).

/* alur mainkan kartu
    cek validasi kartu (apakah warna sama? atau angka sama? atau wild?)
    If !valid, input lagi.
    if valid, kartunya jadi kartu discardtop dan kalo ngeluarin wild dia bisa tantang dsb gitu yek*/

/* helper */
/* cek apakah kartu valid or not */
isKartuValid(Kartu(Warna, Angka)).
isKartuValid(Kartu(_,wild)).  /*kartu valid yaitu kartu wild*/
isKartuValid(Kartu(_,wild4)). /*kartu valid yaitu kartu wild4 */
isKartuValid(Kartu(warna,_)):- /*kartu valid warnanya sama*/
    discardtop(warna,_). 

isKartuValid(Kartu(_,X)):- /*kartu valid angkanya sama*/
    discardtop(_,X).

hapus_kartu(_,[],[]). /* menghapus kartu dari tangan(?) */
hapus_kartu(X, [X|T], T).
hapus_kartu(X, [H|T], [H|Terhapusy]):-
    X\==H,
    hapus_kartu(X,T,Terhapusy).

/* buat ambil kartu dari no urutny*/

getKartu([Kartu|_], 0, Kartu).
getKartu([_|Tail], Index, Kartu):-
    Index > 0,
    Newindex is Index - 1,
    getKartu(Tail, Newindex, Kartu).

/*contoh kartu pemain*/
kartuPemain([kartu(biru, 4), kartu(hijau, skip), kartu(hitam, wild)])

mainkanKartu(Urut):-

    getKartu(kartuPemain, Urut, Kartu).
    (isKartuValid(Kartu) ?*kalo iya valid*/
    ->  hapus_kartu(Kartu, kartuPemain, updatedKartuPemain).
        retract(kartuPemain);
        assertz(updatedKartuPemain);

        /* terapkan rules/efekk kartu yang di taro*/
        /* ini manggil rules dari file sisi or nadia yac?*/

    ; /* kalo engga valid*/
    write("Duhh... Kartunya gak sesuai nich! Tolong pilih kartu lain yak :-D").
    nl.
    )



