/* action yang berhubungan dengan player 
 cekinfo, lihat command, lihatkartu, nexturn, reversturn, turn*/

:- dynamic(turn/1).
:- dynamic(playerCount/1). 
:- dynamic(listUrutan/1). %ListUrutan(List).
:- dynamic(arah/1).

/*SwapKartu*/
:- dynamic(sudahSwap/1).

/* UNI */
:- dynamic(listUni/1).
:- dynamic(kartu_diTangan/2).
:- dynamic(updateListUni/0).
/* UNI */

cekJumlahKartuPem(_,0,Checker):-
    Checker = 1,
    !.

cekJumlahKartuPemain([Player|Rest],LenList,Checker):-
    kartu_diTangan(Player,ListKartu),
    list_length(ListKartu,Len),
    (Len == 1 ->
    Lenn is LenList - 1,
    cekJumlahKartuPemain(Rest,Lenn,Checker);
    Checker = 0,
    !).

nextTurn :-
    listPlayer(List),
    list_length(List,LenList),
    cekJumlahKartuPemain(List,LenList,Checker),
    (Checker == 0 ->
    random(X),
    (X =< 0.2 ->
    godsHand;
    true);
    true),
    turn(Nama),
    arah(Arah),
    playerCount(Jumlah),
    listUrutan(ListUrutan),
    find_index(ListUrutan, Index, Nama),
    (Arah = kanan
    -> Next is (Index+1) mod Jumlah
    ; Next is (Index-1) mod Jumlah),
    get_index(ListUrutan, Next, NamaNext),
    retractall(turn(_)),
    assertz(turn(NamaNext)).

reverseUrutan :-
    (
        arah(kanan)
        -> retractall(arah(kanan)),
            assertz(arah(kiri))
        ; retractall(arah(kiri)),
        assertz(arah(kanan)) 
    ).

aksiUtama(Pemain, AksUtamaList) :-
    turn(Pemain),
    kartuTop(_, drawfour),
    findall(A, aksi_utama_tersedia(Pemain, A), AksiUtamaList).

aksi_utama_tersedia(_, ambilKartu).

aksi_utama_tersedia(Pemain, tantang) :-
    kartuTop(_, drawfour),
    turn(Pemain).

aksi_utama_tersedia(Pemain, uni) :-
    turn(Pemain),
    kartu_diTangan(Pemain, ListKartu),
    member(Kartu, ListKartu), 
    isKartuValid(Kartu),
    length(ListKartu, Length),
    Length =:= 2.

/*aksi_utama_tersedia(Pemain, tangkap) :-
    turn(Pemain). */

aksi_utama_tersedia(Pemain, mainkanKartu) :- 
    turn(Pemain),
    kartu_diTangan(Pemain, ListKartu),
    member(Kartu, ListKartu), 
    isKartuValid(Kartu), !.

printNomor(_, []):-
    !.
printNomor(N, [H|T]) :-
    format('~w. ~w~n', [N, H]),
    N1 is N + 1,
    printNomor(N1, T).

lihatCommand :- 
    nl,
    turn(Pemain),
        findall(A, aksi_utama_tersedia(Pemain, A), AksiUtama),
        write('Aksi utama yang tersedia:'), nl,
        printNomor(1, AksiUtama),
        nl,
        write('Aksi pendukung yang tersedia:'), nl,
        printNomor(1, [lihatCommand, lihatKartu, cekInfo]).


printKartu(_, []):-
    !.
printKartu(N, [Kartu | T] ) :-
    format('~w. ~w~n', [N, Kartu]),
    N1 is N + 1,
    printKartu(N1, T).

lihatKartu :-
  turn(Pemain), 
        nl,
        write('Berikut kartu yang anda miliki.'), nl,
        (   kartu_diTangan(Pemain, ListKartu)
        ->  printKartu(1, ListKartu)
        ; write('Kamu tidak memiliki kartu!'), nl
        ),
        modeGame(Mode),
        (Mode == 2 ->
        nl,
        playerTeamNumber(Pemain,X),
        retract(playerTeamNumber(Pemain,X)),
        playerTeamNumber(Teammate,X),
        assertz(playerTeamNumber(Pemain,X)),
        format('Berikut kartu yang teman satu tim anda miliki (~w).~n',[Teammate]),
        kartu_diTangan(Teammate, ListKartuTeman),
        printKartu(1, ListKartuTeman);
        true),
        !.



:- dynamic(kartuTop/2). /* ambil kartu teratas */
:- dynamic(kartu_diTangan/2).

