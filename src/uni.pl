/* List UNI */
:- dynamic listUni\1

listUni([]).
addListUni(Nama):-
    retract(ListNama(ListLama)),
    assertz(ListNama([Nama|ListLama])).

syarat_UNI(Nama):-
    kartu_diTangan(Nama, ListKartu),
    length(ListKartu, Len),
    Len =:= 1.

updateListUni:-
    ListUni(ListLama),
    include(syarat_UNI, ListLama, ListBaru),
    retract(listUni(ListLama)),
    assertz(llistUni(ListBaru)).

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
    format('~w menyerukan UNI!', [Pemain]), nl,
    addListUni(Pemain),
    !.

uni(Number):-
    turn(Pemain),
    kartu_diTangan(Pemain, ListKartu),
    length (ListKartu, LenKartu),
    (Number < 0 ; Number > LenKartu),
    format('~w, masukin nomor yang bener. emng iya kamu punya ~d kartu.', [Pemain, Number]),
    nl,
    write("masukin nomor yang bener: "),
    read(NewNumber),
    uni(NewNumber).

uni(Number):-
    turn(Pemain),
    kartu__diTangan(Pemain, ListKartu),
    getCard(ListKartu, Number, kartu(Warna, Jenis)),
    \+ isKartuValid(kartu(Warna, Jenis)),
    format('no no ya dek ~w, gabisa pake kartu ~w ~w. Perhatiin lagi ya dek efek kartu sebelumnya ;)', [Pemain, Warna, Jenis]),
    nl,
    write("masukin nomor kartu yang sesuai: "),
    read(NewNumber),
    uni(NewNumber).

uni(Number):-
    turn(Pemain),
    kartu_diTangan(Pemain, ListKartu),
    length(ListKartu, LenKartu),
    \+ LenKartu =:= 2,
    format('~w tidak memenuhi syarat perintah UNI!', [Pemain]), nl,
    repeat_N_ambilKartu(1, AmbilKartu),
    format('~w mendapat 1 kartu acak, kartu ~w ~w', [Pemain, Warna, Jenis]), nl,
    nextTurn.