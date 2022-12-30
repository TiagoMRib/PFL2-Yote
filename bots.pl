
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
longer_list([List|Lists], Result) :-
    % If the list of lists is empty, the result is the empty list
    (Lists = [] -> Result = List ;
     % Otherwise, compare the lengths of the first list and the result list
     (length(List, Length1), length(Result, Length2),
      % If the first list is longer, it becomes the new result
      (Length1 > Length2 -> longer_list(Lists, List) ;
       % If the result list is longer or they have the same length, keep the result list as is
       longer_list(Lists, Result)))).

% HELPER

chooseMove(Board, Pos, Color, NoobBot, Move):-
    valid_moves(Board, Pos, Moves, Color),
    \+lenght(Moves, 0),
    random_member(Move, Moves).

chooseMove(Board, Pos, Color, ProBot, Move):-
    valid_chains(Board, Pos, Captures, Player),
    \+length(Captures, 0),
    longer_list(Captures, Move).


chooseMove(Board, Pos, Color, ProBot, Move):-
    valid_moves(Board, Pos, [Move| Tail], Color),
    \+length([Move| Tail], 0).

