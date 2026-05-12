:- include('startGame.pl').

printKartu(_, []).
printKartu(N, [kartu(Warna, Jenis)] | [T] ) :-
    format('~w. ~w-~w~n', [N, Warna, Jenis]),
    N1 is N + 1,
    printKartu(N1, T).

lihatKartu :-
    (   game_started
    ->  giliran(Pemain), 
        write('Berikut kartu yang anda miliki.'), nl,
        (   kartu_diTangan(Pemain, IsiKartu)
        ->  printKartu(1, IsiKartu)
        ;
            write('Kamu! tidak memiliki kartu!'), nl,
        )
    ;   write('Gamenya belum dimulai!'), nl,
        fail
    ).