info_pemain(_,[]).
info_pemain(FullList, [Nama|Tail]) :-
    find_index(FullList, Index, Nama),
    kartu_diTangan(Nama, ListKartu),
    list_length(ListKartu, Jum),
    format('Nama pemain ~d: ~w~nJumlah kartu: ~d~n', [Index+1,Nama,Jum]),
    info_pemain(FullList, Tail).

print_Urutan([]).
print_Urutan([Nama]):-
    write(Nama),
    !.

print_Urutan([Nama|T]):-
    write(Nama),
    write(' - '),
    print_Urutan(T).

cekInfo :-
    nl,
    kartuTop(Warna, Jenis),
    format('Kartu discard top: ~w-~w~n', [Warna, Jenis]),
    nl,
    modeGame(Mode),
    (Mode == 2 ->
    playerTeam(X),
    retract(playerTeam(X)),
    playerTeam(Y),
    asserta(playerTeam(X)),
    get_index(X,0,FirstPlayer1),
    get_index(X,1,SecondPlayer1),
    get_index(Y,0,FirstPlayer2),
    get_index(Y,1,SecondPlayer2),
    format('Tim 1 : ~w, ~w.~n',[FirstPlayer1,SecondPlayer1]),
    format('Tim 2 : ~w, ~w.~n',[FirstPlayer2,SecondPlayer2]),
    nl;
    true),
    listUrutan(ListPemain),
    write('Urutan Pemain : '), 
    print_Urutan(ListPemain),
    nl, 
    nl,
    info_pemain(ListPemain, ListPemain),
    !.

/* UNI */
/* List UNI */
listUni([]).

addListUni(Nama):-
    retract(listUni(ListLama)),
    assertz(listUni([Nama|ListLama])).

/* Update List Uni -- tiap turn, karena Pemain bisa jadi kena wild four shg kartu > 1 */
filter_cardIsOne([], []).

filter_cardIsOne([H|T], [H|TResult]):-
    kartu_diTangan(H, ListKartu),
    list_length(ListKartu, LenKartu),
    LenKartu =:= 1,
    filter_cardIsOne(T, TResult).

filter_cardIsOne([H|T], TResult):- 
    kartu_diTangan(H, ListKartu),
    list_length(ListKartu, LenKartu),
    \+LenKartu =:= 1,
    filter_cardIsOne(T, TResult).

updateListUni:-
    listUni(ListLama),
    filter_cardIsOne(ListLama, ListBaru),
    retract(listUni(ListLama)),
    assertz(listUni(ListBaru)).

/* Helper UNI */
uni_Info(Pemain, ListKartu):-
    turn(Pemain),
    kartu_diTangan(Pemain, ListKartu).

/* UNI */
uni(Number):-
    uni_Info(Pemain, ListKartu),
    list_length(ListKartu, LenKartu),
    (Number < 1 ; Number > LenKartu),
    !,
    write('Nomor kartu tidak sesuai rentang jumlah kartu. Masukkan nomor kartu yang sesuai: '),
    read(NewNumber),
    uni(NewNumber).

uni(Number):-
    uni_Info(Pemain, ListKartu),
    list_length(ListKartu, LenKartu),
    \+LenKartu =:= 2,
    !,
    write(Pemain), write(' tidak memenuhi syarat perintah UNI!'), nl,
    repeat_N_ambilKartu(1, AmbilKartu),
    write(Pemain), write(' mendapatkan 1 kartu acak.'), nl,
    nextTurn.

/* NOTES: repeat_N_ambilKartu gagal. Pending benerin fact.pl ke yang work di gnu prolog */
/* SOLUSI: karena dummy, sementara fact pakai dikasih inilization initdeck. Selain buat ngecek uni sendiri, inilization di fact, hapus. */

uni(Number):-
    uni_Info(Pemain, ListKartu),
    get_index(ListKartu, Number, Kartu),
    \+ isKartuValid(Kartu),
    !,
    write('Kartu tidak sesuai dengan efek sebelumnya. Masukkan nomor kartu dengan efek yang sesuai: '),
    read(NewNumber),
    uni(NewNumber).


uni(Number):-
    uni_Info(Pemain, ListKartu),
    list_length(ListKartu, LenKartu),
    (Number > 0, (Number < LenKartu ; Number == LenKartu)),
    Number1 is Number - 1,
    get_index(ListKartu, Number1, Kartu),
    isKartuValid(Kartu),
    LenKartu =:= 2,
    !,
    mainkanKartu(Number),
    write(Pemain), write(' menyerukan UNI!'), nl,
    addListUni(Pemain).

