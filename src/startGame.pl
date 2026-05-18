:- include('helper.pl').

/*Deklarasi Fakta*/
:- dynamic(gameRun/1).     %gameRun(Status)
:- dynamic(playerName/1).  %playerName(Player)
:- dynamic(playerCount/1). %playerCount(Count).
:- dynamic(listPlayer/1). %listPlayer(List).

/* Input jumlah pemain dengan batasan */

startGame:-
    retractall(listPlayer(_)),
    retractall(playerName(_)),
    retractall(playerCount(_)),
    assertz(gameRun(true)),
    inputPemain.


inputPemain:-
    write('Masukkan jumlah pemain: '),
    read(JumlahPemain),
    hitungPemain(JumlahPemain).

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
    /*write('Urutan pemain: '),
    listPlayer(List),
    randomUrutan(Number, 1, List, []),*/
    playerName(X).

pemainCounter(Number, N):-
    N < Number,
    N1 is N + 1,
    namaPemain(N1),
    pemainCounter(Number, N1).

/* Input data pemain yang valid */
/*inputDataPemain(Nama):- open('dataNama.txt', append, N),
                        writeq(N,Nama),
                        write(N, '.'),
                        nl(N),
                        close(N).*/

/* Memastikan nama pemain unik (Tidak ada di list) */
/*cekSemuaNama(ListNama):-    open('dataNama.txt', read, Stream),
                            namaStream(Stream, ListNama),
                            close(Stream).

namaStream(Stream, []):- at_end_of_stream(Stream),
                         !.

namaStream(Stream, [Nama|R]):-  \+at_end_of_stream(Stream),
                                read_term(Stream, Nama, []),
                                Nama \== end_of_file,
                                !,
                                namaStream(Stream, R).

namaStream(_,[]).

cekListNama(Nama):- cekSemuaNama(ListNama),
                    member(Nama, ListNama).*/

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
changeCap(NamaLama,HurufBaru,NamaBaru):-
    atom_codes(NamaLama,[_Awal|Rest]),
    atom_codes(NamaBaru,[HurufBaru|Rest]).

formatInvalid:-
    write('Input nama tidak valid! Masukkan nama dengan benar : '),
    read(NamaLain),
    cekFormatNama(NamaLain).

cekFormatNama(Nama):-
    atom_codes(Nama, [Huruf|_]),
    (Huruf >= 65,
    Huruf =< 90) ->
    (HurufBaru is Huruf + 32,
    changeCap(Nama,HurufBaru,NamaBaru),
    assertz(playerName(NamaBaru)),
    playerCount(Jumlah),
    findAllPemain(Jumlah,0,[]),
    listPlayer(List),
    list_length(List,Len),
    findNama(NamaBaru,List,Len) ->
    (write('Nama sudah digunakan. Masukkan nama lain : '),
    read(NamaLain),
    cekFormatNama(NamaLain));
    assertz(playerName(NamaBaru)),
    !);
    formatInvalid.

/* Prompt meminta nama pemain */
namaPemain(N):- write('Masukkan nama pemain '),
                write(N),
                write(' : '),
                read(Nama),
                (cekFormatNama(Nama) -> true;
                namaPemain(N)).

/* Simpan data pemain */
inputUrutan(Member):-   open('dataUrutan.txt', append, Urutan),
                        writeq(Urutan, Member),
                        write(Urutan, '.'),
                        nl(Urutan),
                        close(Urutan).

/* Pilih random dari list */
randomMember(Member, List):-    length(List, Len),
                                random(0, Len, Index),
                                nth0(Index, List, Member).

/* Urutan Random Pemain */

randomUrutan(Number, N, List, ListUrutan):- N < Number,
                                            !,
                                            randomMember(Member, List),
                                            append(ListUrutan, [Member], ResList),
                                            inputUrutan(Member),
                                            write(Member),
                                            write(' - '),
                                            delete(List, Member, NewList),
                                            N1 is N + 1,
                                            randomUrutan(Number, N1, NewList, ResList).

randomUrutan(Number, Number, List, ListUrutan):-    randomMember(Member, List),
                                                    append(ListUrutan, [Member], ResList),
                                                    inputUrutan(Member),
                                                    write(Member),
                                                    write('.'),
                                                    nl,
                                                    nl,
                                                    /*createDeck(FullDeck),
                                                    initListAwal(Number, 0, ResList),
                                                    initDeckPemain(Number, 0, 1, ResList, FullDeck),
                                                    afterPembagian(ResList),*/
                                                    !.

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
                            