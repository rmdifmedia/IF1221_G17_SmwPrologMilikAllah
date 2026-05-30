:- include('player.pl').
:- include('fact.pl').
:- include('startGame.pl').
:- include('helper.pl').
:- include('saveGame.pl').
:- initialization(main).

main :-                                                                                                                                                                                                                       
    format('>> New Game ~n >> Load Game ~n Ketik Opsi: ', []),
    read(Opsi),
    (Opsi = 'New Game' -> startGame
    ; Opsi = 'Load Game' -> loadGame
    ; fail 
    ). 

    /*  >> New Game
        >> Load Game
        Ketik Opsi:     */
