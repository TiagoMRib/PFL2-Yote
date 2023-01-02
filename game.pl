:- consult('tabuleiro.pl').
:- consult('rules.pl').
:- consult('utils.pl').

start_game:- menu.
    %write('Welcome to the game of Yote'), nl,
    %write('There are three types of player:'), nl,
    %write('Human'), nl,
    %write('NoobBot - a not so smart AI'), nl,
    %write('ProBot - an agressive AI that will try to capture you at all costs'), nl,
    %write('Player 1 type: '), write(Player1), nl,
    %write('Player 2 type: '), write(Player2), nl,
    %set_pieces(white, 12),
    %set_pieces(black, 12),
    %define_players(Player1, Player2),
    
    
    % Define the predicate play_game/2, which takes two arguments:
    %   - Board: the current state of the board (represented as a list of lists of integers)
    %   - Color: the color of the current player 
    %   - PlayerType: if it's human or a bot
play_game([[]|[]]) :-
    write('Its here'), nl.

play_game(Board, NumberWhitePieces, NumberBlackPieces, Color) :-
    write('Current board:'), nl,
    display_board(Board), nl,
    write('Current player: '), write(Color), nl,
    write('Number of white pieces left: '), write(NumberWhitePieces),nl,
    write('Number of black pieces left: '), write(NumberBlackPieces),nl,
    write('Select 1 to place a piece, 2 to move a piece, 3 to eat a piece and 4 to quit.'), nl,
    read(Option), nl,
    move_chosen(Option, Board, NumberWhitePieces, NumberBlackPieces, Color, NewBoard, NewWhitePieces, NewBlackPieces),nl,
    change_color(Color, NewColor),
    play_game(NewBoard, NewWhitePieces, NewBlackPieces, NewColor).
    %repeat, % repeat the game until the player decides to stop
    %write('Current board:'), nl,
    %print_board(Board), % print the current board
    %write('Current player: '), write(Color), nl,
    %write('Enter move or type "stop" to quit:'), nl,
    %read(Move), % read the player's move
    %(Move = stop -> ! ; % if the player wants to stop, then cut and exit
    %(valid_input(Board, Color, Pos, Move, NewPos, Type) -> % if the move is valid, update the board and switch to the next player
    %  update_board(Board, Pos, NewPos, Type, NewBoard),  %if the type is jump we must erase the piece from (Pos + Dir) as well
    %  opponent(Color, NewColor),
    %  nextPlayer(Human, Next)
    %  play_game(NewBoard, NewColor, Next)
    % ;
    %  write('Invalid move'), nl % if the move is invalid, print an error message and repeat the game
    %)
    %).

move_chosen(1, Board, NumberWhitePieces, NumberBlackPieces, white, NewBoard, NewWhitePieces, NewBlackPieces) :-
    NumberWhitePieces > 0, nl,
    write('Select the position you want to place the whiteee piece:'), nl,
    read(Pos), nl,
    atom_chars(Pos, InputList),
    convert_letter_to_number(InputList,NewPos),
    place(Board, NewPos, Type, NewBoard),
    NewWhitePieces is NumberWhitePieces - 1, 
    NewBlackPieces is NumberBlackPieces.

move_chosen(1, Board, NumberWhitePieces, NumberBlackPieces, white, NewBoard, NewWhitePieces, NewBlackPieces) :-
    NumberWhitePieces = 0, nl,
    write('You have no more pieces to place'), nl,
    NewBoard = Board,
    NewWhitePieces is NumberWhitePieces, 
    NewBlackPieces is NumberBlackPieces,
    play_game(NewBoard, NewWhitePieces, NewBlackPieces, white).

move_chosen(1, Board, NumberWhitePieces, NumberBlackPieces, black, NewBoard, NewWhitePieces, NewBlackPieces) :-
    NumberBlackPieces > 0, nl,
    write('Select the position you want to place the piece:'), nl,
    read(Pos), nl,
    atom_chars(Pos, InputList),
    convert_letter_to_number(InputList,NewPos), 
    place(Board, NewPos, black, NewBoard),
    NewWhitePieces is NumberWhitePieces, 
    NewBlackPieces is NumberBlackPieces-1.

move_chosen(1, Board, NumberWhitePieces, NumberBlackPieces, black, NewBoard, NewWhitePieces, NewBlackPieces) :-
    NumberBlackPieces = 0, nl,
    write('You have no more pieces to place'), nl,
    NewBoard = Board,
    NewWhitePieces is NumberWhitePieces, 
    NewBlackPieces is NumberBlackPieces,
    play_game(NewBoard, NewWhitePieces, NewBlackPieces, black).

move_chosen(2, Board, NumberWhitePieces, NumberBlackPieces, Type, NewBoard, NewWhitePieces, NewBlackPieces) :-
    write('Select the position of the piece you want to move:'), nl,
    read(Pos),nl,
    atom_chars(Pos, InputList),
    convert_letter_to_number(InputList,NewPos), 
    write('Choose a direction to move to:'), nl,
    write('1. Down'), nl,
    write('2. Up'), nl,
    write('3. Right'), nl,
    write('4. Left'), nl,
    read(Dir),nl,
    move_piece(Board, NewPos, Dir, Type, NewBoard), nl,
    NewWhitePieces is NumberWhitePieces, 
    NewBlackPieces is NumberBlackPieces.

move_chosen(3, Board, NumberWhitePieces, NumberBlackPieces, Type, NewBoard, NewWhitePieces, NewBlackPieces) :-
    write('Select the position of the piece you want to move to eat:'), nl,
    read(Pos),nl,
    atom_chars(Pos, InputList),
    convert_letter_to_number(InputList,NewPos), 
    write('Choose the direction you will be eating:'), nl,
    write('1. Down'), nl,
    write('2. Up'), nl,
    write('3. Right'), nl,
    write('4. Left'), nl,
    read(Dir),nl,
    move_piece_to_eat(Board, NewPos, Dir, Type, NewBoard), nl,
    NewWhitePieces is NumberWhitePieces, 
    NewBlackPieces is NumberBlackPieces.


move_chosen(4, Board, NumberWhitePieces, NumberBlackPieces, Type, NewBoard, NewWhitePieces, NewBlackPieces) :-
    write('Game over'), nl,
    break.

convert_letter_to_number([X,Y], (NewX,NewY)):-
    numberLetter(NewX,X),
    numberLetter(NewY,Y).

change_color(white, black).
change_color(black, white).
    