/* include rules kartu */
(startGame.pl)
:- dynamic(discardtop/2). /* cek kartu teratas */
:- dynamic(kartu_ditangan/1).
:- dynamic(giliran/1). /* mengambil giliran pemain*/
:- dynamic(game_started/0).

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

mainkanKartu(Urut):-
    (
        game_started.
    ->  giliran(Pemain).

    getKartu(kartuPemain, Urut, Kartu).
    (isKartuValid(Kartu) /*kalau valid*/
    ->  hapus_kartu(Kartu, kartuPemain, updatedKartuPemain).
        retract(kartuPemain);
        assertz(updatedKartuPemain);

        /* terapkan rules/efekk kartu yang di taro*/

    ; /* kalau tidak valid*/
    write("Duhh... Kartunya gak sesuai nich!"). nl.
    write("Kamu bisa menginput ulang kartu atau ketik 'Cancel' jika tidak ingin memainkan kartu :D"). nl.
    read(Ans).
    (
        Ans == 'Cancel'
        -> write("Kamu memilih tidak memainkan kartu. Silahkan ambil kartu."). nl.
        ;
        mainkanKartu(Ans).
    )
        ; fail.
    )
    )



