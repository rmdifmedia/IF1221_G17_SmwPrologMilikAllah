:- include('fact.pl').
:- include('player.pl').

/* Helper */


/* List UNI */
:- dynamic(listUni/1).

listUni([]).

filter_cardIsOne([], []).

filter_cardIsOne([H|T], [H|TResult]):-
    kartu_diTangan(H, ListKartu),
    length(ListKartu, LenKartu),
    LenKartu =:= 1,
    filter_cardIsOne(T, TResult).

filter_cardIsOne([H|T], TResult):- 
    kartu_diTangan(H, ListKartu),
    length(ListKartu, LenKartu),
    \+ LenKartu =:= 1,
    filter_cardIsOne(T, TResult).

addListUni(Nama):-
    retract(ListNama(ListLama)),
    assertz(ListNama([Nama|ListLama])).

syarat_UNI(Nama):-
    kartu_diTangan(Nama, ListKartu),
    length(ListKartu, Len),
    Len =:= 1.

updateListUni:-
    listUni(ListLama),
    filter_cardIsOne(ListLama, ListBaru),
    retract(listUni(ListLama)),
    assertz(listUni(ListBaru)).


/* Helper UNI */


/* UNI */
uni(Number):-
    turn(Pemain),
    kartu_diTangan(Pemain, ListKartu),
    length (ListKartu, LenKartu),
    (Number > 0, (Number < LenKartu ; Number == LenKartu)),
    getCard(ListKartu, Number, Kartu),
    isKartuValid(Kartu),
    LenKartu =:= 2,
    mainkanKartu(Number),
    write(Pemain), write(' menyerukan UNI!'), nl,
    addListUni(Pemain),
    !.

uni(Number):-
    turn(Pemain),
    kartu_diTangan(Pemain, ListKartu),
    length(ListKartu, LenKartu),
    (Number < 0 ; Number > LenKartu),
    write('Nomor kartu tidak sesuai rentang jumlah kartu. Masukkan nomor kartu yang sesuai: '),
    read(NewNumber),
    uni(NewNumber).

uni(Number):-
    turn(Pemain),
    kartu_diTangan(Pemain, ListKartu),
    getCard(ListKartu, Number, kartu(Warna, Jenis)),
    \+ isKartuValid(kartu(Warna, Jenis)),
    write('Kartu tidak sesuai dengan efek sebelumnya. Masukkan kartu dengan efek yang sesuai: '),
    read(NewNumber),
    uni(NewNumber).

uni(Number):-
    turn(Pemain),
    kartu_diTangan(Pemain, ListKartu),
    length(ListKartu, LenKartu),
    \+ LenKartu =:= 2,
    write(Pemain), write(' tidak memenuhi syarat perintah UNI!'), nl
    repeat_N_ambilKartu(1, AmbilKartu),
    write(Pemain), write(' mendapatkan 1 kartu acak.'), nl,
    nextTurn.