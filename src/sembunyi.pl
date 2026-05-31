:- include('player.pl').
:- include('fact.pl').
:- include('startGame.pl').
:- include('helper.pl').

:- dynamic(listSembunyi/1).

turn('Usagi').
kartu_diTangan('Usagi', [merah-3, kuning-0, hijau-6]).

:-initialization(listSembunyi(_)).
:-dynamic(pemainSembunyi/2).

inputKartuSembunyi(Nama, Kartu):-
    open('dataSembunyi.txt', append, N),
    writeq(N, Nama),
    write(N, ' '), 
    write(N, Kartu),
    write(N, '.'),
    nl(N), 
    close(N).  

sembunyikanKartu(Number):-
    turn(Pemain),
    kartu_diTangan(Pemain, ListKartu),
    get_index(ListKartu, Number, Kartu), 
    list_length(ListKartu, LenKartu),
    \+LenKartu =:= 1, 
    inputKartuSembunyi(Pemain, Kartu),
    removeCard(ChosenCard, ListKartu, Updated),
    retractall(kartu_diTangan(Pemain, ListKartu)),
    assertz(kartu_diTangan(Pemain, Updated)),
    retractall(listSembunyi(_)),
    assertz(listSembunyi([sembunyi(Pemain, Kartu)|Tail])),
    !.

cekSembunyi(Pemain,_):-
    !.

cekSembunyi(Pemain, [sembunyi(Nama, Kartu)|Tail]):-
    Pemain == Nama
    -> !
    ;
    cekSembunyi(Pemain, Tail).

copyLines(InStream,_,_):-
    at_end_of_stream(InStream).

copyLines(InStream, OutStream, Pemain):-
    \=at_end_of_stream(InStream),
    !,
    read(InStream, Nama),
    read(InStream, Kartu),
    (   Nama == Pemain
    -> true
    ;
    writeq(OutStream, Nama),
    write(OutStream, ' '),
    write(OutStream, Kartu),
    write(OutStream, '.'),
    nl(OutStream)
    ),
    copyLines(InStream, OutStream, Pemain).

tampilkanKartu:-
    turn(Pemain),
    listSembunyi(ListSembunyi),
    cekSembunyi(Pemain, ListSembunyi)
    ->  retract(listSembunyi([sembunyi(Nama, Kartu)])),
        open('dataSembunyi.txt', read, InStream),
        open('temporary.txt', write, OutStream),
        copyLines(InStream, OutStream, Pemain),
        close(InStream),
        close(OutStream),
        rename_file('temporary.txt', 'dataSembunyi.txt'),
        write('delete sembunyi di txt dan update kartu_diTangan')
    ;
    write('ga valid').
