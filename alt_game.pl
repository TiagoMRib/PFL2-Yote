:- consult('tabuleiro.pl').
:- consult('rules.pl').
:- consult('utils.pl').
:- consult('menu.pl').

dynamic(n_pieces/2).

set_pieces(Color, Number):-
    retract(n_pieces(Color, _)),
    assert(n_pieces(Color, Number)).

retract_pieces(Color):-
    n_pieces(Color, Number),
    NewNumber is Number - 1,
    retract(n_pieces(Color, _)),
    assert(n_pieces(Color, NewNumber)).

start_game:- menu.

initialization:-
    create_board(Board),
    set_pieces(white, 12),
    set_pieces(black, 12),

    % TEST
    n_pieces(white, TestW),
    write(TestW), nl,
    n_pieces(black, TestB),
    write(TestB), nl,
    % TEST

    write('Player 1 (white):'),
    write('1-Human'),
    write('2-Easy Bot'),
    write('3-Intelligent Bot'),
    read(Option1),
    type_of_player(Option1, Player1),

    write('Player 2 (black):'),
    write('1-Human'),
    write('2-Easy Bot'),
    write('3-Intelligent Bot'),
    read(Option2),
    type_of_player(Option2, Player2),

    define_players(Player1, Player2),

    play_game(Board, Player1, white).

% game_over(-Board, -Player, ?Result)
%
%
game_over(Board, Player, draw):-
    n_pieces(white, Nwhite),
    n_pieces(black, Nblack),
    Nwhite =< 3,
    Nblack =< 3.

game_over(Board, Player, draw):-

    % put here the thing that checks all moves

    n_pieces(white, Nwhite),
    n_pieces(black, Nblack),
    Nwhite =:= Nblack.

game_over(Board, Player, white):-

    % put here the thing that checks all moves

    n_pieces(white, Nwhite),
    n_pieces(black, Nblack),
    Nwhite > Nblack.

game_over(Board, Player, black):-

    % put here the thing that checks all moves

    n_pieces(white, Nwhite),
    n_pieces(black, Nblack),
    Nwhite < Nblack.

play_game(Board, human, Color) :-
    repeat,
    display_board(Board),
    n_pieces(white, Nwhite),
    n_pieces(black, Nblack),
    write('Number of white pieces left: '), write(Nwhite),nl,
    write('Number of black pieces left: '), write(Nblack),nl,
    write('Select 1 to place a piece, 2 to move a piece, 3 to eat a piece and 4 to quit.'), nl,
    read(Option), nl,
    move(Option, Board, Player, NewBoard), 
    nextPlayer(Player, OtherPlayer), 
    opponent(Color, NextColor),
    game_over(OtherPlayer, Result),
    (   Result = white
     ->  write('Game over! White wins!'), nl, !
     ;
      Result = black
     ->  write('Game over! Black wins!'), nl, !
    ;   Result = draw
    ->  write('The game is a draw.'), nl, !
    ;   
        play_game(NewBoard, OtherPlayer, NextColor)
    ).



move(1, Board, Color, NewBoard) :-
    n_pieces(Color, Np),
    Np > 0, nl,
    write('Select the position you want to place the piece:'), nl,
    read(Pos), nl,
    atom_chars(Pos, InputList),
    convert_letter_to_number(InputList,NewPos),
    empty(Board, NewPos),
    inside_board(Board, NewPos),
    place(Board, NewPos, Color, NewBoard),
    retract_pieces(Color).

move(1, Board, Color, NewBoard) :-
    n_pieces(Color, 0),
    write('You have no more pieces to place'), nl,
    write('Select another move'), nl,
    write('Select 2 to move a piece, 3 to eat a piece and 4 to quit.'), nl,
    read(Option), nl,
    move(Option, Board, Player, NewBoard).

move(1, Board, Color, NewBoard) :-
    n_pieces(Color, Np),
    Np > 0, nl,
    write('Select the position you want to place the piece:'), nl,
    read(Pos), nl,
    atom_chars(Pos, InputList),
    convert_letter_to_number(InputList,NewPos),
    \+empty(Board, NewPos),    % already checks if its inside board
    write('You cant place it there.'), nl,
    write('Select another move'), nl,
    write('Select 2 to move a piece, 3 to eat a piece and 4 to quit.'), nl,
    read(Option), nl,
    move(Option, Board, Player, NewBoard).



%%%%%%%%%%% TO BE SEEN


move(2, Board, Color, NewBoard) :-
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

move(3, Board, Color, NewBoard) :-
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


move(4, Board, NumberWhitePieces, NumberBlackPieces, Type, NewBoard, NewWhitePieces, NewBlackPieces) :-
    write('Game over'), nl,
    break.

convert_letter_to_number([X,Y], (NewX,NewY)):-
    numberLetter(NewX,X),
    numberLetter(NewY,Y).
    

    