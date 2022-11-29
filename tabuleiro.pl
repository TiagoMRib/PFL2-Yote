
Casa(X, Y, Vazia).
Casa(X,Y, Branca).
Casa(X,Y, Preta).

CasaToString(casa(_,_,Vazia), " ").
CasaToString(casa(_,_,Branca), "+").
CasaToString(casa(_,_,Preta), "*").

%RowToString([Casa|Mais casas], []):-
%    CasaToString(Casa, Rep)
    



showBoard(6, []).
showboard(0, []):-
    write("  |1|2|3|4|5|6|").

showBoard(NumLine, [Line|MoreLines]):-
    format("~d |~p|~p|~p|~p|~p|~p|", [NumLine, Line]),
    Next is NumLine + 1,
    showBoard(Next, MoreLines).