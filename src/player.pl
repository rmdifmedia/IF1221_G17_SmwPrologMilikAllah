/* action yang berhubungan dengan player 
 cekinfo, lihat command, lihatkartu, nexturn, reversturn, giliran*/

:- dynamic(turn/1).
:- dynamic(playerCount/1). 
:- dynamic(listUrutan/1). %ListUrutan(List).
:- dynamic(arah/1).

nextTurn :- 
    turn(Nama),
    arah(Arah),
    playerCount(Jumlah),
    listUrutan(ListUrutan), 
    find_index(ListUrutan, Index, Nama),
    (Arah = kanan
    -> Next is (Index+1) mod Jumlah
    ; Next is (Index-1) mod Jumlah),

    get_index(ListUrutan, Next, NamaNext),
    retractall(turn(_)),
    assertz(turn(NamaNext)).

reverseUrutan :-
    (
        arah(kanan)
        -> retract(arah(kanan)),
            assert(arah(kiri))
        ; retract(arah(kiri)),
        assert(arah(kanan)) 
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
  turn(Pemain), 
        write('Berikut kartu yang anda miliki.'), nl,
        (   kartu_diTangan(Pemain, ListKartu)
        ->  printKartu(1, ListKartu)
        ; write('Kamu! tidak memiliki kartu!'), nl
        ).


:- dynamic(kartuTop/2). /* ambil kartu teratas */
:- dynamic(kartu_diTangan/2).

info_pemain(_,[]).
info_pemain(FullList, [Nama|Tail]) :-
    find_index(FullList, Index, Nama),
    kartu_diTangan(Nama, ListKartu),
    list_length(ListKartu, Jum),
    format('Nama pemain ~d: ~w~nJumlah kartu: ~d~n', [Index+1,Nama,Jum]), nl,
    info_pemain(FullList, Tail).

print_Urutan([]).
print_Urutan([Nama]):-
    write(Nama),
    !.

print_Urutan([Nama|T]):-
    write(Nama),
    write(' - '),
    print_Urutan(T).


cekInfo :-
    kartuTop(Warna, Jenis),
    format('Kartu discard top: ~w - ~w~n', [Warna, Jenis]), nl, 
    listUrutan(ListPemain),
    write('Urutan Pemain : '), 
    print_Urutan(ListPemain), nl, 
    nl,
    info_pemain(ListPemain, ListPemain).