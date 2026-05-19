:- include('helper.pl').
<<<<<<< HEAD
:- include('player.pl').
=======

>>>>>>> main
:- dynamic(kartu/2).
:- dynamic(kartuTop/2).
:- dynamic(kartu_diTangan/2).
:- dynamic(turn/1).
:- dynamic(currColor/1).
:- dynamic(deck/1).
<<<<<<< HEAD
:- dynamic(listTantang/1).
=======
:- dynamic(fullDeck/1).
>>>>>>> main

setWarna(W):-
    retractall(currColor(_)),
    assertz(currColor(W)).

/* Deklarasi Fakta */
warna(merah).
warna(kuning).
warna(hijau).
warna(biru).

jenis(0). jenis(1). jenis(2). jenis(3).
jenis(4). jenis(5). jenis(6). jenis(7). jenis(8).
jenis(9).
jenis(skip).
jenis(reverse).
jenis(drawtwo).

kartu(W, N) :- 
    warna(W),
    jenis(N).

/*Deklarasi setiap kartu (Hapus aja selain hitam kalo udah bisa assetz otomatis)*/
kartu(merah,0).
kartu(merah,1).
kartu(merah,2).
kartu(merah,3).
kartu(merah,4).
kartu(merah,5).
kartu(merah,6).
kartu(merah,7).
kartu(merah,8).
kartu(merah,9).
kartu(merah,skip).
kartu(merah,reverse).
kartu(merah,drawtwo).
kartu(kuning,0).
kartu(kuning,1).
kartu(kuning,2).
kartu(kuning,3).
kartu(kuning,4).
kartu(kuning,5).
kartu(kuning,6).
kartu(kuning,7).
kartu(kuning,8).
kartu(kuning,9).
kartu(kuning,skip).
kartu(kuning,reverse).
kartu(kuning,drawtwo).
kartu(hijau,0).
kartu(hijau,1).
kartu(hijau,2).
kartu(hijau,3).
kartu(hijau,4).
kartu(hijau,5).
kartu(hijau,6).
kartu(hijau,7).
kartu(hijau,8).
kartu(hijau,9).
kartu(hijau,skip).
kartu(hijau,reverse).
kartu(hijau,drawtwo).
kartu(biru,0).
kartu(biru,1).
kartu(biru,2).
kartu(biru,3).
kartu(biru,4).
kartu(biru,5).
kartu(biru,6).
kartu(biru,7).
kartu(biru,8).
kartu(biru,9).
kartu(biru,skip).
kartu(biru,reverse).
kartu(biru,drawtwo).
kartu(hitam,wild).
kartu(hitam,drawfour).

/* Deck Kartu Uni */
findAllKartu(N,N,_).

findAllKartu(N,X,List):-
    kartu(W,J),
    append_element(List,W-J,NewList),
    retract(kartu(W,J)),
    X1 is X + 1,
    retractall(fullDeck(_)),
    assertz(fullDeck(NewList)),
    findAllKartu(N,X1,NewList),
    assertz(kartu(W,J)).

initdeck :-
    findAllKartu(54,0,[]).

/* Predikat */
efekKartu(_, skip):-
    nextTurn, 
    nextTurn.

efekKartu(_, N) :-
    number(N), nextTurn.

efekKartu(_, jreverse) :- 
    reverseUrutan, nextTurn.

efekKartu(hitam, wild) :-
    write('Pilih Warna Aktif : '), nl,
    read(WarnaAktif),
    (
        warna(WarnaAktif)
        ->  setWarna(WarnaAktif),
            nextTurn
        ;   write('Warna tidak valid! Silahkan pilih warna lain :-D'), nl,
            efekKartu(hitam, wild)
    ).

efekKartu(_, drawtwo) :-
    repeat_N_ambilKartu(2, AmbilKartu),
    nextTurn.

efekKartu(hitam, drawfour) :-
    turn(Pemain),
    repeat_N_ambilKartu(4, AmbilKartu),
    addListTantang(Pemain),
    nextTurn.

listTantang([]).
addListTantang(Nama):-
    retract(listTantang(ListLama)),
    assertz(listTantang([Nama|ListLama])).

/* Helper */
getCard([Card|_], 0, Card).
getCard([_|Tail], Index, Card):-
    Index > 0,
    Newindex is Index - 1,
    getCard(Tail, Newindex, Card).