/* NOTES: Walaupun uni berhasil, ga akan substract kartu_diTangan UNTUK SAAT INI, karena rules mainkanKartu dimatikan*/
/* UNI */

/* TANGKAP */
/*bikin repeat_N_ambilKartu versi player bukan selalu di-turn. Penalti ver*/
ambilKartuPenalti(Penal):- 
    fullDeck(Deck),
    randomCard(Deck, ChosenCard),
    retract(kartu_diTangan(Penal, ListLama)),
    assertz(kartu_diTangan(Penal, [ChosenCard|ListLama])).

penalti_N_Kartu(0, _):- 
    !.

penalti_N_Kartu(N, Penal):-
    N > 0,
    ambilKartuPenalti(Penal), 
    N1 is N - 1, 
    penalti_N_Kartu(N1, Penal).

/* Tangkap */    
tangkap(NamaPemain):-
    turn(Pemain),
    Pemain == NamaPemain,
    write('Tidak boleh menangkap diri sendiri. Masukkan perintah yang sesuai.'),
    nl,
    !.

tangkap(NamaPemain):-
    listPlayer(ListNama),
    list_length(ListNama, LenPemain),
    \+findNama(NamaPemain, ListNama, LenPemain),
    !,
    write('Tidak ada nama pemain '), write(NamaPemain), write(' untuk ditangkap.'), 
    nl,
    !.

tangkap(NamaPemain):-
    kartu_diTangan(NamaPemain, ListKartu), 
    list_length(ListKartu, LenKartu),
    listUni(ListUni),
    (LenKartu =:= 1, \+ member(NamaPemain, ListUni)),
    format('~w tertangkap tidak menyerukan UNI!', [NamaPemain]), nl,
    penalti_N_Kartu(2, NamaPemain),
    format('~w mendapatkan penalti 2 kartu acak.', [NamaPemain]), nl,
    turn(Pemain),
    format('turn ~w berikutnya satu kali menjadi turn ~w.', [NamaPemain, Pemain]), 
    nl,
    !.

tangkap(NamaPemain):-
    kartu_diTangan(NamaPemain, ListKartu), 
    list_length(ListKartu, LenKartu),
    listUni(ListUni),
    (LenKartu =:= 1, member(NamaPemain, ListUni)),
    format('~w sudah menyerukan UNI!', [NamaPemain]), nl,
    turn(Pemain),
    format('~w salah menuduh ~w.', [Pemain, NamaPemain]), nl,
    repeat_N_ambilKartu(1, AmbilKartu),
    format('~w mendapatkan penalti 1 kartu acak.', [Pemain]), 
    nl,
    !.

tangkap(NamaPemain):-
    kartu_diTangan(NamaPemain, ListKartu), 
    list_length(ListKartu, LenKartu),
    \+ LenKartu =:= 1,
    format('~w belum waktunya menyerukan UNI!', [NamaPemain]), nl,
    turn(Pemain),
    format('~w salah menuduh ~w.', [Pemain, NamaPemain]), nl,
    repeat_N_ambilKartu(1, AmbilKartu),
    format('~w mendapatkan penalti 1 kartu acak.', [Pemain]), 
    nl,
    !.
/* TANGKAP */

godTaketh(Player,ListKartu,ChosenKartu):-
    list_length(ListKartu,Len),
    random(0,Len,Idx),
    get_index(ListKartu,Idx,ChosenKartu),
    delete_element(ListKartu,Idx,NewListKartu),
    retract(kartu_diTangan(Player,_)),
    assertz(kartu_diTangan(Player,NewListKartu)).

godGiveth(Player,ListKartu,GivenKartu):-
    append_element(ListKartu,GivenKartu,NewListKartu),
    retract(kartu_diTangan(Player,_)),
    assertz(kartu_diTangan(Player,NewListKartu)).

godsHand:-
    nl,
    write('Tuhan telah berkehendak.'),
    nl,
    listPlayer(List),
    randomMember(List,Player_SRC,Idx),
    delete_element(List,Idx,NewList),
    randomMember(NewList,Player_DEST,_),
    kartu_diTangan(Player_SRC,ListKartu_SRC),
    kartu_diTangan(Player_DEST,ListKartu_DEST),
    godTaketh(Player_SRC,ListKartu_SRC,ChosenKartu),
    godGiveth(Player_DEST,ListKartu_DEST,ChosenKartu),
    format('Kartu ~w milik ~w berpindah ke tangan ~w!~n~n',[ChosenKartu,Player_SRC,Player_DEST]),
    format('Giliran ~w.~n',[Player_DEST]),
    retractall(turn(_)),
    assertz(turn(Player_DEST)),
    !.

