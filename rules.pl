
opponent(white, black).
opponent(black, white).

is_mine(white, w).
is_mine(black, b).



enemy(Board,(X,Y),Player):-
	pos(Board,(X,Y),Piece),
	opponent(Player,N),
	player_piece(N,Piece), !.


delete_pos(Board, (X,Y), NewBoard):-
    change_board_element(Board, X, Y, 0, NewBoard).

set_pos(Board, (X,Y), Simbol, NewBoard):-
    change_board_element(Board, X, Y, Simbol, NewBoard),




place(Board, Pos, NewBoard):-
    empty(Board, Pos)

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


% Define the predicate valid_input/6, which takes four arguments:
%   - Board: the current state of the board (represented as a list of lists of integers)
%   - Pos: the current position of the piece (represented as a pair of integers)
%   - Dir: the direction intended for the piece (represented as a pair of integers)
%   - NewPos: the new position of the piece after making the move
%   - Type of movement: the type of movement the piece took

valid_input(Board, Player, (X, Y), (Dx,Dy), NewPos, Move) :-
    NewX is X + DX,
    NewY is Y + DY,
    valid_move(Board, (X, Y), (NewX, NewY)).

valid_input(Board, Player, (X, Y), (Dx,Dy), NewPos, Jump) :-
    JX is X + DX,
    JY is Y + DY,
    NewX is X + 2*DX,
    NewY is Y + 2*DY,
    valid_jump(Board, (X, Y), (JX, JY), (NewX, NewY), Player).



% Define the predicate valid_moves/4, which takes four arguments:
%   - Board: the current state of the board (represented as a list of lists of integers)
%   - Pos: the current position of the piece (represented as a pair of integers)
%   - Moves: the list of moves that are valid
%   - Player: the player 



valid_moves(Board, Pos, Moves, Player):-
    findall(NewPos, valid_jump(Board, Pos, _, NewPos, Player), Moves),   %jumps

valid_moves(Board, Pos, Moves, Player) :-
    findall(NewPos, (valid_move(Board, Pos, NewPos), \+ member(NewPos, Moves)), NewMoves),   %moves   
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

valid_chains(Board, Pos, Moves, Player) :-
   findall(Chain, chain_capture(Board, Pos, Chain, _, Player), Captures).






