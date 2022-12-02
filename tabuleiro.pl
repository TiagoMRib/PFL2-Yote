


% pos(+Board,+X,+Y,-Element).
% Returns the value of the position (X,Y).


% STARTER BOARD

casa(1, 1, Vazia).
casa(1, 2, Vazia).
casa(1, 3, Vazia).
casa(1, 4, Vazia).
casa(1, 5, Vazia).


casa(2, 1, Vazia).
casa(2, 2, Vazia).
casa(2, 3, Vazia).
casa(2, 4, Vazia).
casa(2, 5, Vazia).


casa(3, 1, Vazia).
casa(3, 2, Vazia).
casa(3, 3, Vazia).
casa(3, 4, Vazia).
casa(3, 5, Vazia).


casa(4, 1, Vazia).
casa(4, 2, Vazia).
casa(4, 3, Vazia).
casa(4, 4, Vazia).
casa(4, 5, Vazia).


casa(5, 1, Vazia).
casa(5, 2, Vazia).
casa(5, 3, Vazia).
casa(5, 4, Vazia).
casa(5, 5, Vazia).


casa(6, 1, Vazia).
casa(6, 2, Vazia).
casa(6, 3, Vazia).
casa(6, 4, Vazia).
casa(6, 5, Vazia).



% Manipulate Board

remove_from_board(Board,X,Y,New_Board):-
	empty_board(Empty_Board), %
	pos(Empty_Board,X,Y,Place),
	replace(Board,X,Y,Place,New_Board).



casaToString(X, Y, " "):- casa(X, Y, Vazia).
casaToString(X, Y, "+"):- casa(X,Y, Branca).
casaToString(X, Y, "*"):- casa(X,Y, Preta).


    




showBoard(6, []).
showboard(0, []):-
    write('  |1|2|3|4|5|6|').

showBoard(NumLine, [Line|MoreLines]):-
    format('~d |~p|~p|~p|~p|~p|~p|', [NumLine, Line]),
    Next is NumLine + 1,
    showBoard(Next, MoreLines).



% check BOARD


vacant(Board, X, Y) :-
  between(1, 6, X),
  between(1, 5, Y),
  \+(member(piece(X, Y, _), Board)).