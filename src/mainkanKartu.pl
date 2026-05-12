
:- dynamic(game_started/0).
:- dynamic(kartuTop/2). /* ambil kartu teratas */
:- dynamic(kartu_diTangan/2).
:- dynamic(kartu/2). /* ambil tipe kartu*/
:- dynamic(giliran/1). /* mengambil giliran pemain*/

/* helper */
/* cek apakah kartu valid or not */
isKartuValid(Kartu(_,wild)).  /*kartu valid yaitu kartu wild*/
isKartuValid(Kartu(_,wild4)). /*kartu valid yaitu kartu wild4 */
isKartuValid(Kartu(Warna,_)):- /*kartu valid warnanya sama*/
    kartuTop(Warna,_). 

isKartuValid(Kartu(_,X)):- /*kartu valid jenisnya sama*/
    kartuTop(_,X).

hapus_kartu(_,[],[]). /* menghapus kartu dari tangan(?) */
hapus_kartu(X, [X|T], T).
hapus_kartu(X, [H|T], [H|Terhapus]):-
    X\==H,
    hapus_kartu(X,T,Terhapus).

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
        kartu_diTangan(Pemain, IsiKartu).

    getKartu(IsiKartu, Urut, ChosenKartu).
    (isKartuValid(ChosenKartu) /*kalau valid*/
    ->  hapus_kartu(ChosenKartu, IsiKartu, UpdatedKartuPemain).
        retract(kartu_diTangan(Pemain,_));
        assertz(kartu_diTangan(Pemain, UpdatedKartuPemain));
        
        /* ganti kartu top, karena diletakkan kartu yg baru*/
        retract(kartuTop(_,_)).
        assertz(kartuTop(Warna, X)).

        /* terapkan rules/efek kartu yang di taruh*/

    ; /* kalau tidak valid*/
    write("Duhh... Kartunya gak sesuai nich!"). nl.
    write("Kamu bisa menginput ulang kartu atau ketik 'Cancel' jika tidak ingin memainkan kartu :D"). nl.
    read(Ans).
    (
        Ans == 'Cancel'
        -> write("Kamu memilih tidak memainkan kartu. Silahkan ambil kartu."). nl. 
        ambilKartu.
        ;
        mainkanKartu(Ans).
    )
    write("Selanjutnya, giliran: ~w ~n", [giliran(Pemain)]).
        ;   write("Gamenya belum dimulai!"). nl. 
            fail.
    )
    )



