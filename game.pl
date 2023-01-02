:- consult('tabuleiro.pl').
:- consult('rules.pl').
:- consult('utils.pl').

% Define the predicate start_game/0, which starts the game
start_game:- menu.
    
    % Define the predicate play_game/4, which takes four arguments:
    %   - Board: the current state of the board (represented as a list of lists)
    %   - Color: the color of the current player 
    %   - NumberWhitePieces: the number of white pieces left
    %   - NumberBlackPieces: the number of black pieces left
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

% Define the predicate move_chosen/8, which takes eight arguments:
%   - Option: the option chosen by the player
%   - Board: the current state of the board (represented as a list of lists)
%   - NumberWhitePieces: the number of white pieces left
%   - NumberBlackPieces: the number of black pieces left
%   - Color: the color of the current player
%   - NewBoard: the new state of the board (represented as a list of lists)
%   - NewNumberWhitePieces: the new number of white pieces left
%   - NewNumberBlackPieces: the new number of black pieces left
move_chosen(1, Board, NumberWhitePieces, NumberBlackPieces, white, NewBoard, NewWhitePieces, NewBlackPieces) :-
    NumberWhitePieces > 0, nl,
    write('Select the position you want to place the whiteee piec
        
        e:'), nl,
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

% Define the predicate convert_letter_to_number/2, which takes two arguments:
%   - InputList: a list of two elements, the first being a letter and the second being a number
%   - NewPos: a tuple of two elements, the first being a number and the second being a number
convert_letter_to_number([X,Y], (NewX,NewY)):-
    numberLetter(NewX,X),
    numberLetter(NewY,Y).

change_color(white, black).
change_color(black, white).
    