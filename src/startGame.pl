/*Deklarasi Fakta*/
:- dynamic(gameRun/1).     %gameRun(Status)
:- dynamic(playerName/1).  %playerName(Player)
:- dynamic(playerCount/1). %playerCount(Count)
:- dynamic(listPlayer/1). %listPlayer(List)
:- dynamic(listUrutan/1). %listUrutan(List)
:- dynamic(listKartu/1). %listKartu(List)
:- dynamic(listHistoryTop/1).

/* Input jumlah pemain dengan batasan */
newGame:-
    initdeck,
    retractall(arah(_)),
    retractall(turn(_)),
    retractall(kartuTop(_,_)),
    retractall(listKartu(_)),
    retractall(kartu_diTangan(_,_)),
    retractall(listUrutan(_)),
    retractall(listPlayer(_)),
    retractall(playerName(_)),
    retractall(playerCount(_)),
    retractall(listHistoryTop(_)),
    assertz(arah(kanan)),
    assertz(gameRun(true)),
    assertz(listHistoryTop([])),
    inputPemain,
    !.

inputPemain:-
    write('Masukkan jumlah pemain: '),
    read(JumlahPemain),
    checkValidInput(JumlahPemain),
    hitungPemain(JumlahPemain).

checkValidInput(JumlahPemain):-
    \+integer(JumlahPemain) ->(
    write('Mohon masukkan angka antara 2-4.'),
    nl,
    inputPemain);
    !.

hitungPemain(JumlahPemain):-
    JumlahPemain >= 2,
    JumlahPemain =< 4,
    assertz(playerCount(JumlahPemain)),
    nl,
    nl,
    pemainCounter(JumlahPemain, 0).

hitungPemain(JumlahPemain):-
    (JumlahPemain < 2;
    JumlahPemain > 4),
    write('Mohon masukkan angka antara 2-4.'),
    nl,
    inputPemain.

/* Menghitung jumlah pemain untuk input data */

pemainCounter(Number,Number):-
    nl,
    write('Urutan pemain: '),
    playerCount(Jumlah),
    findAllPemain(Jumlah,0,[]),
    listPlayer(List),
    randomUrutan(Number, 1, List, []).

pemainCounter(Number, N):-
    N < Number,
    N1 is N + 1,
    namaPemain(N1),
    pemainCounter(Number, N1).

/* Input data pemain yang valid */
inputDataPemain(Nama):- open('dataNama.txt', append, N),
                        writeq(N,Nama),
                        write(N, '.'),
                        nl(N),
                        close(N).

findNama(Nama,_,0):-
    retract(playerName(Nama)),
    !.

findNama(Nama,[NamaAwal|Tail],N):-
    N1 is N - 1,
    (Nama == NamaAwal ->
    !;
    findNama(Nama,Tail,N1)).

findAllPemain(Jumlah,Jumlah,_):-
    !.

findAllPemain(Jumlah,X,List):-
    playerName(Nama),
    append_element(List,Nama,NewList),
    retract(playerName(Nama)),
    X1 is X + 1,
    retractall(listPlayer(_)),
    assertz(listPlayer(NewList)),
    findAllPemain(Jumlah,X1,NewList),
    assertz(playerName(Nama)).

/* Cek format nama agar pasti didahului kapital */
formatInvalid(N):-
    write('Nama harus mengandung huruf! Masukkan nama dengan benar : '),
    read(NamaLain),
    cekFormatNama(NamaLain,N).

cekFormatNama(Nama,N):-
    \+integer(Nama) ->
    (findAllPemain(N,0,[]),
    listPlayer(List),
    list_length(List,Len),
    findNama(Nama,List,Len) ->
    (write('Nama sudah digunakan. Masukkan nama lain : '),
    read(NamaLain),
    cekFormatNama(NamaLain,N));
    assertz(playerName(Nama)),
    !);
    formatInvalid(N).

/* Prompt meminta nama pemain */
namaPemain(N):-
    write('Masukkan nama pemain '),
    write(N),
    write(' : '),
    read(Nama),
    N1 is N - 1,
    cekFormatNama(Nama,N1).

/* Urutan Random Pemain */

randomMember(List,Player,Idx):-
    list_length(List,Len),
    random(0,Len,Idx),
    get_index(List,Idx,Player).

randomUrutan(Number, Number, List, ListUrutan):-
    randomMember(List,Player,Idx),
    append_element(ListUrutan, Player, ResList),
    write(Player),
    write('.'),
    assertz(listUrutan(ResList)),
    nl,
    nl,
    bagiDeck,
    !.

randomUrutan(Number, N, List, ListUrutan):-
    N < Number,
    !,
    randomMember(List,Player,Idx),
    append_element(ListUrutan, Player, ResList),
    write(Player),
    write(' - '),
    delete_element(List,Idx,NewList),
    N1 is N + 1,
    randomUrutan(Number, N1, NewList, ResList).

/* Pembagian Kartu */

ambilKartuAwal(0,NewList,_):-
    assertz(listKartu(NewList)),
    !.

ambilKartuAwal(N,List,Deck):-
    random(0,55,Index),
    get_index(Deck,Index,Kartu),
    append_element(List,Kartu,NewList),
    N1 is N - 1,
    ambilKartuAwal(N1,NewList,Deck).

bagiKartu(Jumlah,Jumlah,Deck,ListPlayer):-
    get_index(ListPlayer,0,CurrentPlayer),
    ambilKartuAwal(7,[],Deck),
    listKartu(DeckPlayer),
    assertz(kartu_diTangan(CurrentPlayer,DeckPlayer)),
    retractall(listKartu(_)),
    !.

bagiKartu(Jumlah,X,Deck,ListPlayer):-
    get_index(ListPlayer,0,CurrentPlayer),
    delete_element(ListPlayer,0,NewPlayerList),
    ambilKartuAwal(7,[],Deck),
    listKartu(DeckPlayer),
    assertz(kartu_diTangan(CurrentPlayer,DeckPlayer)),
    retractall(listKartu(_)),
    X1 is X + 1,
    bagiKartu(Jumlah,X1,Deck,NewPlayerList).

bagiDeck:-
    fullDeck(Deck),
    listUrutan(ListPlayer),
    playerCount(Jumlah),
    bagiKartu(Jumlah,1,Deck,ListPlayer),
    write('Setiap pemain mendapatkan 7 kartu acak.'),
    nl,
    nl,
    discardFirst(Deck).

discardFirst(Deck):-
    random(0,55,Index),
    get_index(Deck,Index,Kartu),
    get_index(Deck,Index,W-J),
    setDiscardTop(W,J),
    write('Kartu discard top: '),
    write(Kartu),
    write('.'),
    nl,
    nl,
    firstTurn.

firstTurn:-
    listUrutan(Urutan),
    get_index(Urutan,0,FirstPlayer),
    write('Giliran '),
    write(FirstPlayer),
    write('.'),
    assertz(turn(FirstPlayer)).                  