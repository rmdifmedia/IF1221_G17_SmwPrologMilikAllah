/* action yang berhubungan dengan player 
 cekinfo, lihat command, lihatkartu, nexturn, reversturn, turn*/

:- dynamic(turn/1).
:- dynamic(playerCount/1). 
:- dynamic(listUrutan/1). %ListUrutan(List).
:- dynamic(arah/1).

/* UNI */
:- dynamic(listUni/1).
:- dynamic(kartu_diTangan/2).
:- dynamic(updateListUni/0).
/* UNI */

nextTurn :- 
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
        write('Berikut kartu yang anda miliki.'), nl,
        (   kartu_diTangan(Pemain, ListKartu)
        ->  printKartu(1, ListKartu)
        ; write('Kamu! tidak memiliki kartu!'), nl
        ).


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
    kartuTop(Warna, Jenis),
    format('Kartu discard top: ~w - ~w~n', [Warna, Jenis]), nl, 
    listUrutan(ListPemain),
    write('Urutan Pemain : '), 
    print_Urutan(ListPemain), nl, 
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
    getCard(ListKartu, Number, Kartu),
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
    getCard(ListKartu, Number1, Kartu),
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