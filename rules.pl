



canMove(X, Y, Up):- 
    Y > 1,
    Next is Y - 1,
    casa(X, Next, Vazia).

canMove(X, Y, Up):- 
    Y > 1, 
    Next is Y - 1,
    casa(X, Next, _).


canMove(X, Y, Down):-
    Y < 5, 
    Next is Y + 1,
    casa(X, Next, Vazia).

canMove(X, Y, Left):- 
    X > 1, 
    Next is X - 1,
    casa(Next, Y, Vazia).

canMove(X, Y, Right):- 
    X < 6, 
    Next is X + 1,
    casa(Next, Y, Vazia).