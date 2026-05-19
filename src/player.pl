/* action yang berhubungan dengan player 
 cekinfo, lihat command, lihatkartu, nexturn, reversturn, giliran*/

:- dynamic(turn/1).
:- dynamic(jumlah/1).
:- dynamic(arah/1).

nextTurn :- 
    turn(Nama),
    arah(Arah),
    playerCount(Jumlah),
    listUrutan(ListUrutan),
    get_index_of(ListUrutan, Nama, Index),  % cari index dari Nama
    (Arah = kanan
    -> Next is (Index+1) mod Jumlah
    ; Next is (Index-1) mod Jumlah),
    get_index(ListUrutan, Next, NamaNext),  % cari nama dari index
    retract(turn(_)),
    assertz(turn(NamaNext)).

reverseUrutan :-
    (
        arah(kanan)
        -> retract(arah(kanan)),
            assertz(arah(kiri))
        ; retract(arah(kiri)),
        assertz(arah(kanan)) 
    ).

aksiUtama(Pemain, AksUtamaList) :-
    turn(Pemain),
    kartuTop(_, drawfour),
    findall(A, aksi_utama_tersedia(Pemain, A), AksiUtamaList).

aksi_utama_tersedia(_, ambilKartu).

aksi_utama_tersedia(Pemain, tantang) :-
    kartuTop(_, drawfour),
    turn(Pemain).

aksi_utama_tersedia(Pemain, uni) :-
    turn(Pemain),
    kartu_diTangan(Pemain, ListKartu),
    member(Kartu, ListKartu), 
    isKartuValid(Kartu),
    length(ListKartu, Length),
    Length =:= 2.

/*aksi_utama_tersedia(Pemain, tangkap) :-
    turn(Pemain). */

aksi_utama_tersedia(Pemain, mainkanKartu) :- 
    turn(Pemain),
    kartu_diTangan(Pemain, ListKartu),
    member(Kartu, ListKartu), 
    isKartuValid(Kartu), !.

printNomor(_, []).
printNomor(N, [H|T]) :-
    format('~w, ~w~n', [N, H]),
    N1 is N + 1,
    printNomor(N1, T).

lihatCommand :- 
     turn(Pemain),
        findall(A, aksi_utama_tersedia(Pemain, A), AksiUtama),
        write('Aksi utama yang tersedia:'), nl,
        printNomor(1, AksiUtama),
        nl,
        write('Aksi pendukung yang tersedia:'), nl,
        printNomor(1, [lihatCommand, lihatKartu, cekInfo]).


printKartu(_, []).
printKartu(N, [kartu(Warna, Jenis) | T] ) :-
    format('~w. ~w-~w~n', [N, Warna, Jenis]),
    N1 is N + 1,
    printKartu(N1, T).

lihatKartu :-
  giliran(Pemain), 
        write('Berikut kartu yang anda miliki.'), nl,
        (   kartu_diTangan(Pemain, ListKartu)
        ->  printKartu(1, ListKartu)
        ; write('Kamu! tidak memiliki kartu!'), nl
        ).


:- dynamic(kartuTop/2). /* ambil kartu teratas */
:- dynamic(kartu_diTangan/2).

info_pemain(_,[]).
info_pemain(FullList, [Nama|Tail]) :-
    get_index(FullList, Index, Nama),
    kartu_diTangan(Nama, ListKartu),
    length(ListKartu, Jum),
    format('Nama pemain ~d: ~w~n Jumlah kartu: ~d~n', [Index,Nama,Jum]),
    info_pemain(FullList, Tail).

listPemain(ListPemain) :-
    open('dataNama.txt', read, Stream),
    read(Stream, ListPemain),
    close(Stream).

cekInfo :-
    kartuTop(Warna, jenis),
    format('Kartu discard top: ~w - ~w~n', [Warna, Jenis]),
    listPemain(ListPemain),
    info_pemain(ListPemain, ListPemain).