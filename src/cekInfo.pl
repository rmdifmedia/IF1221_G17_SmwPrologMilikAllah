:- dynamic(game_started/0).
:- dynamic(kartuTop/2). /* ambil kartu teratas */
:- dynamic(kartu_diTangan/2).
:- dynamic(giliran/1). /* mengambil giliran pemain*/

info_pemain([]).
info_pemain([Nama|Tail]) :-
    (kartu_diTangan(Nama, Isi_kartu)
    -> length(Isi_kartu, Jum)
    ;
    Jum = 0
    ),
    format('- ~w: ~d kartu ~n', [Nama, Jum]),
    info_pemain(T).

cekInfo :-
kartuTop(Warna, jenis).
write('Kartu discard-top: ~w~n', [Warna, Jenis]).
write('Urutan pemain: ~w~n', [Urutan_pemain]).
info_pemain(Urutan_pemain)

