:- include('player.pl').
:- include('fact.pl').

/* KONDISI SUCCESS UNTUK TEST RUN INDIVIDU UNI.PL:
- fact.pl diberi inilization(initdeck).
- fact.pl include helper.pl saja
- include uni.pl seperti tertera */

:- dynamic(listUni/1).
:- dynamic(kartu_diTangan/2).
:- dynamic(updateListUni/0).

turn(sawit).
kartu_diTangan(sawit, [kartu(merah, 0), kartu(kuning, 1)]).

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

/* # Sementara dimatiin sampai efek kartu berhasil diimplikasi #
uni(Number):-
    uni_Info(Pemain, ListKartu),
    getCard(ListKartu, Number, Kartu),
    \+ isKartuValid(Kartu),
    !,
    write('Kartu tidak sesuai dengan efek sebelumnya. Masukkan nomor kartu dengan efek yang sesuai: '),
    read(NewNumber),
    uni(NewNumber).
*/

uni(Number):-
    uni_Info(Pemain, ListKartu),
    list_length(ListKartu, LenKartu),
    (Number > 0, (Number < LenKartu ; Number == LenKartu)),
    /* # Sementara dimatiin sampai efek kartu berhasil diimplikasi # */
    /* Number1 is Number - 1,
    getCard(ListKartu, Number1, Kartu),
    isKartuValid(Kartu), */
    LenKartu =:= 2,
    !,
    /* mainkanKartu(Number), # Sementara dimatiin sampai main dari awal #*/  
    write(Pemain), write(' menyerukan UNI!'), nl,
    addListUni(Pemain).

/* NOTES: Walaupun uni berhasil, ga akan substract kartu_diTangan UNTUK SAAT INI, karena rules mainkanKartu dimatikan*/