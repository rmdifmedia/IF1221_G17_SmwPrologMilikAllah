/*startGame.pl*/

/* Deklarasi Fakta */

/* Deklarasi Rules */

/* Pemain */

/* Input jumlah pemain dengan batasan */
startGame:- repeat,
            write('Masukkan jumlah pemain: '),
            read(Number),
            hitungPemain(Number),
            (Number >= 2,
            Number =< 4),
            nl,
            pemainCounter(Number,0).

hitungPemain(Number):-  (Number < 2;
                        Number > 4),
                        write('Mohon masukkan angka antara 2-4.'),
                        nl.

/* Menghitung jumlah pemain untuk input data */
pemainCounter(Number, N):-  N < Number,
                            !,
                            N1 is N + 1,
                            namaPemain(N1),
                            pemainCounter(Number, N1).

pemainCounter(Number, Number):- !.

/* Input data pemain yang valid */
inputDataPemain(Nama):- open('dataNama.txt', append, N),
                        writeq(N,Nama),
                        write(N, '.'),
                        nl(N),
                        close(N).

/* Memastikan nama pemain unik (Tidak ada di list) */
cekSemuaNama(ListNama):-    open('dataNama.txt', read, Stream),
                            namaStream(Stream, ListNama),
                            close(Stream).

namaStream(Stream, []):- at_end_of_stream(Stream),
                         !.

namaStream(Stream, [Nama|R]):-  \+at_end_of_stream(Stream),
                                read_term(Stream, Nama, []),
                                Nama \== end_of_file,
                                !,
                                namaStream(Stream, R).

namaStream(_,[]).

cekListNama(Nama):- cekSemuaNama(ListNama),
                    member(Nama, ListNama).

/* Cek format nama agar pasti didahului kapital */
cekFormatNama(Nama):-   atom_codes(Nama, [Huruf|_]),
                        Huruf >= 65,
                        Huruf =< 90,
                        !,
                        (
                        cekListNama(Nama) ->
                        (write('Nama sudah digunakan. Masukkan nama lain : '),
                        read(NamaLain),
                        cekFormatNama(NamaLain));
                        inputDataPemain(Nama)
                        ).
                        

cekFormatNama(_):-  write('Input nama tidak valid! Masukkan nama dengan benar : '),
                    read(NamaLain),
                    cekFormatNama(NamaLain).

/* Prompt meminta nama pemain */
namaPemain(N):- write('Masukkan nama pemain '),
                write(N),
                write(' : '),
                read(Nama),
                (cekFormatNama(Nama) -> true;
                namaPemain(N)).

