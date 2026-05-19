:- include('player.pl').
:- include('fact.pl').
:- include('startGame.pl').
:- initialization(main, main).

main :-
    format('>> New Game ~n >> Load Game ~n Ketik Opsi: ', []),
    read(Opsi),
    (Opsi = 'New Game'
    -> startGame
    ; fail ). %belum ada implementasi load game

    /*  >> New Game
        >> Load Game
        Ketik Opsi:     */
