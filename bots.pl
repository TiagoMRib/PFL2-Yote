<<<<<<< Updated upstream
=======
:- use_module(library(lists)).
:- use_module(library(random)).

>>>>>>> Stashed changes
dynamic(nextPlayer/2).

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
<<<<<<< Updated upstream
    \+length([Move| Tail], 0).
=======
    write('Moves available for Pro:'), write(Captures), nl,
    \+length([Move| Tail], 0),
    write('he chooses:'), write(Move), nl, nl.



typeofMove((_,_), move).


typeofMove(Move, jump):-
    length(Move, 1).


typeofMove(Move, chain):-
    \+length(Move, 0),
     \+length(Move, 1).


>>>>>>> Stashed changes
