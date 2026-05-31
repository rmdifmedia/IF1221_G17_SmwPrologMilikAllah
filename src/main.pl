:- include('player.pl').
:- include('fact.pl').
:- include('startGame.pl').
:- include('helper.pl').
:- include('saveGame.pl').
:- initialization(startGame).

startGame :-                                           
    write('================================'), nl,
    write('      Selamat Datang di UNI     '), nl,
    write('================================'), nl,                                                                                                                                                                            
    format('>> New Game ~n>> Load Game ~n>> Ketik Opsi: ', []),
    read(Opsi),
    (Opsi = 'New Game' -> newGame
    ; Opsi = 'Load Game' -> loadGame
    ;  write('Opsi tidak valid. Silahkan pilih New Game atau Load Game.'), nl, startGame
    ). 

    /*  >> New Game
        >> Load Game
        Ketik Opsi:     */
