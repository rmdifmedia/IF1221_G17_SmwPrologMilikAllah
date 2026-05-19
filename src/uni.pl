:- include('fact.pl').
:- include('player.pl').
:- include('helper.pl').

:- dynamic(updateListUni/0).


:- initialization(write('hewwp')).


turn(sawit).
kartu_diTangan(sawit, [kartu(merah, 0), kartu(kuning, 1)]).

/* List UNI */
listUni([]).

filter_cardIsOne([], []).

filter_cardIsOne([H|T], [H|TResult]):-
    kartu_diTangan(H, ListKartu),
    list_length(ListKartu, LenKartu),
    LenKartu =:= 1,
    filter_cardIsOne(T, TResult).

filter_cardIsOne([H|T], TResult):- 
    kartu_diTangan(H, ListKartu),
    list_length(ListKartu, LenKartu),
    \+LenKartu =:= 1,
    filter_cardIsOne(T, TResult).

addListUni(Nama):-
    retract(listUni(ListLama)),
    assertz(listUni([Nama|ListLama])).

syarat_UNI(Nama):-
    kartu_diTangan(Nama, ListKartu),
    list_length(ListKartu, Len),
    Len =:= 1.

updateListUni:-
    listUni(ListLama),
    filter_cardIsOne(ListLama, ListBaru),
    retract(listUni(ListLama)),
    assertz(listUni(ListBaru)).


/* Helper UNI */
uni_Info(Pemain, ListKartu):-
    turn(Pemain),
    kartu_diTangan(Pemain, ListKartu).

/* UNI */
uni(Number):-
    uni_Info(Pemain, ListKartu),
    list_length(ListKartu, LenKartu),
    (Number < 1 ; Number > LenKartu),
    !,
    write('Nomor kartu tidak sesuai rentang jumlah kartu. Masukkan nomor kartu yang sesuai: '),
    read(NewNumber),
    uni(NewNumber).

/* # Sementara dimatiin sampai efek kartu berhasil diimplikasi #
uni(Number):-
    uni_Info(Pemain, ListKartu),
    getCard(ListKartu, Number, Kartu),
    \+ isKartuValid(Kartu),
    !,
    write('Kartu tidak sesuai dengan efek sebelumnya. Masukkan nomor kartu dengan efek yang sesuai: '),
    read(NewNumber),
    uni(NewNumber).
*/

uni(Number):-
    uni_Info(Pemain, ListKartu),
    list_length(ListKartu, LenKartu),
    \+ LenKartu =:= 2,
    !,
    write(Pemain), write(' tidak memenuhi syarat perintah UNI!'), nl,
    repeat_N_ambilKartu(1, AmbilKartu),
    write(Pemain), write(' mendapatkan 1 kartu acak.'), nl,
    nextTurn.

uni(Number):-
    uni_Info(Pemain, ListKartu),
    list_length(ListKartu, LenKartu),
    (Number > 0, (Number < LenKartu ; Number == LenKartu)),
    /* # Sementara dimatiin sampai efek kartu berhasil diimplikasi # */
    /* Number1 is Number - 1,
    getCard(ListKartu, Number1, Kartu),
    isKartuValid(Kartu), */
    LenKartu =:= 2,
    !,
    mainkanKartu(Number),
    write(Pemain), write(' menyerukan UNI!'), nl,
    addListUni(Pemain).