/*bikin repeat_N_ambilKartu versi player bukan selalu di-turn. Penalti ver*/
ambilKartuPenalti(Penal):- 
    deck(FullDeck),
    randomCard(FullDeck, ChosenCard),
    retract(kartu_diTangan(Penal, ListLama)),
    assertz(kartu_diTangan(Penal, [ChosenCard|ListLama])).

penalti_N_Kartu(0, _):- !
penalti_N_Kartu(N, Penal):-
    N > 0,
    ambilKartuPenalti(Penal), 
    N1 is N - 1, 
    penalti_N_Kartu(N1, Penal).

    
tangkap(NamaPemain):-
    kartu_diTangan(NamaPemain, ListKartu), 
    length(ListKartu, LenKartu),
    listUni(ListUni),
    (LenKartu =:= 1, \+ member(NamaPemain, ListUni)),
    format('~w tertangkap tidak menyerukan UNI!', [NamaPemain]), nl,
    penalti_N_Kartu(2, NamaPemain),
    format('~w mendapatkan penalti 2 kartu acak', [NamaPemain]), nl,
    turn(Pemain),
    format('turn ~w berikutnya satu kali menjadi turn ~w', [NamaPemain, Pemain]), nl,
    !.

tangkap(NamaPemain):-
    turn(Pemain),
    kartu_diTangan(NamaPemain, ListKartu), 
    length(ListKartu, LenKartu),
    listUni(ListUni),
    (LenKartu =:= 1, member(NamaPemain, ListUni)),
    format('~w sudah menyerukan UNI!', [NamaPemain]), nl,
    format('~w salah menuduh ~w', [Pemain, NamaPemain]), nl,
    repeat_N_ambilKartu(1, AmbilKartu),
    format('~w mendapatkan penalti 1 kartu acak', [Pemain]), nl,
    !.

tangkap(NamaPemain):-
    turn(Pemain),
    kartu_diTangan(NamaPemain, ListKartu), 
    length(ListKartu, LenKartu),
    \+ LenKartu =:= 1,
    format('~w belum waktunya menyerukan UNI!', [NamaPemain]), nl,
    format('~w salah menuduh ~w', [Pemain, NamaPemain]), nl,
    repeat_N_ambilKartu(1, AmbilKartu),
    format('~w mendapatkan penalti 1 kartu acak', [Pemain]), nl,
    !.