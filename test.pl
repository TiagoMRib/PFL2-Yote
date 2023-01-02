:- consult('rules.pl').
:- consult('bots.pl').
:- consult('alt_game.pl').

% Tests the creation of the board, the printing of the board and the change of the board
teste(Result) :-
    create_board(GameBoard),
    change_board_element(GameBoard, 2, 2, w, NewGameBoard),
    print(NewGameBoard), nl,
    change_board_element(NewGameBoard, 4, 2, b, NewerGameBoard),
    print(NewerGameBoard).

% Tests emptying a position
teste_empty_out(Result) :-
    create_board(Board),
    print(Board),
    empty(Board, (9,2)).

teste_empty(Result) :-
    create_board(Board),
    print(Board),
    empty(Board, (3,2)),
    place(Board, (3,2), white, NewBoard),
    print(NewBoard), nl,
    \+empty(NewBoard, (3,2)),
    place(NewBoard, (3,3), black, NewerBoard),
   valid_moves(NewerBoard, (3,2), Result, white),
   write(Result).

verification_Board([[0, 1, 2, 3, 4, 5],
 [6, 7, 8, 9, 10, 11],
 [12, 13, 14, 15, 16, 17],
 [18, 19, 20, 21, 22, 23],
 [24, 25, 26, 27, 28, 29]]).

verify(Result) :-
    verification_Board(Board),
    empty(Board, (3,2)).


teste_valid(Result) :-
    create_board(Board),
    print(Board),
    place(Board, (3,2), white, NewBoard),
    print(NewBoard), nl,
    place(NewBoard, (3,2), black, NewerBoard),
    print(NewerBoard), nl,
    valid_moves(NewerBoard, (3,2), Result, white).

chain_Board([[0,0,0,b,0,0],
             [0,0,0,0,b,0],
             [0,b,w,b,0,b],
             [b,0,0,0,b,0],
             [0,0,0,0,0,0]]).

teste_chain(Moves) :-
    chain_Board(Board),
    chain_capture(Board, (3,3), Moves, NewPos, white),
    write(Moves),
    write(NewPos).


teste_sensor(Results):-
    chain_Board(Board),
    type_human_move(Board, white, (6,2), (4,2), TypeC),
    write(TypeC), nl,
    type_human_move(Board, white, (3,3), (3,1), TypeD),
    write(TypeD), nl.


teste_pos(Result):-
    capture_Board(Board),
    pos(Board, Result, w).


teste_inteligence(Result):-
    capture_Board(Board),
    intelligence(Board, white, noobBot, Result).


capture_Board([[0,0,0,0,0,0],
               [0,0,b,0,b,w],
               [0,b,w,0,0,b],
               [b,0,0,0,b,0],
               [0,0,0,w,0,0]]).

teste_bots:-
    capture_Board(Board),
    chooseMove(Board, (3,3), white, noobBot, Move),
    write('Idiot:'),write(Move),nl,
    chooseMove(Board, (3,3), white, proBot, OtherMove),
    write('Smart:'),write(OtherMove),nl,
    allBestMoves(Board, w, proBot, Moves),
    write('Best Moves: '), write(Moves), nl.


teste_smartbot(_):-
    capture_Board(Board),
    chooseMove(Board, (6,2), white, proBot, OtherMove),
    write('Smart:'),write(OtherMove),nl,
    typeofMove(OtherMove, Type),
    write(Type), nl.

testBestMoves :-
    capture_Board(Board),
    allBestMoves(Board, w, proBot, Moves),
    write('Best Moves: '), write(Moves), nl,

    write('Previous part over'), nl, nl, nl, nl,
    higher_value(Moves, Result),
    write('Result:'), write(Result), nl.

testBestMoves. % remove this line



test_game(_):-
    create_board(Board),
    set_pieces(white, 12),
    set_pieces(black, 12),

    % TEST
    n_pieces(white, TestW),
    write(TestW), nl,
    n_pieces(black, TestB),
    write(TestB), nl,
    % TEST

    write('Player 1 (white):'), nl,
    write('1-Human'), nl,
    write('2-Easy Bot'), nl,
    write('3-Intelligent Bot'), nl,
    read(Option1),
    type_of_player(Option1, Player1),
    write(Player1), 
    write('Player 2 (black):'), nl,
    write('1-Human'), nl,
    write('2-Easy Bot'), nl,
    write('3-Intelligent Bot'), nl,
    read(Option2),
    type_of_player(Option2, Player2),
    write(Player2),
    define_players(Player1, Player2).

    

