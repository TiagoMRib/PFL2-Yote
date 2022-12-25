

:- [rules].

% Define the predicate play_game/2, which takes two arguments:
%   - Board: the current state of the board (represented as a list of lists of integers)
%   - Color: the color of the current player 
play_game(Board, Color) :-
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
      play_game(NewBoard, NewColor)
     ;
      write('Invalid move'), nl % if the move is invalid, print an error message and repeat the game
     )
    ).



% Define the predicate set_board_element/4, which takes four arguments:
%   - Board: the current state of the board (represented as a list of lists of integers)
%   - Pos: the position of the element to set (represented as a pair of integers)
%   - Val: the new value of the element
%   - NewBoard: the new state of the board after setting the element
set_board_element(Board, (X,Y), Val, NewBoard) :-
    % get the X-th element of the board
    nth1(X, Board, Row),
    % replace the Y-th element of the row with Val
    set_list_element(Row, Y, Val, NewRow),
    % replace the X-th element of the board with NewRow
    set_list_element(Board, X, NewRow, NewBoard).

% Define the predicate set_list_element/4, which takes four arguments:
%   - List: the list to modify
%   - Index: the index of the element to set
%   - Val: the new value of the element
%   - NewList: the new list after setting the element
set_list_element(List, Index, Val, NewList) :-
    % split the list into two parts: before Index and after Index
    split_at(Index, List, Before, After),
    % append the parts back together, with Val in between
    append(Before, [Val|After], NewList).

% Define the predicate split_at/3, which takes three arguments:
%   - Index: the index at which to split the list
%   - List: the list to split
%   - Parts: a pair of lists representing the parts of the list before and after the split
split_at(Index, List, Before, After) :-
    split_at(Index, List, Before, After, 0).

split_at(_, [], [], [], _).
split_at(Index, [H|T], Before, After, Count) :-
    (Count =:= Index ->
     Before = [], After = [H|T]
    ;
     NewCount is Count + 1,
     split_at(Index, T, NewBefore, After, NewCount),
     Before = [H|NewBefore]
    ).

% Define the predicate print_board/1, which takes one argument:
%   - Board: the board to print (represented as a list of lists of integers)
print_board(Board) :-
    maplist(writeln, Board).