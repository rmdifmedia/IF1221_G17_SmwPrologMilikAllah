:- include('player.pl').
:- include('fact.pl').
:- include('startGame.pl').
:- include('helper.pl').

:- dynamic(listSembunyi/1).

turn('Usagi').
kartu_diTangan('Usagi', [merah-3, kuning-0, hijau-6]).

listSembunyi([]).

inputKartuSembunyi(Nama, Kartu):-
    open('dataSembunyi.txt', append, N),
    writeq(N, Nama),
    write(N, '.'), 
    nl(N),
    write(N, Kartu),
    write(N, '.'),
    nl(N), 
    close(N).  

sembunyikanKartu(Number):-
    turn(Pemain),
    listSembunyi(ListSembunyi),
    cekSembunyi(Pemain, ListSembunyi,_),
    write(Pemain), write(' sudah memiliki kartu sembunyi. Perintah tidak valid. Gunakan perintah listKartu untuk cek semua kartu '), write(Pemain), nl,
    !.
    
sembunyikanKartu(Number):-
    turn(Pemain),
    kartu_diTangan(Pemain, ListKartu),
    list_length(ListKartu, Len),
    Number > Len,
    !,
    write('Nomor kartu tidak sesuai rentang jumlah kartu.'), nl.

sembunyikanKartu(Number):-
    turn(Pemain),
    kartu_diTangan(Pemain, ListKartu),
    list_length(ListKartu, Len),
    Len == 1, 
    !,
    write(Pemain), write(' hanya memiliki satu kartu. Perintah tidak dapat digunakan.'), nl.

sembunyikanKartu(Number):-
    turn(Pemain),
    kartu_diTangan(Pemain, ListKartu),
    NumberMin is Number - 1,
    get_index(ListKartu, NumberMin, Kartu), 
    list_length(ListKartu, LenKartu),
    \+LenKartu =:= 1, 
    inputKartuSembunyi(Pemain, Kartu),
    removeCard(Kartu, ListKartu, Updated),
    retract(kartu_diTangan(Pemain, ListKartu)),
    assertz(kartu_diTangan(Pemain, Updated)),
    retract(listSembunyi(ListLama)),
    assertz(listSembunyi([sembunyi(Pemain, Kartu)|ListLama])),
    write(Kartu), write(' berhasil disembunyikan.'), nl,
    !.

cekSembunyi(Pemain,[],_):-
    !,
    fail.

cekSembunyi(Pemain, [sembunyi(Nama, Kartu)|Tail], Kartu):-
    Pemain == Nama
    -> !
    ;
    cekSembunyi(Pemain, Tail, Kartu).

hapusDariList(_,[],[]):- 
    !.

hapusDariList(H,[H|T],T):-
    !.

hapusDariList(H,[List|Tail],[List|Hasil]):-
    hapusDariList(H, Tail, Hasil).


copyLines(InStream,_,_):-
    at_end_of_stream(InStream).

copyLines(InStream, OutStream, Pemain):-
    \+at_end_of_stream(InStream),
    !,
    read(InStream, Nama),
    (   Nama == end_of_file
    ->  true                    % ← stop cleanly
    ;   read(InStream, Kartu),
        (   Nama == Pemain
        ->  true
        ;   writeq(OutStream, Nama),
            write(OutStream, '.'),
            nl(OutStream),
            write(OutStream, Kartu),
            write(OutStream, '.'),
            nl(OutStream)
        ),
        copyLines(InStream, OutStream, Pemain)
    ).

copyStream(In, Out):-
    \+at_end_of_stream(In), !,
    get_char(In, Char),
    put_char(Out, Char),
    copyStream(In, Out).

copyStream(In,_):-
    at_end_of_stream(In).

gantiIsi:-
    open('temporary.txt', read, In),
    open('dataSembunyi.txt', write, Out),
    copyStream(In, Out),
    close(In),
    close(Out).

updateFileSembunyi(Pemain):-
    open('dataSembunyi.txt', read, InStream),
    open('temporary.txt', write, OutStream),
    copyLines(InStream, OutStream, Pemain),
    close(InStream),
    close(OutStream),
    gantiIsi.

tampilkanKartu:-
    turn(Pemain),
    listSembunyi(ListSembunyi),
    cekSembunyi(Pemain, ListSembunyi, Kartu)
    ->  !,
        hapusDariList(sembunyi(Pemain, Kartu), ListSembunyi, UpdateListSembunyi),
        retract(listSembunyi(ListSembunyi)),
        assertz(listSembunyi(UpdateListSembunyi)),
        updateFileSembunyi(Pemain),
        kartu_diTangan(Pemain, ListKartu),
        append_element(ListKartu, Kartu, UpdateListKartu),
        retract(kartu_diTangan(Pemain, ListKartu)),
        assertz(kartu_diTangan(Pemain, UpdateListKartu)),
        write('Kartu '), write(Kartu), write(' sudah tidak sembunyi'), nl
    ;
    !,
    write('tidak ada kartu sembunyi untuk ditampilkan').
