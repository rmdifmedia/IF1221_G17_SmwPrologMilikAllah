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