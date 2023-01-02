:- consult('tabuleiro.pl').
:- consult('rules.pl').
:- consult('utils.pl').
:- consult('menu.pl').
:- consult('bots.pl').
:- consult('view.pl').

dynamic(n_pieces/2).

set_pieces(Color, Number):-
    retract(n_pieces(Color, _)), !,
    assert(n_pieces(Color, Number)).
set_pieces(Color, Number):-
    assert(n_pieces(Color, Number)).

retract_pieces(Color):-
    retract(n_pieces(Color, Number)),
    NewNumber is Number - 1,
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

    write('Player 1 (white):'), nl,
    write('1-Human'), nl,
    write('2-Easy Bot'), nl,
    write('3-Intelligent Bot'), nl,
    read(Option1),
    type_of_player(Option1, Player1),
    write('Player 2 (black):'), nl,
    write('1-Human'), nl,
    write('2-Easy Bot'), nl,
    write('3-Intelligent Bot'), nl,
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
    fail,
    n_pieces(white, Nwhite),
    n_pieces(black, Nblack),
    Nwhite =:= Nblack.

game_over(Board, Player, white):-

    % put here the thing that checks all moves
    % for now 
    fail,
    %for now
    n_pieces(white, Nwhite),
    n_pieces(black, Nblack),
    Nwhite > Nblack.

game_over(Board, Player, black):-

    % put here the thing that checks all moves
    fail,
    n_pieces(white, Nwhite),
    n_pieces(black, Nblack),
    Nwhite < Nblack.

%%%%%%%%%%% CASE NO PIECES/MOVES
play_game(Board, Bot, Color) :-
    is_bot(Bot),
    repeat,
    display_board(Board),
    n_pieces(white, Nwhite),
    n_pieces(black, Nblack),
    write('Number of white pieces left: '), write(Nwhite),nl,
    write('Number of black pieces left: '), write(Nblack),nl,
    write('Your turn: '), write(Color), nl, 
    
    %%%%%%%%%%%%%%%%  robot actions

    find_pieces(Board, Color, Pieces),

    write('Pieces Found (sec):'), write(Pieces), nl, 

    length(Pieces, 0),

    choose_place(Board, Pos),

    place(Board, Pos, Color, NewBoard),

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    nextPlayer(Bot, OtherPlayer), 
    opponent(Color, NextColor),
    (   game_over(NewBoard, OtherPlayer, Result)
     ->  (   Result = white
         ->  write('Game over! White wins!'), nl
         ;   Result = black
         ->  write('Game over! Black wins!'), nl
         ;   Result = draw
         ->  write('Draw'), nl

        )
     ;   play_game(NewBoard, OtherPlayer, NextColor)
    ).


play_game(Board, Bot, Color) :-
    is_bot(Bot),
    repeat,
    display_board(Board),
    n_pieces(white, Nwhite),
    n_pieces(black, Nblack),
    write('Number of white pieces left: '), write(Nwhite),nl,
    write('Number of black pieces left: '), write(Nblack),nl,
    write('Your turn: '), write(Color), nl, 
    
    %%%%%%%%%%%%%%%%  robot actions

    find_pieces(Board, Color, Pieces),

    write('Pieces Found (first):'), write(Pieces), nl, 

    \+length(Pieces, 0),

    allBestMoves(Board, Color, Bot, Moves),
    \+length(Moves, 0),
    higher_value(Moves, Result),

    execute_move(Color, Result, Board, NewBoard),


    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    nextPlayer(Bot, OtherPlayer), 
    opponent(Color, NextColor),
    (   game_over(NewBoard, OtherPlayer, Result)
     ->  (   Result = white
         ->  write('Game over! White wins!'), nl
         ;   Result = black
         ->  write('Game over! Black wins!'), nl
         ;   Result = draw
         ->  write('Draw'), nl

        )
     ;   play_game(NewBoard, OtherPlayer, NextColor)
    ).



