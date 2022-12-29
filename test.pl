:- consult('tabuleiro.pl').

teste(Result) :-
    create_board(GameBoard),
    change_board_element(2, 2, w, NewGameBoard),
    print(NewGameBoard).