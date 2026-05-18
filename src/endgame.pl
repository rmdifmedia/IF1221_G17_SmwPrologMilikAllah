:- include('src/startGame.pl').
:- dynamic(kartu_diTangan/2).

/* fungsi helper mengambil besaran poin tiap kartu*/
poinCard(kartu(_,N), N):-
    N >= 0,
    N <= 9.

poinCard(kartu(_,skip), 10).
poinCard(kartu(_,jreverse), 10).
poinCard(kartu(_,drawtwo), 10).

poinCard(kartu(hitam, wild), 20).
poinCard(kartu(hitam, drawfour), 20).

/* fungsi helper untuk menghitung skor*/
hitungSkor([], 0, 0) :- !.
hitungSkor([KartuPlayer|Tail], TotalPoin, SisaKartu):-
    poinCard(KartuPlayer, Nilai),
    hitungSkor(Tail, PoinTail, SisaKartuTail),
    TotalPoin is Nilai + PoinTail,
    SisaKartu is SisaKartuTail + 1.

/* fungsi helper untuk menghitung stats tiap player*/
statsAllPlayer([], _, []):- !.
statsAllPlayer([Nama|PemainTail], Giliran, [statsPlayer(Nama, Poin, Sisa, Giliran)|statsPlayerTail]):-
    kartu_diTangan(Nama, ListCard),
    hitungSkor(ListCard, Poin, Sisa),
    NxGiliran is Giliran + 1,
    statsAllPlayer(PemainTail, NxGiliran, statsPlayerTail).

/* fungsi helper mengurutkan pemenang*/
higherRank(statsPlayer(_,P1,_,_), statsPlayer(_,P2,_,_)) :-
    P1 < P2,
    !.
higherRank(statsPlayer(_,P,C1,_), statsPlayer(_,P,C2,_)) :-
    C1 < C2,
    !.
higherRank(statsPlayer(_,P,C,G1), statsPlayer(_,P,C,G2)) :-
    G1 < G2,
    !.

/* insertion sort, sumber : rosetta.code (modified) */

insert_sort(UrutanAsli,SortedUrutan) :-
  insert_sort_intern(UrutanAsli,[], SortedUrutan).
 
insert_sort_intern([],Temp,Temp).
insert_sort_intern([H|T],Temp, SortedUrutan) :-
  insert(Temp,H,Temp2),
  insert_sort_intern(T,Temp2,SortedUrutan).
 
insert([],X,[X]).
insert([H|T],X,[X,H|T]) :-
  higherRank(X,H),
  !.
insert([H|T],X,[H|T2]) :-
  insert(T,X,T2).


/* fungsi helper print tiap skor dan kartu peserta */
printSkor([]) :- 
    write('0').

printSkor([K]):-
    poinCard(K, V),
    write(V),
    !.

printSkor([K|T]) :-
    poinCard(K, V),
    write(V),
    printSkor(T).

printKartu([]):-
    write('Kartu Habis!').

printKartu([K(W,J)]) :-
    write(W), 
    write('-'),
    write(J),
    !.

printKartu([K(W,J)|T]) :-
    write(W), 
    write('-'),
    write(J),
    printKartu(T).

print_details([]).
print_details([Nama|SisaPemain]) :-
    kartu_ditangan(Nama, ListKartu),
    hitungSkor(ListKartu, TotalPoin, _),
    write(Nama), write(': '),
    print_kartu(ListKartu), write(' = '),
    print_nilai(ListKartu), write(' = '),
    write(TotalPoin), write(' poin'), nl,
    print_details(SisaPemain).
   
endgame:-

