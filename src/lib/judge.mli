val user_win : int -> int -> int -> int -> int array array -> bool
(** [user_win x y m n board] checks if the user has won the game.
    @param x The row index of the last move.
    @param y The column index of the last move.
    @param m The number of rows in the board.
    @param n The number of columns in the board.
    @param board The game board represented as a 2D array.
    @return [true] if the user has won, [false] otherwise. *)

val machine_win : int -> int -> int -> int -> int array array -> bool
(** [machine_win x y m n board] checks if the machine has won the game.
    @param x The row index of the last move.
    @param y The column index of the last move.
    @param m The number of rows in the board.
    @param n The number of columns in the board.
    @param board The game board represented as a 2D array.
    @return [true] if the machine has won, [false] otherwise. *)


val check_win : int -> int -> int -> int -> int array array -> int -> bool

val is_tie : int array -> bool
(** [is_tie top] checks if the game is a tie.
    @param top An array representing the topmost filled position of each column.
    @return [true] if the game is a tie, [false] otherwise. *)
