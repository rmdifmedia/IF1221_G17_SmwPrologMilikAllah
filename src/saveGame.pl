:- include('player.pl').
:- include('fact.pl').
:- include('startGame.pl').
:- include('helper.pl').
:- dynamic(listHistoryTop/1).

inputNamaFile(NamaFileTxt) :-
    write('Masukkan nama file permainan: '),
    read(NamaFile),
    name(NamaFile, KodeASCII),
    insert_tail(KodeASCII, [46,116,120,116], KodeASCIILengkap),
    name(NamaFileTxt, KodeASCIILengkap).

insert_tail([], Tail, Tail).
insert_tail([H|T], Tail, [H|Result]) :-
    insert_tail(T, Tail, Result).

cekListHitory(_, [], hitam, wild):-!.
cekListHitory(N, [W-J|Tail], W, J):-
    isKartuAksi(W, J), !,
    format('Kartu aksi yang terakhir dimainkan: ~w-~w (~w giliran lalu)', [W, J, N]), nl.
cekListHitory(N, [W-J|Tail], HistoryW, HistoryJ):-
    N1 is N + 1,
    cekListHitory(N1, Tail, HistoryW, HistoryJ).

saveGame :-
    inputNamaFile(NamaFileTxt),
    open(NamaFileTxt, write, Stream),

    listUrutan(Urutan),
    format(Stream, 'urutan_pemain: ~w.~n', [Urutan]),

    turn(Giliran),
    format(Stream, 'giliran: ~w.~n', [Giliran]),

    kartuTop(W, J),
    format(Stream, 'discard_top: ~w-~w.~n', [W, J]),

    currColor(Warna),
    format(Stream, 'warna_aktif: ~w.~n', [Warna]),

    arah(Arah),
    format(Stream, 'arah_permainan: ~w.~n', [Arah]),

    listUni(UNI),
    format(Stream, 'status_UNI: ~w.~n', [UNI]),

    listUrutan(Players),
    saveKartuTangan(Players, Stream),

    listHistoryTop(History),
    cekListHitory(1, History, HW, HJ),
    format(Stream, 'Kartu_Aksi_Terakhir: ~w-~w.~n', [HW, HJ]),

    close(Stream),
    format('Status permainan berhasil disimpan ke ~w.~n', [NamaFileTxt]).

saveKartuTangan([], _).
saveKartuTangan([Player|Rest], Stream) :-
    kartu_diTangan(Player, Kartu),
    format(Stream, 'kartu(~w):~w.~n', [Player, Kartu]),
    saveKartuTangan(Rest, Stream).

loadGame :-
    inputNamaFile(NamaFileTxt),
    open(NamaFileTxt, read, Stream),
    loadFakta(Stream),
    close(Stream),
    turn(Giliran),
    write('Status permainan berhasil diambil dari ~w.~n', [NamaFileTxt]),
    write('Melanjutkan giliran ~w...', [Giliran]).

loadFakta(NamaFile) :-
    read_term(NamaFile, Term, []),
    ( Term == end_of_file -> true 
    ; restore_term(Term),
    loadFakta(NamaFile)
    ).

restore_term(urutan_pemain:Urutan)   :- assertz(listUrutan(Urutan)).
restore_term(giliran:Giliran)        :- assertz(turn(Giliran)).
restore_term(discard_top:W-J)        :- assertz(kartuTop(W, J)).
restore_term(warna_aktif:Warna)      :- assertz(currColor(Warna)).
restore_term(arah_permainan:Arah)    :- assertz(arah(Arah)).
restore_term(status_UNI:UNI)         :- assertz(listUni(UNI)).
restore_term(Kartu_Aksi_Terakhir:HW-HJ):- assertz(listHistoryTop(HW-HJ)).
restore_term(kartu(Player):Kartu)    :- assertz(kartu_diTangan(Player, Kartu)).
