/* action yang berhubungan dengan player */
// cekinfo, lihat command, lihatkartu, nexturn, reversturn, giliran //

:- dynamic turn/1.
:- dynamic jumlah/1.

/*jumlah(pemainCounter(Number,N)).*/

nextTurn :- 
    turn(Nama),
    arah(Arah),
    jumlah(Jumlah),
    (Arah = maju
    -> Next is (Nama+1) mod Jumlah
    ; Next is (Nama-1) mod Jumlah),
    retract(turn(_)),
    assert(turn(Next)).

reverseUrutan :-
    arah(mundur),
    nextTurn.