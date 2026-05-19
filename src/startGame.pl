:- include('helper.pl').

/*Deklarasi Fakta*/
:- dynamic(gameRun/1).     %gameRun(Status)
:- dynamic(playerName/1).  %playerName(Player)
:- dynamic(playerCount/1). %playerCount(Count).
:- dynamic(listPlayer/1). %listPlayer(List).
:- dynamic(listUrutan/1). %ListUrutan(List).

/* Input jumlah pemain dengan batasan */

startGame:-
    retractall(listUrutan(_)),
    retractall(listPlayer(_)),
    retractall(playerName(_)),
    retractall(playerCount(_)),
    assertz(gameRun(true)),
    inputPemain.

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
    pemainCounter(JumlahPemain, 0).

hitungPemain(JumlahPemain):-
    (JumlahPemain < 2;
    JumlahPemain > 4),
    write('Mohon masukkan angka antara 2-4.'),
    nl,
    inputPemain.

/* Menghitung jumlah pemain untuk input data */

pemainCounter(Number,Number):-
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
    write('Input nama tidak valid! Masukkan nama dengan benar : '),
    read(NamaLain),
    cekFormatNama(NamaLain,N).

cekFormatNama(Nama,N):-
    atom_codes(Nama, [Huruf|_]),
    (Huruf >= 65,
    Huruf =< 90) ->
    (
    findAllPemain(N,0,[]),
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
    append(ListUrutan, Player, ResList),
    write(Player),
    write('.'),
    assertz(listUrutan(ResList)),
    nl,
    nl,
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

/*initListAwal(Number, Number, _):- !.

initListAwal(Number, N, ListUrutan):-   N < Number,
                                        nth0(N, ListUrutan, Nama),    
                                        assertz(kartu_diTangan(Nama, [])),
                                        N1 is N + 1,
                                        initListAwal(Number, N1, ListUrutan).

initDeckPemain(Number, Number, _, _, _).

initDeckPemain(Number, Number, 7, ListUrutan, FullDeck):-   N < Number,
                                                            nth0(N, ListUrutan, Nama),
                                                            pembagianAwal(Nama, FullDeck),
                                                            N1 is N + 1
                                                            initDeckPemain(Number, N1, 1, ListUrutan).

initDeckPemain(Number, N, NumRand, ListUrutan, FullDeck):-  N < Number,
                                                            nth0(N, ListUrutan, Nama),
                                                            pembagianAwal(Nama, FullDeck),
                                                            NextCard is NumRand + 1,
                                                            initDeckPemain(Number, N, NextCard, ListUrutan).

pembagianAwal(Nama, FullDeck):- randomCard(FullDeck, ChosenCard),
                                retract(kartu_diTangan(Nama, ListLama)),
                                assertz(Nama, [ChosenCard|ListLama]).

afterPembagian(ListUrutan):-    write('Setiap pemain mendapatkan 7 kartu acak.'),
                                nl,
                                nl,
                                nth0(0, ListUrutan, Pemain),
                                write('Giliran '),
                                write(Pemain).*/
                            