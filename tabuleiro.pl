:- use_module(library(lists)).

create_board(GameBoard):-
    create_empty_board(5, 6, GameBoard).

% creates and returns the empty side of the board
create_empty_board(Rows, Columns, Result):-
    create_row(Columns, 0, EmptyRow),
    aux_create_empty_board(Rows, EmptyRow, [], Result).

% auxiliar function that creates and returns the empty side of the board
aux_create_empty_board(Size, EmptyRow, CurrentBoard, Result):-
    Size =:= 1,
    append(CurrentBoard, [EmptyRow], Result).

aux_create_empty_board(Size, EmptyRow, CurrentBoard, Result):-
    Size > 1,
    append(CurrentBoard, [EmptyRow], NewBoard),
    NewSize is Size - 1,
    aux_create_empty_board(NewSize, EmptyRow, NewBoard, Result).

% creates and returns a row with <Size> elements of a fiven <Type>
create_row(Size, Type, Result):-
    aux_create_row(Size, Type, [], Result).

% auxiliar function that creates and returns a row with <Size> elements of a fiven <Type>
aux_create_row(0, _, _, []).

aux_create_row(Size, Type, CurrentRow, Result):-
    Size =:= 1,
    append(CurrentRow, [Type], Result).

aux_create_row(Size, Type, CurrentRow, Result):-
    Size > 1,
    append(CurrentRow, [Type], NewCurrentRow),
    NewSize is Size - 1,
    aux_create_row(NewSize, Type, NewCurrentRow, Result).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    Changes an element on the board   &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&

% changes an element on the board given by the position <Row> and <Col>, and change it to the element <NewElement>
change_board_element(GameBoard, Row, Col, NewElement, NewGameBoard):-
    aux_change_board_element(GameBoard, 1, Col, Row, NewElement, [], NewGameBoard).  % Tava trocado o Row e o Col na lógica


% auxiliar function that changes an element on the board
aux_change_board_element([], _, _, _, _, SavedBoard, NewGameBoard):-
    NewGameBoard = SavedBoard.

aux_change_board_element([Row|Rest], CurrentRowNum, RowNum, ColNum, NewElement, SavedBoard, NewGameBoard):-
    \+ CurrentRowNum = RowNum,
    NewRowNum is CurrentRowNum + 1,
    append(SavedBoard, [Row], NewSavedBoard),
    aux_change_board_element(Rest, NewRowNum, RowNum, ColNum, NewElement, NewSavedBoard, NewGameBoard).

aux_change_board_element([Row|Rest], CurrentRowNum, RowNum, ColNum, NewElement, SavedBoard, NewGameBoard):-
    CurrentRowNum = RowNum,
    NewRowNum is CurrentRowNum + 1,
    change_row_element(Row, ColNum, NewElement, NewRow),
    append(SavedBoard, [NewRow], NewSavedBoard),
    aux_change_board_element(Rest, NewRowNum, RowNum, ColNum, NewElement, NewSavedBoard, NewGameBoard).

% changes an element on the row given by the position <ColumnNum>, and change it to the element <NewElement>
change_row_element(Row, ColumnNum, NewElement, NewRow):-
    aux_change_row_element(Row, 1, ColumnNum, NewElement, [], NewRow).

% auxiar function that changes an element on the row
aux_change_row_element([], _, _, _, SavedRow, NewRow):-
    NewRow = SavedRow.

aux_change_row_element([Cell|Rest], CurrentCol, ColNum, NewElement, SavedRow, NewRow):-
    \+ CurrentCol = ColNum,
    NewColNum is CurrentCol + 1,
    append(SavedRow, [Cell], NewSavedRow),
    aux_change_row_element(Rest, NewColNum, ColNum, NewElement, NewSavedRow, NewRow).

aux_change_row_element([_|Rest], CurrentCol, ColNum, NewElement, SavedRow, NewRow):-
    CurrentCol = ColNum,
    NewColNum is CurrentCol + 1,
    append(SavedRow, [NewElement], NewSavedRow),
    aux_change_row_element(Rest, NewColNum, ColNum, NewElement, NewSavedRow, NewRow).


% Define the predicate empty/2, which takes two arguments:
%   - Board: the current state of the board (represented as a list of lists of simbols)
%   - Pos: the position of the piece to be evaluated (represented as a pair of integers)
empty(Board, (X,Y)):-
    write('Checking if element at coordinates ('), write(X), write(', '), write(Y), write(') is empty...'), nl,
    nth1(Y, Board, Row),
    nth1(X, Row, 0).


% Define the predicate pos/3, which takes three arguments:
%   - Board: the current state of the board (represented as a list of lists of simbols)
%   - Pos: the position of the piece to be evaluated (represented as a pair of integers)
%   - Simbol: the simbol in that position
pos(Board, (X,Y), Simbol):-
    nth1(Y, Board, Row),
    nth1(X, Row, Simbol).


% Define the predicate inside_board/2, which takes two arguments:
%   - Board: the current state of the board (represented as a list of lists of simbols)
%   - Pos: the position to be evaluated (represented as a pair of integers)
inside_board(Board, (X,Y)):-
    length(Board, NumRows),
    X > 0,
    X =< NumRows,
    nth1(X, Board, Row),
    length(Row, NumCols),
    Y > 0,
    Y =< NumCols.
