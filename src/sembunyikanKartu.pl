:- include('player.pl').
:- include('fact.pl').
:- include('startGame.pl').
:- include('helper.pl').

turn('Usagi').
kartu_diTangan('Usagi', [merah-3, kuning-0, hijau-6]).


inputKartuSembunyi(Nama, Kartu):-
    open('dataKartuSembunyi.txt', append, N),
    writeq(N, Nama),
    write(N, ' '), 
    write(N, Kartu),
    write(N, '.'),
    nl(N), 
    close(N).

read_word_chars(Acc, ReversedChars):-
    get_char(X),
    (   X = at_end_of_stream ; X = ' ' ; X = '.' ),
    !,
    reverse(Acc, ReversedChars).

read_word_chars(Acc, TmpResult):-
    get_char(Char).
    read_word_chars([Char|Acc], Result).

read_word(N, Word):-
    read_word_chars([], X),
    atom_chars(Word, X).

findNamaHiddingCard(Nama, N):-
    read_word(N, Word),
    (   Word = Nama
        ->  true.
            getListKartuSembunyi(Nama, ListKartuSembunyi),
            returnKartuSembunyi(Nama, N).   )
    ; ( Word = ''
        ->  false.  )
    ; findNamaHiddingCard(Nama, N).

cekKartuTersembunyi(Nama):-
    open('dataKartuSembunyi.txt', read, N),

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
    assertz(kartu_diTangan(Pemain, Updated)).

tampilkanKartu:-
    turn(Pemain),
    cekKartuTersembunyi(Pemain),