:- dynamic(kartu/2).
:- dynamic(kartuTop/2).
:- dynamic(kartu_diTangan/2).
:- dynamic(turn/1).
:- dynamic(currColor/1).
:- dynamic(deck/1).
:- dynamic(fullDeck/1).
:- dynamic(listTantang/1).
:- dynamic(listHistoryTop/1).
:- include('helper.pl').

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
jenis(draw_two).

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
kartu(merah,draw_two).
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
kartu(kuning,draw_two).
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
kartu(hijau,draw_two).
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
kartu(biru,draw_two).
kartu(hitam,wild).
kartu(hitam,wild_draw_four).
kartu(hitam, mimic).

:- initialization(initdeck).

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
    findAllKartu(55,0,[]).

/* Predikat */
efekKartu(W-J):-
    !,
    efekKartu(W, J).

/*helper check kartu aksi untuk efek mimic*/
isKartuAksi(W-J):-
    !,
    isKartuAksi(W,J).

isKartuAksi(_,J):-
    J == 'skip', !.
isKartuAksi(_,J):-
    J == 'draw_two', !.
isKartuAksi(_,J):-
    J == 'wild_draw_four', !.
isKartuAksi(_,J):-
    J == 'wild', !.

cekListHitory(_, [], hitam, wild):-!.
cekListHitory(N, [W-J|Tail], W, J):-
    isKartuAksi(W, J), !,
    format('Kartu aksi yang terakhir dimainkan: ~w-~w (~w giliran lalu)', [W, J, N]), nl.
cekListHitory(N, [W-J|Tail], HistoryW, HistoryJ):-
    N1 is N + 1,
    cekListHitory(N1, Tail, HistoryW, HistoryJ).

pilihwarnaLoop(WarnaBaru):-
    write('Pilih warna: '), nl, 
    read(WarnaInput),
    (
        warna(WarnaInput)
    ->  setWarna(WarnaInput),
        WarnaBaru = WarnaInput
    ;   write('Warna tidak valid! Silahkan pilih warna lain :-D'), nl,
        pilihwarnaLoop(WarnaBaru)
    ). 

assertz(listHistoryTop([])).

/* efek kartu*/ 
efekKartu(hitam, mimic):-
    write('Menulusuri riwayat permainan...'), nl,
    listHistoryTop(History),
    cekListHitory(1, History, W, J),
    format('Kartu mimic akan menyalin efek kartu ~w~n', [J]),
    (
        J == 'wild'
    ->  efekKartu(hitam, wild)

    ;   J == 'wild_draw_four'
    ->  efekKartu(hitam, wild_draw_four)

    ;   pilihwarnaLoop(WarnaBaru),
        efekKartu(WarnaBaru, J)
    ), !.


efekKartu(_, skip):-
    nextTurn, 
    nextTurn.

efekKartu(_, N) :-
    number(N), nextTurn.

efekKartu(_, reverse) :- 
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

efekKartu(_, draw_two) :-
    nextTurn,
    repeat_N_ambilKartu(2, AmbilKartu),
    nextTurn.

efekKartu(hitam, wild_draw_four) :-
    turn(PrevPlayer),
    write('Pilih Warna Aktif : '),
    read(WarnaAktif),
    (
        warna(WarnaAktif)
        ->  setWarna(WarnaAktif)
        ;   write('Warna tidak valid! Silahkan pilih warna lain :-D'), nl,
            efekKartu(hitam, wild_draw_four)
    ),
    addListTantang(PrevPlayer),
    nextTurn,
    turn(NextPlayer),
    format('~nGiliran ~w! Pilih opsi berikut~n1. Ambil 4 kartu~n2. Tantang~nKetik Opsi: ', [NextPlayer]),
    read(Opsi),
    ( Opsi = 'Ambil Kartu' -> opsiDrawFour(1)
    ; Opsi = 'tantang' -> opsiDrawFour(2)
    ; write('Opsi tidak valid!'), nl,
      efekKartu(hitam, wild_draw_four)  
    ).

opsiDrawFour(1) :- 
    nextTurn,
    repeat_N_ambilKartu(2, AmbilKartu),
    nextTurn.

opsiDrawFour(2) :-
    tantang.

listTantang([]).
addListTantang(Nama):-
    retract(listTantang(ListLama)),
    assertz(listTantang([Nama|ListLama])).

/* Helper */

