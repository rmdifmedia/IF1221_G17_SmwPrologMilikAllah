:- include ('src/player.pl').
:- include ('src/fact.pl').
:- include ('src/startGame.pl').
:- initialization(main).

main :-
    write('>> New Game ~n >> Load Game ~n Ketik Opsi: '),
    read(Opsi),
    (Opsi = 'New Game'
    -> startGame
    ; fail ). %belum ada implementasi load game

    /*  >> New Game
        >> Load Game
        Ketik Opsi:     */