/*Swap Kartu*/
getTeammate(Pemain, Teammate) :-
    playerTeamNumber(Pemain, X),
    playerTeamNumber(Teammate, X),
    Teammate \= Pemain.

aksi_utama_tersedia(Pemain, swapKartu) :-
    turn(Pemain),
    modeGame(2),
    \+ sudahSwap(Pemain),
    getTeammate(Pemain, Teammate),
    kartu_diTangan(Pemain, ListKartuPemain),
    kartu_diTangan(Teammate, ListKartuTeman),
    list_length(ListKartuPemain, LenPemain),
    list_length(ListKartuTeman, LenTeman),
    LenPemain > 1,
    LenTeman > 1.

resetSwapFlag :-
    turn(Pemain),
    retractall(sudahSwap(Pemain)).

swapKartu(_, _) :-
    \+ modeGame(2),
    !,
    write('swapKartu hanya tersedia pada mode turnamen.'), nl.

swapKartu(_, _) :-
    turn(Pemain),
    sudahSwap(Pemain),
    !,
    write('Anda sudah menggunakan swapKartu pada giliran ini.'), nl.

swapKartu(_, _) :-
    turn(Pemain),
    getTeammate(Pemain, Teammate),
    kartu_diTangan(Pemain, ListKartuPemain),
    kartu_diTangan(Teammate, ListKartuTeman),
    list_length(ListKartuPemain, LenPemain),
    list_length(ListKartuTeman, LenTeman),
    (LenPemain =:= 1 ; LenTeman =:= 1),
    !,
    write('swapKartu tidak dapat dilakukan jika salah satu pemain hanya memiliki satu kartu.'), nl.

swapKartu(NomorPemain, _) :-
    turn(Pemain),
    kartu_diTangan(Pemain, ListKartuPemain),
    list_length(ListKartuPemain, LenPemain),
    (NomorPemain < 1 ; NomorPemain > LenPemain),
    !,
    format('Nomor urut kartu Anda (~w) tidak valid. Masukkan antara 1 hingga ~w: ', 
           [NomorPemain, LenPemain]),
    read(NomorBaru),
    swapKartu(NomorBaru, _). /* akan re-read NomorTeman di luar, tapi lihat catatan */

swapKartu(NomorPemain, NomorTeman) :-
    turn(Pemain),
    getTeammate(Pemain, Teammate),
    kartu_diTangan(Teammate, ListKartuTeman),
    list_length(ListKartuTeman, LenTeman),
    (NomorTeman < 1 ; NomorTeman > LenTeman),
    !,
    format('Nomor urut kartu teman (~w) tidak valid. Masukkan antara 1 hingga ~w: ',
           [NomorTeman, LenTeman]),
    read(NomorTemanBaru),
    swapKartu(NomorPemain, NomorTemanBaru).

swapKartu(NomorPemain, NomorTeman) :-
    turn(Pemain),
    getTeammate(Pemain, Teammate),
    kartu_diTangan(Pemain, ListKartuPemain),
    kartu_diTangan(Teammate, ListKartuTeman),
    list_length(ListKartuPemain, LenPemain),
    list_length(ListKartuTeman, LenTeman),
    NomorPemain >= 1, NomorPemain =< LenPemain,
    NomorTeman  >= 1, NomorTeman  =< LenTeman,

    IdxPemain is NomorPemain - 1,
    IdxTeman  is NomorTeman  - 1,
    get_index(ListKartuPemain, IdxPemain, KartuPemain),
    get_index(ListKartuTeman,  IdxTeman,  KartuTeman),

    delete_element(ListKartuPemain, IdxPemain, ListKartuPemainSementara),
    delete_element(ListKartuTeman,  IdxTeman,  ListKartuTemanSementara),

    append_element(ListKartuPemainSementara, KartuTeman,  ListKartuPemainBaru),
    append_element(ListKartuTemanSementara,  KartuPemain, ListKartuTemanBaru),

    retract(kartu_diTangan(Pemain,   _)),
    assertz(kartu_diTangan(Pemain,   ListKartuPemainBaru)),
    retract(kartu_diTangan(Teammate, _)),
    assertz(kartu_diTangan(Teammate, ListKartuTemanBaru)),

    assertz(sudahSwap(Pemain)),
    format('~w menukar kartu ~w dengan kartu ~w milik ~w.~n',
           [Pemain, KartuPemain, KartuTeman, Teammate]),
    !.