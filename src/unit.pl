:- include('fact.pl').
:- include('player.pl').
:- include('helper.pl').

:- dynamic(updateListUni/0).

turn(sawit).
kartu_diTangan(sawit, [kartu(merah, 0), kartu(kuning, 1), kartu(kuning, 3)]).

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

uni(Number):-
    uni_Info(Pemain, ListKartu),
    list_length(ListKartu, LenKartu),
    \+ LenKartu =:= 2,
    !,
    write(Pemain), write(' tidak memenuhi syarat perintah UNI!'), nl,
    repeat_N_ambilKartu(1, AmbilKartu),
    write(Pemain), write(' mendapatkan 1 kartu acak.'), nl,
    nextTurn.

/* NOTES: repeat_N_ambilKartu gagal. Pending benerin fact.pl ke yang work di gnu prolog */