%%%%%%%%%%% CASE NO MOVES
play_game(Board, Bot, Color) :-
    is_bot(Bot),
    repeat,
    display_board(Board),
    n_pieces(white, Nwhite),
    n_pieces(black, Nblack),
    write('Number of white pieces left: '), write(Nwhite),nl,
    write('Number of black pieces left: '), write(Nblack),nl,
    write('Your turn: '), write(Color), nl, 
    
    %%%%%%%%%%%%%%%%  robot actions

    find_pieces(Board, Color, Pieces),

    write('Pieces Found (thris):'), write(Pieces), nl, 

    \+length(Pieces, 0),
    
    allBestMoves(Board, Color, Bot, Moves),
    length(Moves, 0),

    choose_place(Board, Pos),

    place(Board, Pos, Color, NewBoard),

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    nextPlayer(Bot, OtherPlayer), 
    opponent(Color, NextColor),
    (   game_over(NewBoard, OtherPlayer, Result)
     ->  (   Result = white
         ->  write('Game over! White wins!'), nl
         ;   Result = black
         ->  write('Game over! Black wins!'), nl
         ;   Result = draw
         ->  write('Draw'), nl

        )
     ;   play_game(NewBoard, OtherPlayer, NextColor)
    ).


play_game(Board, human, Color) :-
    repeat,
    display_board(Board),
    n_pieces(white, Nwhite),
    n_pieces(black, Nblack),
    write('Number of white pieces left: '), write(Nwhite),nl,
    write('Number of black pieces left: '), write(Nblack),nl,
    write('Your turn: '), write(Color), nl, 
    write('Select 1 to place a piece, 2 to move a piece, 3 to eat a piece and 4 to quit.'), nl,
    read(Option), nl,
    move(Option, Board, Color, NewBoard), 
    nextPlayer(human, OtherPlayer), 
    opponent(Color, NextColor),
    (   game_over(NewBoard, OtherPlayer, Result)
     ->  (   Result = white
         ->  write('Game over! White wins!'), nl
         ;   Result = black
         ->  write('Game over! Black wins!'), nl
         ;   Result = draw
         ->  write('Draw'), nl

        )
     ;   play_game(NewBoard, OtherPlayer, NextColor)
    ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%  PLACEMET SECTION
place_move(Board, Color, Pos, NewBoard):-
    empty(Board,Pos), 
    place(Board, Pos, Color, NewBoard),
    retract_pieces(Color).

place_move(Board, Color, Pos, NewBoard):-
    \+empty(Board, Pos),    % already checks if its inside board
    write('You cant place it there.'), nl,
    write('Select another move'), nl,
    write('Select 1 to place a piece, 2 to move a piece, 3 to eat a piece and 4 to quit.'), nl,
    read(Option), nl,
    move(Option, Board, Color, NewBoard).


move(1, Board, Color, NewBoard) :-
    n_pieces(Color, Np),
    Np > 0, nl,
    write('Select the position you want to place the piece:'), nl,
    read(Pos), nl,
    atom_chars(Pos, InputList),
    convert_letter_to_number(InputList,NewPos),
    place_move(Board, Color, NewPos, NewBoard).

move(1, Board, Color, NewBoard) :-
    n_pieces(Color, 0),
    write('You have no more pieces to place'), nl,
    write('Select another move'), nl,
    write('Select 2 to move a piece, 3 to eat a piece and 4 to quit.'), nl,
    read(Option), nl,
    move(Option, Board, Color, NewBoard).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%   MOVEMENT SECTION
move_move(Board, Color, Pos, Dir, NewBoard):-
    move_piece(Board, Pos, Dir, Color, NewBoard), nl.

move_move(Board, Color, Pos, Dir, NewBoard):-
    \+move_piece(Board, Pos, Dir, Color, NewBoard), 
     write('Invalid move!'), nl,
     write('Select 1 to place a piece, 2 to move a piece, 3 to eat a piece and 4 to quit.'), nl,
    read(Option), nl,
    move(Option, Board, Color, NewBoard).

select_move_move(Board, Color, Pos, NewBoard):-
    is_mine(Color, Simbol),
    pos(Board, Pos, Simbol),
    write('Choose a direction to move to:'), nl,
    write('1. Down'), nl,
    write('2. Up'), nl,
    write('3. Right'), nl,
    write('4. Left'), nl,
    read(Dir),nl,
    move_move(Board, Color, Pos, Dir, NewBoard).

select_move_move(Board, Color, Pos, NewBoard):-
    is_mine(Color, Simbol),
    \+pos(Board, Pos, Simbol),
    write('That piece isnt your piece'), nl,
    write('Select 1 to place a piece, 2 to move a piece, 3 to eat a piece and 4 to quit.'), nl,
    read(Option), nl,
    move(Option, Board, Color, NewBoard).

move(2, Board, Color, NewBoard) :-
    write('Select the position of the piece you want to move:'), nl,
    read(Pos),nl,
    atom_chars(Pos, InputList),
    convert_letter_to_number(InputList,NewPos),
    select_move_move(Board, Color, NewPos, NewBoard).
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%% CAPTURE SECTION

execute_extraCapture(Board, Color, (X,Y), NewBoard):-
    enemy(Board, (X,Y), Color),
    change_board_element(Board, X, Y, 0, NewBoard),
    opponent(Color, OtherColor),
    retract_pieces(OtherColor),
    display_board(NewBoard).

execute_extraCapture(Board, Color, (X,Y), NewBoard):-
    \+enemy(Board, (X,Y), Color),
    write('Thats not an enemy'),nl,
    extraCapture(Board, Color, NewBoard).

extraCapture(Board, Color, Board):-
    opponent(Color, OtherColor),
    is_mine(OtherColor, Simbol),
    \+pos(Board, _, Simbol),
    write('Your opponent doesnt have pieces on the board'), nl,
    write('No extra captures will be possible'), nl.


extraCapture(Board, Color, NewBoard):-
    opponent(Color, OtherColor),
    is_mine(OtherColor, Simbol),
    pos(Board, _, Simbol),
    write('Choose now the extra capture:'),
    read(Pos), nl,
    atom_chars(Pos, InputList),
    convert_letter_to_number(InputList,NewPos),
    execute_extraCapture(Board, Color, NewPos, NewBoard).


capture_chain(Board, Color, Pos, NewBoard):-
    valid_jump(Board, Pos, _, _, Color),
    write('You can do a chain capture'), nl,
    display_board(Board),
    select_capture_move(Board, Color, Pos, NewBoard).

capture_chain(Board, Color, Pos, Board):-
    \+valid_jump(Board, Pos, _, _, Color).


capture_move(Board, Color, Pos, Dir, NewBoard):-
    move_piece_to_eat(Board, Pos, NewPos, Dir, Color, UpdBoard), nl,
    display_board(UpdBoard),
    extraCapture(UpdBoard, Color, OtherBoard),
    capture_chain(OtherBoard, Color, NewPos, NewBoard).
    

capture_move(Board, Color, Pos, Dir, NewBoard):-
    move_piece_to_eat(Board, Pos, NewPos, Dir, Color, UpdBoard), nl,
    display_board(UpdBoard),
    extraCapture(UpdBoard, Color, NewBoard),
    \+valid_jump(NewBoard, NewPos, _, _, Color).



capture_move(Board, Color, Pos, Dir, NewBoard):-
    \+move_piece_to_eat(Board, Pos, _, Dir, Color, _), 
     write('Invalid move!'), nl,
     write('Select 1 to place a piece, 2 to move a piece, 3 to eat a piece and 4 to quit.'), nl,
    read(Option), nl,
    move(Option, Board, Color, NewBoard).

select_capture_move(Board, Color, Pos, NewBoard):-
    is_mine(Color, Simbol),
    pos(Board, Pos, Simbol),
    write('Choose the direction you will be capturing:'), nl,
    write('1. Down'), nl,
    write('2. Up'), nl,
    write('3. Right'), nl,
    write('4. Left'), nl,
    read(Dir),nl,
    capture_move(Board, Color, Pos, Dir, NewBoard).

select_capture_move(Board, Color, Pos, NewBoard):-
    is_mine(Color, Simbol),
    \+pos(Board, Pos, Simbol),
    write('That piece isnt your piece'), nl,
    write('Select 1 to place a piece, 2 to move a piece, 3 to eat a piece and 4 to quit.'), nl,
    read(Option), nl,
    move(Option, Board, Color, NewBoard).



move(3, Board, Color, NewBoard) :-
    write('Select the position of the piece you want to use for a capture:'), nl,
    read(Pos),nl,
    atom_chars(Pos, InputList),
    convert_letter_to_number(InputList,NewPos), 
    select_capture_move(Board, Color, NewPos, NewBoard).



move(4, Board, Color, NewBoard) :-
    write('Game over'), nl,
    break.

convert_letter_to_number([X,Y], (NewX,NewY)):-
    numberLetter(NewX,X),
    numberLetter(NewY,Y).
    

    