randomCard(ListKartu, ChosenKartu):-
    list_length(ListKartu, Len),
    random(0, Len, Idx),
    get_index(ListKartu, Idx, ChosenKartu).

ambilCartu :-
    fullDeck(Deck),
    randomCard(Deck,ChosenCard),
    turn(Nama),
    retract(kartu_diTangan(Nama, ListLama)),
    assertz(kartu_diTangan(Nama, [ChosenCard|ListLama])).

ambilKartu :-
    repeat_N_ambilKartu(1, AmbilKartu),
    nextTurn,
    !.

repeat_N_ambilKartu(0, AmbilKartu):- !.
repeat_N_ambilKartu(N, AmbilKartu):-
    N > 0,
    ambilCartu,
    NextN is N-1,
    repeat_N_ambilKartu(NextN, AmbilKartu).

/* mainkanKartu */
/* Helper */
isKartuValid(W-J):-
    !,
    isKartuValid(W,J).

isKartuValid(W, J) :-
    \+ W == hitam,
    currColor(W).
isKartuValid(hitam,J):- /*kartu valid yaitu kartu wild*/
    kartuTop(W,_),
    W \== hitam.
isKartuValid(W,_):- /*kartu valid warnanya sama*/
    kartuTop(W,_). 
isKartuValid(W,X):- /*kartu valid jenisnya sama*/
    \+ W == 'hitam',
    \+ X == 'draw_two',
    kartuTop(_,X).

isKartuValid(W, drawtwo):-
    \+ W == 'hitam',
    kartuTop(_,J),
    \+ J == 'draw_two'.

removeCard(_, [], []).
removeCard(X, [X|T], T).
removeCard(X, [H|T], [H|Terhapus]):-
    X\==H,
    removeCard(X,T,Terhapus).  

setDiscardTop(W,J):-
    riwayatKartuTop,
    retractall(kartuTop(_,_)),
    assertz(kartuTop(W,J)),
    setWarna(W).

/* case awal; pas discardtop masih kosong*/
riwayatKartuTop:-
    \+ kartuTop(_,_),
    !.

riwayatKartuTop:-
    kartuTop(TopW, TopJ),
    listHistoryTop(History),
    append_elementFront(History, TopW-TopJ, NewHistory),
    retractall(listHistoryTop(_)),
    assertz(listHistoryTop(NewHistory)), !.

tantang :-
    turn(Pemain),
    kartuTop(hitam, wild_draw_four),
    currColor(WarnaAktif),
    write('Tantangan Dilakukan!'), nl,
    listTantang([PrevPemain|_]),
    kartu_diTangan(PrevPemain, ListKartu),
    (member(WarnaAktif-_, ListKartu)
    -> write('Tantangan Berhasil'), nl,
    format('~w Mendapatkan 4 Kartu Acak...~n', [PrevPemain]),
    nextTurn, repeat_N_ambilKartu(4, _), nextTurn,
        ( Jumlah =:= 2 -> nextTurn ;  true)
    ;
    write('Tantangan Gagal'), nl,
    format('~w Mendapatkan 6 Kartu Acak...~n', [Pemain]),
    repeat_N_ambilKartu(6, _), nextTurn
    ), 
    retractall(listTantang(_)),  
    assertz(listTantang([])).

mainkanKartu(Number):-
    turn(Nama),
    kartu_diTangan(Nama, ListKartu),
    listUrutan(ListPemain),
    Index is Number - 1,
    get_index(ListKartu, Index, ChosenCard),
    get_index(ListKartu, Index, ChosenW-ChosenJ),
    ( isKartuValid(ChosenW,ChosenJ)
    ->  removeCard(ChosenCard, ListKartu, Updated),
        retractall(kartu_diTangan(Nama, ListKartu)),
        assertz(kartu_diTangan(Nama, Updated)),
        setDiscardTop(ChosenW,ChosenJ),
        efekKartu(ChosenW,ChosenJ)
    
    ;   write('Duhh... Kartunya gak sesuai nich!'), nl,
        format('Kamu bisa menginput ulang kartu atau ketik \'Cancel\' jika tidak ingin memainkan kartu :D~nKetik Opsi: ',[]), 
        read(Ans),
        (
            Ans == 'Cancel'
            -> ambilKartu
            ;
            Ans = mainkanKartu(Nomor)
            -> mainkanKartu(Nomor)
        )

    ), !.
