:- dynamic(kartu_diTangan/2).
:- dynamic(kartu/2).
:- dynamic(isTurnamen/0). %variabel sementara.

/* fungsi helper mengambil besaran poin tiap kartu*/
poinCard(kartu(W,N), N):-
    integer(N),
    warna(W),
    N>=0,
    N=<9.

poinCard(kartu( W,skip), 10):-
    warna(W).
poinCard(kartu(W,reverse), 10):-
    warna(W).
poinCard(kartu(W,draw_two), 10):-
    warna(W).

poinCard(kartu(hitam, wild), 20).
poinCard(kartu(hitam, wild_draw_fourdrawfour), 20).
poinCard(kartu(hitam, mimic), 20).

/* fungsi helper untuk menghitung skor*/
hitungSkor([], 0, 0) :- !.
hitungSkor([KartuPlayer|Tail], TotalPoin, SisaKartu):-
    poinCard(KartuPlayer, Nilai),
    hitungSkor(Tail, PoinTail, SisaKartuTail),
    TotalPoin is Nilai + PoinTail,
    SisaKartu is SisaKartuTail + 1.

/* fungsi helper untuk menghitung stats tiap player*/
statsAllPlayer([], _, []):- !.
statsAllPlayer([Nama|PemainTail], Giliran, [statsPlayer(Nama, Poin, Sisa, Giliran)|StatsPlayerTail]):-
    kartu_diTangan(Nama, ListCard),
    hitungSkor(ListCard, Poin, Sisa),
    NxGiliran is Giliran + 1,
    statsAllPlayer(PemainTail, NxGiliran, StatsPlayerTail).

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

printSkor([kartu(W,J)]):-
    poinCard(kartu(W,J), V),
    write(V),
    !.

printSkor([kartu(W,J)|T]) :-
    poinCard(kartu(W,J), V),
    write(V),
    write(' + '),
    printSkor(T).

printKartu([]):-
    write('Kartu Habis!').

printKartu([kartu(W,J)]) :-
    write(W), 
    write('-'),
    write(J),
    !.

printKartu([kartu(W,J)|T]) :-
    write(W), 
    write('-'),
    write(J),
    write(' + '),
    printKartu(T).

print_details([]).
print_details([Nama|SisaPemain]) :-
    kartu_diTangan(Nama, ListKartu),
    hitungSkor(ListKartu, TotalPoin, _),
    write(Nama), write(': '),
    printKartu(ListKartu), write(' = '),
    printSkor(ListKartu), write(' = '),
    write(TotalPoin), write(' poin'), nl,
    print_details(SisaPemain).

printRank([], _).
printRank([statsPlayer(Nama, Poin, _, _)|Tail], Rank) :-
    format('~w. ~w (~w poin)~n', [Rank, Nama, Poin]),
    NextRank is Rank + 1,
    printRank(Tail, NextRank).


/* dummy fakta*/
warna(merah).
warna(kuning).
warna(hijau).
warna(biru).

/*dummy*/
urutanPemain(['Raya', 'Sisi']).
kartu_diTangan('Raya', [kartu(merah,9), kartu(hitam, wild), kartu(hijau, 1), kartu(biru,skip)]).
kartu_diTangan('Sisi', []).


endGame:-
    ( isTurnamen
    ->  urutanPemain(ListUrutan),
        statsAllPlayer(ListUrutan, 1, HasilStats),
        insert_sort(HasilStats, SortedUrutan),
        kartu_diTangan(Pemenang, []),
        format('Permainan selesai! Selamat ~w memenangkan permainan', [Pemenang]), nl,
        write('Berikut perhitungan poin sisa kartu:'), nl,
        print_details(ListUrutan), nl,
        write('Berikut perhitungan poin untuk masing-masing tim :'), nl,
        

    ;
        urutanPemain(ListUrutan),
        statsAllPlayer(ListUrutan, 1, HasilStats),
        insert_sort(HasilStats, SortedUrutan),
        kartu_diTangan(Pemenang, []),
        format('Permainan selesai! Selamat ~w memenangkan permainan', [Pemenang]), nl,
        write('Berikut perhitungan poin sisa kartu:'), nl,
        print_details(ListUrutan), nl,
        write('Urutan Pemenang :'), nl,
        printRank(SortedUrutan, 1), nl.
    ).




