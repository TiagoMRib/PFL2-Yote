:- consult('rules.pl').

teste(Result) :-
    create_board(GameBoard),
    change_board_element(GameBoard, 2, 2, w, NewGameBoard),
    print(NewGameBoard), nl,
    change_board_element(NewGameBoard, 4, 2, b, NewerGameBoard),
    print(NewerGameBoard).


teste_empty(Result) :-
    create_board(Board),
    print(Board),
    empty(Board, (3,2)),
    place(Board, (3,2), white, NewBoard),
    print(NewBoard), nl,
    empty(NewBoard, (3,2)),
    place(NewBoard, (3,2), black, NewerBoard),
    print(NewerBoard), nl.

teste_empty(Result) :-
    create_board(Board),
    print(Board),
    empty(Board, (3,2)),
    place(Board, (3,2), white, NewBoard),
    print(NewBoard), nl,
    \+empty(NewBoard, (3,2)),
    valid_moves(NewerBoard, (3,2), Result, white).

teste_valid(Result) :-
    create_board(Board),
    print(Board),
    place(Board, (3,2), white, NewBoard),
    print(NewBoard), nl,
    place(NewBoard, (3,2), black, NewerBoard),
    print(NewerBoard), nl,
    valid_moves(NewerBoard, (3,2), Result, white).

chain_Board([[0,0,0,b,0,0],[0,0,0,0,b,0],[0,b,w,b,0,0],[b,0,0,0,0,0],[0,0,0,0,0,0]]).

teste_chain(Moves) :-
    chain_Board(Board),
    valid_chains(Board, (3,3), Moves, white).
