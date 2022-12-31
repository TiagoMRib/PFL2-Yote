:- consult('tabuleiro.pl').


:- consult('tabuleiro.pl').

opponent(white, black).
opponent(black, white).

is_mine(white, w).
is_mine(black, b).
is_mine(empty, 0).


% Define the predicate enemy/3, which takes three arguments:
%   - Board: the current state of the board (represented as a list of lists of simbols)
%   - Pos: the position of the piece to be evaluated (represented as a pair of integers)
%   - Player: the player making the move
% Checks if the content of Pos is enemy of Player
enemy(Board,(X,Y),Player):-
	pos(Board,(X,Y),Piece),
    is_mine(Owner, Piece),
	opponent(Player, Owner), !.


delete_pos(Board, (X,Y), NewBoard):-
    change_board_element(Board, X, Y, 0, NewBoard).

set_pos(Board, (X,Y), Simbol, NewBoard):-
    change_board_element(Board, X, Y, Simbol, NewBoard).



% Define the predicate place/4, which takes four arguments:
%   - Board: the current state of the board (represented as a list of lists of simbols)
%   - Pos: the current position of the piece (represented as a pair of integers)
%   - Player: the player making the move
%   - NewBoard: the new state of the board (represented as a list of lists of simbols)
place(Board, Pos, Player, NewBoard):-
    is_mine(Player, Simbol),
    set_pos(Board, Pos, Simbol, NewBoard).



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
    empty(Board, NewPos),        %if pos is vacant
    write('One valid move to '), write(NewPos), nl.

valid_move(Board, Pos, NewPos) :-
    move(Pos, (-1,0), NewPos),
    inside_board(Board, NewPos),
    empty(Board, NewPos),
    write('One valid move to '), write(NewPos), nl.

valid_move(Board, Pos, NewPos) :-
    move(Pos, (0,1), NewPos),
    inside_board(Board, NewPos),
    empty(Board, NewPos),
    write('One valid move to '), write(NewPos), nl.

valid_move(Board, Pos, NewPos) :-
    move(Pos, (0,-1), NewPos),
    inside_board(Board, NewPos),
    empty(Board, NewPos),
    write('One valid move to '), write(NewPos), nl.

%valid_move(_, _, _) :-
%   write('No more valid moves'), nl.



% Define the predicate jump/4, which takes four arguments:
%   - Pos: the current position of the piece (represented as a pair of integers)
%   - Jump: the position of the piece being jumped (represented as a pair of integers)
%   - Dir: the direction in which the piece is moving (represented as a pair of integers)
%   - NewPos: the new position of the piece after making the jump
jump((X,Y), (JX,JY), (DX,DY), (NewX,NewY)) :-
    NewX is X + 2*DX,
    NewY is Y + 2*DY,
    write('T:'), write((NewX,NewY)), nl,
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
    empty(Board, NewPos),
    write('One valid jump to '), write(NewPos), nl.

valid_jump(Board, Pos, Jump, NewPos, Player) :-
    jump(Pos, Jump, (-1,0), NewPos),
    inside_board(Board, Jump),         
    inside_board(Board, NewPos),
    enemy(Board, Jump, Player),
    empty(Board, NewPos),
    write('One valid jump to '), write(NewPos), nl.

valid_jump(Board, Pos, Jump, NewPos, Player) :-
    jump(Pos, Jump, (0,1), NewPos),
    inside_board(Board, Jump),         
    inside_board(Board, NewPos),
    enemy(Board, Jump, Player),
    empty(Board, NewPos),
    write('One valid jump to '), write(NewPos), nl.

valid_jump(Board, Pos, Jump, NewPos, Player) :-
    jump(Pos, Jump, (0,-1), NewPos),
    inside_board(Board, Jump),         
    inside_board(Board, NewPos),
    enemy(Board, Jump, Player),
    empty(Board, NewPos),
    write('One valid jump to '), write(NewPos), nl.

%valid_jump(_, _, _, _, _) :-
%   write('No more valid jumps'), nl.




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




