//kartu(Warna, Jenis)//

//Warna Normal//
warna(merah).
warna(kuning).
warna(hijau).
warna(biru).

//Jenis Kartu Warna//
kartu(W, N) :- warna(W), between(0,9,N).
kartu(W, skip) :- warna(W).
kartu(W, jreverse).
kartu(W, drawtwo).

//Jenis Kartu Wild//
kartu(hitam, wild).
kartu(hitam, drawfour).

//Predicate Kartu Warna//
efekKartu(_, N) :-
    number(N), nextTurn.

efekKartu(_, jreverse) :- 
    reverseUrutan, nextTurn.

efekKartu(hitam, wild) :-
    write('Pilih Warna Aktif : '), nl,
    read(WarnaAktif), 
    setWarna(WarnaAktif),
    nextTurn.

//Alur Pemain//
:- dynamic turn/1.

jumlah(pemainCounter(Number,N)).

nextTurn :- 
    turn(Nama),
    arah(Arah),
    jumlah(Jumlah),
    (Arah = maju
    -> Next is (Nama+1) mod Jumlah
    ; Next is (Nama-1) mod Jumlah),
    retract(turn(_)),
    assert(turn(Next)).

ambilKartu :-
    random(Kartu),
    turn(Urutan),
    pemain(Urutan, Nama),
    retract(kartuPemain(Nama, ListLama)),
    append(ListLama, [Kartu], ListBaru),
    assert(kartuPemain(nama, ListBaru).)