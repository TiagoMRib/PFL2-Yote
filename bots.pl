
:- use_module(library(lists)).
:- use_module(library(random)).
:- consult('tabuleiro.pl').
:- consult('rules.pl').


dynamic(nextPlayer/2).


define_players(human, human):-
    retract(nextPlayer(_, _)), !,
    assert(nextPlayer(human, human)).

define_players(human, human):-
    assert(nextPlayer(human, human)).

define_players(human, noobBot):-
    retract(nextPlayer(_, _)), !,
    assert(nextPlayer(human, noobBot)).

define_players(human, noobBot):-
    assert(nextPlayer(human, noobBot)).

define_players(human, proBot):-
    retract(nextPlayer(_, _)), !,
    assert(nextPlayer(human, proBot)).

define_players(human, proBot):-
    assert(nextPlayer(human, proBot)).

define_players(noobBot, human):-
    retract(nextPlayer(_, _)), !,
    assert(nextPlayer(noobBot, human)).

define_players(noobBot, human):-
    assert(nextPlayer(noobBot, human)).

define_players(noobBot, noobBot):-
    retract(nextPlayer(_, _)), !,
    assert(nextPlayer(noobBot, noobBot)).

define_players(noobBot, noobBot):-
    assert(nextPlayer(noobBot, noobBot)).

define_players(noobBot, proBot):-
    retract(nextPlayer(_, _)), !,
    assert(nextPlayer(noobBot, proBot)).

define_players(noobBot, proBot):-
    assert(nextPlayer(noobBot, proBot)).

define_players(proBot, human):-
    retract(nextPlayer(_, _)), !,
    assert(nextPlayer(proBot, human)).

define_players(proBot, human):-
    assert(nextPlayer(proBot, human)).

define_players(proBot, noobBot):-
    retract(nextPlayer(_, _)), !,
    assert(nextPlayer(proBot, noobBot)).

define_players(proBot, noobBot):-
    assert(nextPlayer(proBot, noobBot)).

define_players(proBot, proBot):-
    retract(nextPlayer(_, _)), !,
    assert(nextPlayer(proBot, proBot)).

define_players(proBot, proBot):-
    assert(nextPlayer(proBot, proBot)).


type_of_player(1, human).
type_of_player(2, noobBot).
type_of_player(3, proBot).

is_bot(noobBot).
is_bot(proBot).



% HELPER

% Define the predicate longer_list/2, which takes a list of lists and a result list that will be the longer list inside it as arguments
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
    write('Entred here'), nl,
    write('The Pos'), write(Pos), nl,
    valid_moves(Board, Pos, [Move| Tail], Color),
    write('Moves available for Pro:'), write([Move|Tail]), nl,
    \+length([Move| Tail], 0),
    write('he chooses:'), write(Move), nl.


find_pieces(Board, Color, Pieces):-
    findall(Result, pos(Board, Result, Color), Pieces),
    write('Pieces: '), write(Pieces), nl.


allBestMoves(Board, Color, Bot, Moves):-
    find_pieces(Board, Color, Pieces),
    write('The Pices:'), write(Pieces), nl,
    allbestMovesAux(Board, Pieces, Color, Bot, Moves).

allbestMovesAux(_, [], _, _, []):- write('Base case'), nl,!.

allbestMovesAux(Board, [X|T], Simbol, Bot, Moves):-
    write('X'), write(X), nl,
    write('T'), write(T), nl,
    is_mine(Color, Simbol),
    chooseMove(Board, X, Color, Bot, Move),
    allbestMovesAux(Board, T, Simbol, Bot, NewMoves),
    write('NewMoves'), nl,
    append([(X,Move)], NewMoves, Moves),
    write('Moves'), nl.




%choose_place/2
%chooses a random empty position to place a piece
% to be called if allvestMoves returns []
choose_place(Board, Pos):-
    findall(Pos, empty(Board, Pos), Empties),
    random_member(Pos, Empties).


typeofMove((_,(X,Y)), 1). %move

typeofMove((_,[X]), 2). %jump

typeofMove((_, [X1, X2 | Tail]), Value):-  %chain
    length([X1, X2 | Tail], Len),
    Value is Len + 1.





higher_value([], CurrentLargest, Result):-
    write('Base Case'), nl,
    write(CurrentLargest), nl,
    typeofMove(CurrentLargest, Result),
    
    write(Result), nl.

higher_value([(Pos, Move) | Tail], CurrentLargest, Result):-
    write('The Move:'), write((Pos, Move)),nl,
    typeofMove((Pos, Move), Score),
    write('Score:'), write(Score), nl,
    typeofMove(CurrentLargest, Record),
    write('Record:'), write(Record), nl,
    Score > Record,
    higher_value(Tail, (Pos, Move), Result).

higher_value([(Pos, Move) | Tail], CurrentLargest, Result):-
    typeofMove((Pos, Move), Score),
    typeofMove(CurrentLargest, Record),
    Score =< Record,
    higher_value(Tail, CurrentLargest, Result).


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









