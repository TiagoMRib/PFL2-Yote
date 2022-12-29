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
change_board_element(Row, Col, NewElement, NewGameBoard):-
    create_board(GameBoard),
    aux_change_board_element(GameBoard, 1, Row, Col, NewElement, [], NewGameBoard).

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