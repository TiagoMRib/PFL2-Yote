:- consult('tabuleiro.pl').

:- [rules].

dynamic(number_pieces/2).

teste(Result) :-
    create_board(GameBoard),
    change_board_element(2, 2, w, NewGameBoard),
    print(NewGameBoard).

    set_pieces(Player, Number):-
        retract(number_pieces(_, _)),
        assert(number_pieces(Player, Number)).
    
    start_game():-
        write('Welcome to the game of Yote'), nl,
        write('There are three types of player:'), nl,
        write('Human'), nl,
        write('NoobBot - a not so smart AI'), nl,
        write('ProBot - an agressive AI that will try to capture you at all costs'), nl,
        write('Player 1 type: '), write(Player1), nl,
        write('Player 2 type: '), write(Player2), nl,
        set_pieces(white, 12),
        set_pieces(black, 12),
        define_players(Player1, Player2),
    
    
    % Define the predicate play_game/2, which takes two arguments:
    %   - Board: the current state of the board (represented as a list of lists of integers)
    %   - Color: the color of the current player 
    %   - PlayerType: if it's human or a bot
    play_game(Board, Color, Human) :-
        repeat, % repeat the game until the player decides to stop
        write('Current board:'), nl,
        print_board(Board), % print the current board
        write('Current player: '), write(Color), nl,
        write('Enter move or type "stop" to quit:'), nl,
        read(Move), % read the player's move
        (Move = stop -> ! ; % if the player wants to stop, then cut and exit
         (valid_input(Board, Color, Pos, Move, NewPos, Type) -> % if the move is valid, update the board and switch to the next player
          update_board(Board, Pos, NewPos, Type, NewBoard),  %if the type is jump we must erase the piece from (Pos + Dir) as well
          opponent(Color, NewColor),
          nextPlayer(Human, Next)
          play_game(NewBoard, NewColor, Next)
         ;
          write('Invalid move'), nl % if the move is invalid, print an error message and repeat the game
         )
        ).
    
    play_game(Board, Color, NoobBot) :-
        repeat, % repeat the game until the player decides to stop
        write('Current board:'), nl,
        print_board(Board), % print the current board
        write('Current player: '), write(Color), nl,
        .
    
    play_game(Board, Color, ProBot) :-
        repeat, % repeat the game until the player decides to stop
        write('Current board:'), nl,
        print_board(Board), % print the current board
        write('Current player: '), write(Color), nl,
    
play_game(Board, Color, ProBot)       .