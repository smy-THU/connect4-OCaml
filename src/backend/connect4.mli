(** A Connect4 game module interface *)

(** The type representing a player, where 1 is Player 1 and 2 is Player 2. *)
type player_t = int

(** The type representing a point on the board as (row, column). *)
type point_t = int * int

(** The type representing the game board, which is a 2D array of integers. 
    0 represents an empty cell, 1 represents Player 1's piece, and 2 represents Player 2's piece. *)
type board_t = int array array

(** The type representing an action, which is the index of the column where a player drops a piece. *)
type action = int

(** The type representing the state of the game. *)
type state = {
  board : board_t;        (** The game board. *)
  current_player : player_t;  (** The current player's turn. *)
  h : int;                (** The height of the board. *)
  w : int;                (** The width of the board. *)
  last_move : point_t;    (** The last move made, or (-1, -1) if no move has been made. *)
}

(** Create the initial game state. 
    @param h The height of the board (must be between 6 and 12).
    @param w The width of the board (must be between 6 and 12).
    @param player The starting player (must be 1 or 2).
    @return The initial state of the game.
    @raise Failure if the board size or player is invalid.
*)
val initial_state : int -> int -> player_t -> state

(** Check if the board is full (no empty cells in the top row). 
    @param board The game board.
    @return [true] if the board is full, [false] otherwise.
    @raise Failure if the board is invalid.
*)
val is_full : board_t -> bool

(** Check if the board is empty (no pieces on the bottom row). 
    @param board The game board.
    @return [true] if the board is empty, [false] otherwise.
    @raise Failure if the board is invalid.
*)
val is_empty : board_t -> bool

(** Check if the given player has won the game. 
    @param board The game board.
    @param player The player to check (1 or 2).
    @return [true] if the player has won, [false] otherwise.
*)
val check_winner : board_t -> player_t -> bool

(** Check if the game has been won using the last move. 
    @param state The current game state.
    @return [true] if the last move resulted in a win, [false] otherwise.
*)
val check_winner_with_last : state -> bool

(** Check if the game is in a terminal state (either a win or a full board). 
    @param state The current game state.
    @return [true] if the game is over, [false] otherwise.
*)
val is_terminal : state -> bool

(** Evaluate the current state of the game. 
    @param state The current game state.
    @return [1.0] if Player 1 wins, [-1.0] if Player 2 wins, [0.0] otherwise.
*)
val evaluate : state -> float

(** Generate a list of valid actions (columns that are not full). 
    @param state The current game state.
    @return A list of column indices where pieces can be dropped.
*)
val generate_actions : state -> action list

(** Apply an action to the game state. 
    @param state The current game state.
    @param action The column index where the piece is to be dropped.
    @return A new game state after the action is applied.
    @raise Failure if the column index is invalid or the column is full.
*)
val apply_action : state -> action -> state
