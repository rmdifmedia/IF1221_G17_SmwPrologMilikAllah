:- include('player.pl').
:- include('fact.pl').
:- include('startGame.pl').
<<<<<<< HEAD
=======
:- initialization(main, main).
>>>>>>> 7afd7f43b98ae8bc5c9e3bf24d131656d689b600

main :-
    format('>> New Game ~n >> Load Game ~n Ketik Opsi: ', []),
    read(Opsi),
    (Opsi = 'New Game'
    -> startGame
    ; fail ). %belum ada implementasi load game

    /*  >> New Game
        >> Load Game
        Ketik Opsi:     */
