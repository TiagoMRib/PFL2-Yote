
:- use_module(library(lists)).
:- use_module(library(random)).

dynamic(nextPlayer/2).


define_players(human, human):-
    retract(nextPlayer(_, _)),
    assert(nextPlayer(human, human)).

define_players(human, noobBot):-
    retract(nextPlayer(_, _)),
    assert(nextPlayer(human, noobBot)).

define_players(human, proBot):-
    retract(nextPlayer(_, _)),
    assert(nextPlayer(human, proBot)).

define_players(noobBot, human):-
    retract(nextPlayer(_, _)),
    assert(nextPlayer(noobBot, human)).

define_players(noobBot, noobBot):-
    retract(nextPlayer(_, _)),
    assert(nextPlayer(noobBot, noobBot)).

define_players(noobBot, proBot):-
    retract(nextPlayer(_, _)),
    assert(nextPlayer(noobBot, proBot)).

define_players(proBot, human):-
    retract(nextPlayer(_, _)),
    assert(nextPlayer(proBot, human)).

define_players(proBot, noobBot):-
    retract(nextPlayer(_, _)),
    assert(nextPlayer(proBot, noobBot)).

define_players(proBot, proBot):-
    retract(nextPlayer(_, _)),
    assert(nextPlayer(proBot, proBot)).


type_of_player(1, human).
type_of_player(2, noobBot).
type_of_player(3, proBot).



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

chooseMove(Board, Pos, Color, noobBot, Move):-
    valid_moves(Board, Pos, Moves, Color),
    write('Moves available for Noob:'), write(Moves), nl,
    \+length(Moves, 0),
    random_member(Move, Moves),
    write('he chooses:'), write(Move), nl, nl.



    
chooseMove(Board, Pos, Color, proBot, Move):-    
    once((valid_chains(Board, Pos, Captures, Color),
    write('Chains available for Pro:'), write(Captures), nl,
    \+length(Captures, 0),
    head_of_list(Captures, Head),
    \+length(Head, 0),
    longest_list(Captures, Move),
    write('he chooses:'), write(Move), nl, nl)).


chooseMove(Board, Pos, Color, proBot, Move):- 
    write('Entred here'),
    valid_moves(Board, Pos, [Move| Tail], Color),
    write('Moves available for Pro:'), write(Captures), nl,
    \+length([Move| Tail], 0),
    write('he chooses:'), write(Move), nl, nl.


find_pieces(Board, Color, Pieces):-
    findall(Result, pos(Board, Result, Color), Pieces),
    write('Pieces: '), write(Pieces), nl.


allBestMoves(Board, Color, Bot, Moves):-
    find_pieces(Board, Color, Pieces),
    allbestMovesAux(Board, Pieces, Color, Bot, Moves).

allbestMovesAux(_, [], _, _, []):- !.

allbestMovesAux(Board, [X|T], Color, Bot, Moves):-
    chooseMove(Board, X, Color, Bot, Move),
    allbestMovesAux(Board, T, Color, Bot, NewMoves),
    append([(X,Move)], NewMoves, Moves).

%testBestMoves:-
%    allBestMoves([
%        [0,0,b,0,0,0],
%        [0,w,0,0,0,0],
%        [0,w,0,0,0,0],
%        [0,w,0,0,0,0],
%        [0,b,0,0,0,0]], b, proBot, Moves),
%    write('Best Moves: '), write(Moves), nl.


%choose_place/2
%chooses a random empty position to place a piece
choose_place(Board, Pos):-
    findall(Pos, empty(Board, Pos), Empties),
    random_member(Pos, Empties).


typeofMove(Board, (X,Y), jump):-
    \+empty(Board, (X,Y)).

typeofMove(Board, (X,Y), move):-
    empty(Board, (X,Y)).

typeofMove(_, Move, jump):-
    length(Move, 1).


typeofMove(_, Move, chain):-
    \+length(Move, 0),
     \+length(Move, 1).

