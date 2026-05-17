uni(Number):-
    turn(Pemain),
    kartu_diTangan(Pemain, ListKartu),
    lenght (ListKartu, LenKartu),
    (Number > 0, Number <= LenKartu),
    getCard(ListKartu, Number, Kartu),
    isKartuValid(Kartu),
    LenKartu =:= 2,
    format('~w menyerukan UNI!', [Pemain]), nl
    !, 
    nextTurn.

uni(Number):-
    turn(Pemain),
    kartu_diTangan(Pemain, ListKartu),
    lenght (ListKartu, LenKartu),
    (Number < 0 ; Number > LenKartu),
    format('~w, masukin nomor yang bener. emng iya kamu punya ~d kartu.', [Pemain, Number]),
    nl,
    write("masukin nomor yang bener: "),
    read(NewNumber),
    uni(NewNumber).

uni(Number):-
    getCard(ListKartu, Number, Kartu),
    \+ isKartuValid(Kartu),
    format('no no ya dek ~w, gabisa pake kartu ~w ~w. Perhatiin lagi ya dek efek kartu sebelumnya ;)', [Pemain, Warna, Jenis]),
    nl,
    write("masukin nomor kartu yang sesuai: "),
    read(NewNumber),
    uni(NewNumber).

uni(Number):-
    \+ LenKartu =:= 2,
    format('~w tidak memenuhi syarat perintah UNI!', [Pemain]), nl,
    repeat_N_ambilKartu(1, AmbilKartu),
    format('~w mendapat 1 kartu acak, kartu ~w ~w', [Pemain, Warna, Jenis]), nl,
    nextTurn.