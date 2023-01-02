# Yoté

Filipe Rodrigues Fonseca - up202003474 (50%)

Tiago André Monteiro Ribeiro - up202007589 (50%)


## Instalattion and Execution

To play the game you first need to have SICStus Prolog 4.7 or a newer version currently installed on your machine plus the folder with the source code. 

Next, on the SICStus interpreter, consult all the files located in the source root directory, for an example:

    ?- consult('./game.pl').

If you're using Windows, you can also do this by selecting `File` -> `Consult...` and selecting the file.
    
Finally, consult the file game.pl and run the the predicate start_game/0 to enter the game main menu: 

    ?- play.

You will be presented with the menu after the execution.

## Game Description
### Board

The board is a 6x5 squared board, with a total of 30 spaces for pieces. The board starts off empty.

### Gameplay
The players are Black and White, with White going first. Each has 12 of their color.

On each turn, a player can take one of the following actions:

- Drop a stone of their color onto an empty square.
- Shift a stone of their color already on a board to its left/right/up/down if the new square is available.
- Eat an adversary piece by moving two spaces to the left/right/up/down if that square is empty and the square that was jumped on has a piece from the other player. You must also choose another piece of the opposite color to remove from the board.

The winner is the first to eat all adversary pieces.


## Game Logic
### Game state internal representation

The **game state** is composed of the **current state for the board**, the **colour of the current player** and the **number of pieces** yet to be played by both players.

- The **board** is represented by a **list of lists**: each list is a line on the board and each element in the list is a board cell. A **cell** is represented by **w** if it has a white piece, **b** for a black piece and **0** for an empty space.
- The **colour** of the **current player** is an athom which takes the value of **w** if White is playing or **b** is Black is playing.
- The **number of pieces** each player still has is represented by two atoms who take the value of each players's stones.

#### Initial state (6x5)

```
[[0,0,0,0,0,0],
[0,0,0,0,0,0],
[0,0,0,0,0,0],
[0,0,0,0,0,0],
[0,0,0,0,0,0]], 12, 12, w
```

![Initial State](./img/initialState.png)

#### Intermediate state (11x11)

```
[[0,0,b,0,0,0],
[0,w,0,0,0,0],
[0,w,0,0,0,0],
[0,w,0,0,0,0],
[0,b,0,0,0,0]], 9, 8, w
```

![Intermediate State](./img/intermediateState.png)

#### Final state (11x11)


```
[[0,0,0,0,0,0],
[0,w,0,0,0,0],
[0,w,0,0,0,0],
[0,0,0,0,0,0],
[0,0,0,0,0,0]], 2, 0, w
```

![Final State](./img/finalState.png)

### Game state visualization

The predicates for the game visualization are separated into two different modules: `menu` and `game`, representing the menu and game state's interaction and display:

- The `menu` module has a few helper predicates meant to reutilize the code and ease the creation of new menu sections. The main menu predicates are created using **menu/0** and **menu_option/1** ( *menu.pl* ).

![](./img/menu.png)

- The `game` module has the main predicates **play_game/4** and **move_chosen/8**. All the user interactions are validated (either in the I/O or move execution predicates) and inform the players of possible errors before asking for another input.

- The game board is displayed to the user by the predicate **displayBoard/1**:

        displayBoard(+Board)

    It uses other support predicates like **display_first_row_cells/1**, which displays the columns header, and **display_middle_row_cells/1**, whichs prints a line of the board.

![](./img/game.png)

### Move execution

The strategy for validating and applying a move was to create the predicate **move/5**:

    move(+GameState, +Pos, +direction, +Color, -NewGameState)

The predicate will fail if the given move is not valid.

Since the game has **three types of moves** (placing a piece, shifting to the side or eating a pice), the predicate move needed to have a **rule for each type**.

The first move is applied with **place/4**. The second with **move/5** and the third with **move_piece_to_eat/5**.
    
### Game Over



### List of valid moves:

To ensure that a move is executable the predicate **valid_moves/4** verifies all the conditions mentioned in the move execution section.
    
    valid_moves(+GameState, +Pos, +Result, +Player, -Moves)

Using **findall** we are able to find all valid moves a player can make on a given turn.

### Game state evaluation



### Computer move


## Conclusion

The board game *Yoté* was successfully implemented in the SicStus Prolog 4.7 language. The game can be played Player vs Player, Player vs Computer or Computer vs Computer (with the same or different levels).

One of the difficulties on the project was displaying an intuitive board in the SicStus terminal, which has a very limited set of characters and customization. This limits the game design, since it's hard to display black/white cells and black/white pieces at the same time. This issue was mitigated by using the characters 'b' and 'w', which isn't ideal.

Another limitation of the game is the bot's algorithm, which only looks at an immediate play, greatly reducing its cleverness. A possible improvement would be to implement another level with a better algorithm.

### Sources
- https://www.di.fc.ul.pt/~jpn/gv/yote.htm
