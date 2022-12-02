
opponent(white, black).
opponent(black, white).


%player_piece :- funçao pra ver se uma peça numa certa posiçao é de q player_piece

is_enemy(Board,X,Y,Player):-
	pos(Board,X,Y,Piece),
	opponent(Player,N),
	player_piece(N,Piece), !.


possible_move(Board, Color, End) :-
  select(piece(X, Y, Color), Board, Motion),
  (
    N_X is X + 1, N_Y is Y;
    N_X is X - 1, N_Y is Y2;
    N_X is X, N_Y is Y - 1;
    N_X is X, N_Y is Y + 1
  ),
  (
    vacant(Board, N_X, N_Y),
    place(piece(Color, knight, N_X, N_Y), Motion, End)
    ;

    capture(piece(N_X, N_Y, Color), Motion, End)
  ).








move(Board,Xi,Yi,Xf,Yf,New_Board):-
	pos(Board,Xi,Yi,Piece),
	remove_from_board(Board,Xi,Yi,Temp_Board),
	promote(Yf,Piece,Piece2),
	replace(Temp_Board,Xf,Yf,Piece2,New_Board).


% capture(+Board,+Piece, +Dir,+Xi,+Yi,-cena pra returnar novo board)

capture(Board, Piece, Left, X,Y, ):-
	X > 2,
	X1 is X - 1,
	opponent(Board,X1,Y,white),
	X2 is X - 2,
	vacant(Board,X2,Y),
	move(Board,X,Y,X2,Y,Temp_Board),
	remove_from_board(Temp_Board,X1,Y,New_Board).


canMove(X, Y, Up):- 
    Y > 1,
    Next is Y - 1,
    casa(X, Next, Vazia).

canMove(X, Y, Up):- 
    Y > 1, 
    Next is Y - 1,
    casa(X, Next, _).


canMove(X, Y, Down):-
    Y < 5, 
    Next is Y + 1,
    casa(X, Next, Vazia).

canMove(X, Y, Left):- 
    X > 1, 
    Next is X - 1,
    casa(Next, Y, Vazia).

canMove(X, Y, Right):- 
    X < 6, 
    Next is X + 1,
    casa(Next, Y, Vazia).




capture(piece(X, Y, Color), Motion, End) :-
  opponent(Color, Other),
  select(piece(Other, _, X, Y),     Motion, Motion2),
  End = [piece(Color, Which, X, Y) | Motion2].

