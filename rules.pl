
opponent(white, black).
opponent(black, white).

enemy(Board,(X,Y),Player):-
	pos(Board,(X,Y),Piece),
	opponent(Player,N),
	player_piece(N,Piece), !.


% Define the predicate move/3, which takes three arguments:
%   - Pos: the current position of the piece (represented as a pair of integers)
%   - Dir: the direction in which the piece is moving (represented as a pair of integers)
%   - NewPos: the new position of the piece after making the move
move((X,Y), (DX,DY), (NewX,NewY)) :-
    NewX is X + DX,
    NewY is Y + DY.


% Define the predicate valid_move/3, which takes three arguments:
%   - Board: the current state of the board (represented as a list of lists of integers)
%   - Pos: the current position of the piece (represented as a pair of integers)
%   - NewPos: the new position of the piece after making the move
valid_move(Board, Pos, NewPos) :-
    move(Pos, (1,0), NewPos),     %getting pos
    inside_board(Board, NewPos),  %if pos is inside board
    empty(Board, NewPos).        %if pos is vacant

valid_move(Board, Pos, NewPos) :-
    move(Pos, (-1,-0), NewPos),
    inside_board(Board, NewPos),
    empty(Board, NewPos).

valid_move(Board, Pos, NewPos) :-
    move(Pos, (0,1), NewPos),
    inside_board(Board, NewPos),
    empty(Board, NewPos).

valid_move(Board, Pos, NewPos) :-
    move(Pos, (0,-1), NewPos),
    inside_board(Board, NewPos),
    empty(Board, NewPos).



% Define the predicate jump/4, which takes four arguments:
%   - Pos: the current position of the piece (represented as a pair of integers)
%   - Jump: the position of the piece being jumped (represented as a pair of integers)
%   - Dir: the direction in which the piece is moving (represented as a pair of integers)
%   - NewPos: the new position of the piece after making the jump
jump((X,Y), (JX,JY), (DX,DY), (NewX,NewY)) :-
    NewX is X + 2*DX,
    NewY is Y + 2*DY,
    JX is X + DX,
    JY is Y + DY.

% Define the predicate valid_jump/4, which takes four arguments:
%   - Board: the current state of the board (represented as a list of lists of integers)
%   - Pos: the current position of the piece (represented as a pair of integers)
%   - Jump: the position of the piece being jumped (represented as a pair of integers)
%   - NewPos: the new position of the piece after making the jump
valid_jump(Board, Pos, Jump, NewPos, Player) :-
    jump(Pos, Jump, (1,0), NewPos),
    inside_board(Board, Jump),         
    inside_board(Board, NewPos),
    enemy(Board, Jump, Player),
    empty(Board, NewPos).

valid_jump(Board, Pos, Jump, NewPos, Player) :-
    jump(Pos, Jump, (-1,0), NewPos),
    inside_board(Board, Jump),         
    inside_board(Board, NewPos),
    enemy(Board, Jump, Player),
    empty(Board, NewPos).

valid_jump(Board, Pos, Jump, NewPos, Player) :-
    jump(Pos, Jump, (0,1), NewPos),
    inside_board(Board, Jump),         
    inside_board(Board, NewPos),
    enemy(Board, Jump, Player),
    empty(Board, NewPos).

valid_jump(Board, Pos, Jump, NewPos, Player) :-
    jump(Pos, Jump, (0,-1), NewPos),
    inside_board(Board, Jump),         
    inside_board(Board, NewPos),
    enemy(Board, Jump, Player),
    empty(Board, NewPos).



valid_moves(Board, Pos, Moves, Player) :-
    findall(NewPos, valid_move(Board, Pos, NewPos), Moves).   %moves

valid_moves(Board, Pos, Moves, Player) :-
    findall(NewPos, (valid_jump(Board, Pos, _, NewPos, Player), \+ member(NewPos, Moves)), NewMoves),   %jumps
    append(Moves, NewMoves, Moves).





% Define the predicate chain_capture/4, which takes four arguments:
%   - Board: the current state of the board (represented as a list of lists of integers)
%   - Pos: the current position of the piece (represented as a pair of integers)
%   - Captures: the list of positions of the pieces captured in the chain capture
%   - NewPos: the final position of the piece after making the chain capture
chain_capture(Board, Pos, Captures, NewPos, Player) :-
    valid_jump(Board, Pos, Jump, NewPos, Player), % make a single jump
    chain_capture(Board, NewPos, [Jump|Captures], NewPos, Player). % continue the chain capture

chain_capture(_, Pos, Captures, Pos, Player) :- % base case: no more jumps are possible
    \+ valid_jump(_, Pos, _, _,  Player), % no more jumps are possible
    Captures \= []. % Captures must not be empty

valid_chain(Board, Pos, Moves, Player) :-
   findall(Chain, chain_capture(Board, Pos, Chain, _, Player), Captures).





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

