/* :- include('mainKartu.pl'). */
/* :- include('startGame.pl'). */

/*
AKSI UTAMA : tampilan dari lihatCommand
-----------------saat top card wild4-----------------
"Tantang" : muncul saat kamu punya kartu counternya
"ambilKartu" : muncul setiap saat
-----------------normal------------------------------
"mainkanKartu(NomorUrut)"  : muncul setiap ada kartu yang serupa warna dan atau nomor
"uni" : apabila kartu hanya satu
"godsHand" (bonus) : 
"sembunyikanKartu(NomorUrut)(bonus)" :
"tmpilkanKartu" (bonus):

AKSI PENDUKUNG - selalu tersedia
"lihatCommand" : menampilkan command available
"lihatKartu* : menampilkan kartu milik pemain (dan tim pada mode turnamen)
"cekInfo" : menampilkan informasi permainan terknini
*/

AksiUtama(Pemain, AksiList) :-
    giliran(Pemain),
    kartuTop(_, wild4),
    findall(A, aksi_utama_tersedia(Pemain, A), AksiList).

aksi_utama_tersedia(_, ambilKartu).

aksi_utama_tersedia(Pemain, tantang) :-
    kartuTop(_, wild4).
    giliran(Pemain).

aksi_utama_tersedia(Pemain, mainkanKartu) :- 
    giliran(Pemain),
    kartu_diTangan(Pemain, IsiKartu),
    member(Kartu, IsiKartu), 
    isKartuValid(Kartu), !.

printNomor(_, []).
printNomor(N, [H|T]) :-
    write('~w, ~w~n', [N, H]),
    N1 is N + 1,
    printNomor(N1, T).

lihatCommand :- 
    (   game_started
    ->  giliran(Pemain),
        findall(A, aksi_utama_tersedia(Pemain, A), AksiUtama),
        write('Aksi utama yang tersedia:'), nl,
        printNomor(1, AksiUtama),
        nl,
        write('Aksi pendukung yang tersedia:', nl,
        printNomor(1, [lihatCommand, lihatKartu, cekInfo]) 
    )
    ;   write('Gamenya belum dimulai!'), nl,
        fail
    ).