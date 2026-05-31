/*Deklarasi Fakta*/

:- dynamic(gameRun/1).     %gameRun(Status)
:- dynamic(playerName/1).  %playerName(Player)
:- dynamic(playerCount/1). %playerCount(Count)
:- dynamic(listPlayer/1).  %listPlayer(List)
:- dynamic(listUrutan/1).  %listUrutan(List)
:- dynamic(listKartu/1).   %listKartu(List)
:- dynamic(modeGame/1).    %modeGame(Mode)
:- dynamic(playerTeam/1).  %playerTeam(List)
:- dynamic(playerTeamNumber/2). %playerTeamNumber(Player,TeamNumber)
:- dynamic(listPlayer/1). %listPlayer(List)
:- dynamic(listUrutan/1). %listUrutan(List)
:- dynamic(listKartu/1). %listKartu(List)
:- dynamic(listHistoryTop/1).

/* Input jumlah pemain dengan batasan */
newGame:-
    initdeck,
    initListUni,
    initListSembunyi,
    retractall(playerTeamNumber(_,_)),
    retractall(playerTeam(_)),
    retractall(modeGame(_)),
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
    modeGame,
    !.

modeGame:-
    nl,
    write('Tersedia 2 mode permainan.'),
    nl,
    write('1. Mode klasik'),
    nl,
    write('2. Mode turnamen'),
    nl,
    write('Pilih mode permainan: '),
    read(Mode),
    checkValidMode(Mode),
    pilihMode(Mode),
    (Mode == 2 ->
    write('Permainan dimulai dalam mode turnamen.'),
    assertz(playerCount(4)),
    nl,
    nl,
    pemainCounter(4,0);
    write('Permainan dimulai dalam mode klasik.'),
    nl,
    nl,
    inputPemain),
    !.

checkValidMode(Mode):-
    (\+integer(Mode) ->
    write('Mohon masukkan angka 1 atau 2.'),
    nl,
    modeGame,
    !;
    !).

pilihMode(Mode):-
    Mode >= 1,
    Mode =< 2,
    assertz(modeGame(Mode)).

pilihMode(Mode):-
    (Mode < 1;
    Mode > 2),
    write('Mohon masukkan angka 1 atau 2.'),
    nl,
    nl,
    modeGame.

inputPemain:-
    write('Masukkan jumlah pemain: '),
    read(JumlahPemain),
    checkValidInput(JumlahPemain),
    hitungPemain(JumlahPemain).

checkValidInput(JumlahPemain):-
    (\+integer(JumlahPemain) ->
    write('Mohon masukkan angka antara 2-4.'),
    nl,
    inputPemain,
    !;
    !).

hitungPemain(JumlahPemain):-
    JumlahPemain >= 2,
    JumlahPemain =< 4,
    assertz(playerCount(JumlahPemain)),
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
    playerCount(Jumlah),
    findAllPemain(Jumlah,0,[]),
    listPlayer(List),
    modeGame(Mode),
    (Mode == 2 ->
    write('Membentuk tim secara acak...'),
    nl,
    nl,
    randomTim(0,2,List,[]);
    write('Urutan pemain: '),
    randomUrutan(Number, 1, List, [])).

pemainCounter(Number, N):-
    N < Number,
    N1 is N + 1,
    namaPemain(N1),
    pemainCounter(Number, N1).

/* Input data pemain yang valid */
inputDataPemain(Nama):-
    open('dataNama.txt', append, N),
    writeq(N,Nama),
    write(N, '.'),
    nl(N),
    close(N).

findNama(Nama,_,0,Checker):-
    Checker = 0,
    !.

findNama(Nama,[NamaAwal|Tail],N,Checker):-
    N1 is N - 1,
    (Nama == NamaAwal ->
    Checker = 1,
    !;
    findNama(Nama,Tail,N1,Checker)).

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
    (\+integer(Nama) ->
    findAllPemain(N,0,[]),
    listPlayer(List),
    list_length(List,Len),
    findNama(Nama,List,Len,Checker),
    ( Checker == 0 ->
    assertz(playerName(Nama)),
    inputDataPemain(Nama);
    write('Nama sudah digunakan. Masukkan nama lain : '),
    read(NamaLain),
    cekFormatNama(NamaLain,N));
    formatInvalid(N)).

/* Prompt meminta nama pemain */
namaPemain(N):-
    format('Masukkan nama pemain ~d : ',[N]),
    read(Nama),
    N1 is N - 1,
    (N == 1 ->
    (\+integer(Nama)->
     assertz(playerName(Nama)),
     inputDataPemain(Nama);
     formatInvalid(N));
    cekFormatNama(Nama,N1)).

/* Urutan Random Pemain */

randomMember(List,Player,Idx):-
    list_length(List,Len),
    random(0,Len,Idx),
    get_index(List,Idx,Player).

randomTim(TeamCount,TeamCount,_,_):-
    nl,
    listPlayer(List),
    playerCount(Number),
    randomUrutan(Number, 1, List, []).

randomTim(TeamNumber,TeamCount,List,ListTeam):-
    TeamNum is TeamNumber + 1,
    randomMember(List,Player1,Idx),
    delete_element(List,Idx,NewList),
    randomMember(NewList,Player2,Idxx),
    delete_element(NewList,Idxx,NewList2),
    append_element(ListTeam,Player1,FirstList),
    append_element(FirstList,Player2,FinalList),
    assertz(playerTeam(FinalList)),
    assertz(playerTeamNumber(Player1,TeamNum)),
    assertz(playerTeamNumber(Player2,TeamNum)),
    get_index(FinalList,0,FirstPlayer),
    get_index(FinalList,1,SecondPlayer),
    format('Tim ~d : ~w, ~w.~n', [TeamNum,Player1,Player2]),
    randomTim(TeamNum,TeamCount,NewList2,[]).

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
    format('Kartu discard top: ~w.~n~n',[Kartu]),
    firstTurn.

firstTurn:-
    listUrutan(Urutan),
    get_index(Urutan,0,FirstPlayer),
    format('Giliran ~w.',[FirstPlayer]),
    assertz(turn(FirstPlayer)),
    listPlayer(List),
    list_length(List,LenList),
    cekJumlahKartuPemain(List,LenList,Checker),
    random(X),
    (X =< 0.2 ->
    godsHand;
    true).               