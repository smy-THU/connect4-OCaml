
val get_point : int -> int -> int array -> int array array -> int -> int -> int -> int -> int * int
(** [m n top board last_x last_y no_x no_y] get the place of the next step of our agent.
    @param m The number of rows in the board.
    @param n The number of columns in the board.
    @param top The valid index of each column of this state
    @param board The game board represented as a 2D array
    @param last_x The row index of the last move (of the player).
    @param last_y The column index of the last move (of the player).
    @param no_x The row index of the place that cannot be placed (randomly setted by the game when start).
    @param no_y The column index of the place that cannot be placed (randomly setted by the game when start).
    @return (x, y) The piece place of the agent in this move.*)