randomCard(ListKartu, ChosenKartu):-
    length(ListKartu, Len),
    random(0, Len, Idx),
    getCard(ListKartu, Idx, ChosenKartu).

ambilKartu :-
    fullDeck(Deck),
    randomCard(Deck, ChosenCard),
    turn(Nama),
    retract(kartu_diTangan(Nama, ListLama)),
    assertz(kartu_diTangan(Nama, [ChosenCard|ListLama])).

repeat_N_ambilKartu(0, AmbilKartu):-!.
repeat_N_ambilKartu(N, AmbilKartu):-
    N > 0,
    ambilKartu,
    NextN is N-1,
    repeat_N_ambilKartu(NextN, AmbilKartu).

/* mainkanKartu */
/* Helper */
isKartuValid(kartu(hitam,_)).  /*kartu valid yaitu kartu wild*/
isKartuValid(kartu(W,_)):- /*kartu valid warnanya sama*/
    kartuTop(W,_). 

isKartuValid(kartu(W,X)):- /*kartu valid jenisnya sama*/
    \+ W == 'hitam',
    \+ X == 'drawtwo',
    kartuTop(_,X).

removeCard(_, [], []).
removeCard(X, [X|T], T).
removeCard(X, [H|T], [H|Terhapus]):-
    X\==H,
    removeCard(X,T,Terhapus).  

setDiscardTop(kartu(W,J)):-
    retractall(kartuTop(_,_)),
    assertz(kartuTop(W,J)),
    setWarna(W).

mainkanKartu(Number):-
    turn(Nama),
    kartu_diTangan(Nama, ListKartu),
    getCard(ListKartu, Number, ChosenCard),
    ( isKartuValid(ChosenCard)
    ->  removeCard(ChosenCard, ListKartu, Updated),
        retract(kartu_diTangan(Nama, ListKartu)),
        assertz(kartu_diTangan(Nama, Updated)), !,
        ChosenCard = kartu(W,J),
        setDiscardTop(ChosenCard),
        efekKartu(W,J)
    
    ;   write('Duhh... Kartunya gak sesuai nich!'), nl,
        write('Kamu bisa menginput ulang kartu atau ketik Cancel jika tidak ingin memainkan kartu :D'), nl,
        read(Ans),
        (
            Ans == 'Cancel'
            -> ambilKartu,
                nextTurn
            ;
            mainkanKartu(Ans)
        )

    ).
<<<<<<< HEAD
      
tantang :-
    turn(Pemain),
    kartuTop(hitam,drawfour),
    currColor(WarnaAktif),
    write("Tantangan Dilakukan!"), nl,
    listTantang([PrevPemain|_]),
    (member(kartu(WarnaAktif,_), ListKartu)
    -> write("Tantangan Berhasil"), nl,
    format("~w Mendapatkan 4 Kartu Acak...", [PrevPemain]), nl,
    nextTurn, repeat_N_ambilKartu(4), nextTurn
    ;
    write("Tantangan Gagal"), nl,
    format("~w Mendapatkan 6 Kartu Acak...", [Pemain]), nl,
    repeat_N_ambilKartu(6), nextTurn
    ), 
    retractall(listTantang(_)),  
    assertz(listTantang([])).

initDummy :-
    retractall(listUrutan(_)),
    retractall(kartu_diTangan(_,_)),
    retractall(turn(_)),
    retractall(kartuTop(_,_)),
    retractall(arah(_)),
    retractall(playerCount(_)),
    assertz(listUrutan(['Raya', 'Sisi'])),
    assertz(kartu_diTangan('Raya', [kartu(merah,9), kartu(hitam,wild), kartu(hijau,1), kartu(biru,skip)])),
    assertz(kartu_diTangan('Sisi', [kartu(hitam,drawfour), kartu(hijau,3), kartu(biru,jreverse)])),
    assertz(turn('Sisi')),
    assertz(kartuTop(hijau, 5)),
    assertz(arah(kanan)),
    assertz(playerCount(2)),
    initdeck.
=======
    
/*listUni :-
        findall(Nama, pemain(Nama), ListUNI).

    tambahOrangUni(Nama) :-
        assertz(pemain(Nama)).

    uni(Number) :-
        turn(Pemain),
        kartu_diTangan(Pemain, ListKartu),
        member(Kartu, ListKartu), 
        isKartuValid(Kartu),
        length(ListKartu, Length),
        Length =:= 2,
        mainkanKartu(Number),
        append(ListUNI, Pemain)
*/
>>>>>>> main
