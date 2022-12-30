:- consult('tabuleiro.pl').

% logo/0, prints the game logo.
logo:-
    nl,nl,nl,nl,
    write('********************************************'),nl,
    write('*                                    @     *'),nl,
    write('*                                   @      *'),nl,
    write('*   @      @  @@@@@@   @@@@@@@@ @@@@@@@@   *'),nl,
    write('*    @    @  @      @     @@    @          *'),nl,
    write('*     @  @  @        @    @@    @          *'),nl,
    write('*      @@   @        @    @@    @@@@@      *'),nl,
    write('*      @    @        @    @@    @          *'),nl,
    write('*     @      @      @     @@    @          *'),nl,
    write('*    @        @@@@@@      @@    @@@@@@@@   *'),nl,
    write('*                                          *'),nl,
    write('********************************************'),nl.

% menu_formater(+Info) prints the information of to be used within our menu using format.
menu_formater(Info):-
    format('~n~`*t ~p ~`*t~30|~n', [Info]).
  
  % option(+Option, +Details) prints the selected option menu-like with aditional details using format
option(Option, Details):-
  format('*~t~d~t~5|~t~a~t~20+~t*~30|~n',[Option, Details]).
  
  % menu/0 presents a user friendly menu for game options.
menu:-
  logo,
  menu_formater('MENU'),
  option(1, 'Player x Player'),
  option(2, 'Player x Computer'),
  option(3, 'Intructions'),
  option(0, 'Exit'),
  write('******************************'),nl,
  read(Number),
  menu_option(Number).

% menu_option(+Option)
% Sub-Menus related to option selected on the main menu
% Exit Main Menu
menu_option(0):-
    logo,
    write('Thank you for playing!'),
    fail.

menu_option(1):-
    create_board(GameBoard), nl,
    %set_pieces(white, 12),
    %set_pieces(black, 12),
    %Color = white,
    %Human = true,
    play_game(GameBoard).
    %play_game(GameBoard,Color,Human).

menu_option(2):-
    menu_formater('Choose difficulty'),
    option(1, 'Easy'),
    option(2, 'Hard'),
    write('******************************'),nl.