
:- use_module(library(lists)).
:- use_module(library(random)).

dynamic(nextPlayer/2).

% Define the predicate define_players/2, which defines the player as a human or a bot
define_players(Human, Human):-
    retract(nextPlayer(_, _)),
    assert(nextPlayer(Human, Human)).

define_players(Human, NoobBot):-
    retract(nextPlayer(_, _)),
    assert(nextPlayer(Human, NoobBot)).

define_players(Human, ProBot):-
    retract(nextPlayer(_, _)),
    assert(nextPlayer(Human, ProBot)).

define_players(NoobBot, Human):-
    retract(nextPlayer(_, _)),
    assert(nextPlayer(NoobBot, Human)).

define_players(NoobBot, NoobBot):-
    retract(nextPlayer(_, _)),
    assert(nextPlayer(NoobBot, NoobBot)).

define_players(NoobBot, ProBot):-
    retract(nextPlayer(_, _)),
    assert(nextPlayer(NoobBot, ProBot)).

define_players(ProBot, Human):-
    retract(nextPlayer(_, _)),
    assert(nextPlayer(ProBot, Human)).

define_players(ProBot, NoobBot):-
    retract(nextPlayer(_, _)),
    assert(nextPlayer(ProBot, NoobBot)).

define_players(ProBot, ProBot):-
    retract(nextPlayer(_, _)),
    assert(nextPlayer(ProBot, ProBot)).


% HELPER

% Define the predicate longer_list/2, which takes a list of lists and a result list as arguments
longest_list(List, Longest) :-
    longest_list(List, [], Longest).

longest_list([], Longest, Longest).
longest_list([H|T], Current, Longest) :-
    (   length(H, L),
        length(Current, CL),
        L > CL
    ->  longest_list(T, H, Longest)
    ;   longest_list(T, Current, Longest)
    ).

head_of_list([X|_], X).

% HELPER

% Define the predicate choose_move/5, which takes a board, a position and a color as arguments
% - Board: the current board
% - Pos: the position of the piece to move
% - Color: the color of the piece to move
% - Bot: the bot to play
% - Move: the move to be made
chooseMove(Board, Pos, Color, noobBot, Move):-
    valid_moves(Board, Pos, Moves, Color),
    write('Moves available for Noob:'), write(Moves), nl,
    \+length(Moves, 0),
    random_member(Move, Moves),
    write('he chooses:'), write(Move), nl.



    
chooseMove(Board, Pos, Color, proBot, Move):-    
    once((valid_chains(Board, Pos, Captures, Color),
    write('Chains available for Pro:'), write(Captures), nl,
    \+length(Captures, 0),
    head_of_list(Captures, Head),
    \+length(Head, 0),
    longest_list(Captures, Move),
    write('he chooses:'), write(Move), nl)).


chooseMove(Board, Pos, Color, proBot, Move):- 
    write('Entred here'),
    valid_moves(Board, Pos, [Move| Tail], Color),
    write('Moves available for Pro:'), write(Captures), nl,
    \+length([Move| Tail], 0),
    write('he chooses:'), write(Move), nl.


% Define the predicate find_pieces/3, which takes a board and a color and returns a list of positions of pieces of that color
% - Board: the current board
% - Color: the color of the pieces to find
% - Pieces: the list of positions of pieces of that color
find_pieces(Board, Color, Pieces):-
    findall(Result, pos(Board, Result, Color), Pieces),
    write('Pieces: '), write(Pieces), nl.

% Define the predicate all_best_moves/4, which takes a board, a color and a bot and returns the list of the best moves of each piece of that color
% - Board: the current board
% - Color: the color of the pieces to move
% - Bot: the bot to play
% - Moves: the list of the best moves of each piece of that color
allBestMoves(Board, Color, Bot, Moves):-
    find_pieces(Board, Color, Pieces),
    allbestMovesAux(Board, Pieces, Color, Bot, Moves).

allbestMovesAux(_, [], _, _, []):- !.

allbestMovesAux(Board, [X|T], Color, Bot, Moves):-
    chooseMove(Board, X, Color, Bot, Move),
    allbestMovesAux(Board, T, Color, Bot, NewMoves),
    append([(X,Move)], NewMoves, Moves).

%choose_place/2
%chooses a random empty position to place a piece
choose_place(Board, Pos):-
    findall(Pos, empty(Board, Pos), Empties),
    random_member(Pos, Empties).

% Define the typeofMove/3, which takes a board, a move and returns the type of movement
% - Board: the current board
% - Move: the move to be made
% - Type: the type of movement
typeofMove(Board, (X,Y), jump):-
    \+empty(Board, (X,Y)).

typeofMove(Board, (X,Y), move):-
    empty(Board, (X,Y)).

typeofMove(_, Move, jump):-
    length(Move, 1).


higher_value([(Pos, Move) | Tail], Result):-
    write('Started: '), write((Pos, Move)), nl,
    higher_value(Tail, (Pos, Move), Result).


type(0, place).
type(1, move).
type(2, jump).
type(Number, chain):- Number >= 2.


execute_move(Color, ((StartX, StartY), (NextX, NextY)), Board, NewBoard):-
    change_board_element(Board, StartX, StartY, 0, MidBoard),
    place(MidBoard, (NextX, NextY), Color, NewBoard).

execute_move(Color, ((StartX, StartY), [(CapX, CapY)]), Board, NewBoard):-
    DifX is CapX - StartX,
    FinalX is CapX + DifX,
    DifY is CapY - StartY,
    FinalY is CapY + DifY,
    change_board_element(Board, CapX, CapY, 0, MidBoard),
    change_board_element(MidBoard, StartX, StartY, 0, FinalBoard),
    place(FinalBoard, (FinalX,FinalY), Color, NewBoard).


execute_move(((StartX, StartY), [(CapX, CapY) | Tail]), Board, NewBoard):-
    DifX is CapX - StartX,
    FinalX is CapX + DifX,
    DifY is CapY - StartY,
    FinalY is CapY + DifY,
    change_board_element(Board, CapX, CapY, 0, MidBoard),
    change_board_element(MidBoard, StartX, StartY, 0, FinalBoard),
    place(FinalBoard, (FinalX,FinalY), Color, PrintBoard),
    display_board(PrintBoard), nl,
    execute_move((FinalX, FinalY), Tail, PrintBoard, NewBoard).









