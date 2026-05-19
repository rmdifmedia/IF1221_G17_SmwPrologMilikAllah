:- include('fact.pl').
:- include('uni.pl').
:- include('startGame.pl').

:- dynamic(kartu_diTangan/2).

listPlayer(['Usagi', 'Hachiware', 'Roga']).
kartu_diTangan('Usagi', [kartu(merah, 0)]).
kartu_diTangan('Hachiware', [merah-1, kuning-2, merah-9]).
kartu_diTangan('Roga', [merah-8]).
listUni(['Usagi']).
turn('Roga').

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

/* Helper Tangkap */

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