valid_moves(Board, Pos, Result, Player) :-   
    write('searching jumps'),
    findall(NewPos, valid_jump(Board, Pos, _, NewPos, Player), Moves),
    write('Moves:'), write(Moves), nl,
    write('going for the moves now'),
    findall(NewPos, (valid_move(Board, Pos, NewPos)), NewMoves),   %moves  
    write('NewMoves here:'), write(NewMoves), nl,
    append(NewMoves, Moves, Result).





% Define the predicate chain_capture/4, which takes four arguments:
%   - Board: the current state of the board (represented as a list of lists of integers)
%   - Pos: the current position of the piece (represented as a pair of integers)
%   - Captures: the list of positions of the pieces captured in the chain capture
%   - NewPos: the final position of the piece after making the chain capture
chain_capture(Board, Pos, [Capture|Rest], NewPos, Player) :-
    valid_jump(Board, Pos, Capture, NewPos, Player), % make a single jump
    write('Piece being jumped:'),write(Capture), nl,
    delete_pos(Board, Capture, NewBoard),
    chain_capture(NewBoard, NewPos, Rest, _, Player). % continue the chain capture

chain_capture(Board, Pos, [], Pos, _) :- % base case: no more jumps are possible
    \+valid_jump(Board, Pos, _, _, Player),
    write('No more jumps are possible'), nl.


chain_capture(Board, Pos, [], _, _) :- % base case: single jump that cannot be continued
    valid_jump(Board, Pos, _, _, _).

%chain_capture(_, Pos, Captures, Pos, Player) :- % base case: no more jumps are possible
%    \+ valid_jump(_, Pos, _, _,  Player), % no more jumps are possible
%    write('No more jumps are possible'),
%    Captures \= []. % Captures must not be empty



valid_chains(Board, Pos, Captures, Player) :-
    write('Entering'), nl,
   findall(Chain, chain_capture(Board, Pos, Chain, _, Player), Captures),
   write(Captures).



% UNFINISHED
type_human_move(Board, Color, Pos, NewPos, move):-  
    valid_move(Board, Pos, NewPos).



type_human_move(Board, Color, (SX, SY), (NX, NY), chain):-  
    CapX is div(SX + NX, 2),
    CapY is div(SY + NY, 2),
    chain_capture(Board, (SX, SY), [(CapX, CapY)|_], _, Color), !.



type_human_move(Board, Color, (SX, SY), (NX, NY), jump):-
    CapX is div(SX + NX, 2),
    CapY is div(SY + NY, 2),
    write((CapX, CapY)),
    valid_jump(Board, (SX, SY), (CapX, CapY), (NX, NY), Color).








move_piece(Board, (X,Y), 1, Type, NewBoard):-
    %valid_input(Board, Pos, Dir, NewPos, Move),
    %type_human_move(Board, Pos, NewPos, Move),
    %delete_pos(Board, Pos, TempBoard),
    %insert_pos(TempBoard, NewPos, 1, NewBoard).
    %write('hereeeeeee'), nl,
    %place(Board, (X,Y), 0, MidBoard), nl,
    change_board_element(Board, X, Y, 0, MidBoard),
    NewY is Y + 1,
    place(MidBoard, (X,NewY), Type, NewBoard).
    %change_board_element(MidBoard, X, NewY, Type, NewBoard).

move_piece(Board, (X,Y), 2, Type, NewBoard):-
    change_board_element(Board, X, Y, 0, MidBoard),
    NewY is Y - 1,
    place(MidBoard, (X,NewY), Type, NewBoard).

move_piece(Board, (X,Y), 3, Type, NewBoard):-
    change_board_element(Board, X, Y, 0, MidBoard),
    NewX is X + 1,
    place(MidBoard, (NewX,Y), Type, NewBoard).

move_piece(Board, (X,Y), 4, Type, NewBoard):-
    change_board_element(Board, X, Y, 0, MidBoard),
    NewX is X - 1,
    place(MidBoard, (NewX,Y), Type, NewBoard).