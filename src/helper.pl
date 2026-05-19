/* implementasi fungsi helper */

/* Menambahkan Elemen ke List */

append_element([], Element, [Element]).

append_element([Head|Tail], Element, [Head|NewTail]):-
	append_element(Tail, Element, NewTail).

/*Mencari Panjang List*/

list_length([],0).

list_length([_|Tail], Len):-
	list_length(Tail, TailLen),
	Len is TailLen + 1.

/*Mendapatkan Akses Elemen berdasarkan Indeks*/

get_index([Element|_], 0, Element).

get_index([_|Tail], Index, Element):-
	Index > 0,
	NewIndex is Index - 1,
	get_index(Tail,NewIndex,Element).

/*Menghapus Elemen*/

delete_element([_|Tail], 0, Tail).
delete_element([Head|Tail],Index,[Head|UpdatedTail]):-
	Index > 0,
	NewIndex is Index - 1,
	delete_element(Tail,NewIndex,UpdatedTail).


/* mencari idenks dari suatu element*/
find_index([Element|_], 0, Element).
find_index([Head|Tail], Index, Element) :-
    Head \= Element,
    find_index(Tail, Index1, Element),
    Index is Index1 + 1.
