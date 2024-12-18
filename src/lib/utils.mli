(** Types representing the Connect4 game elements *)
type player_t = int
(** [player_t] represents a player in the game. Possible values:
    - 1: Player1
    - 2: Player2 *)

type point_t = int * int
(** [point_t] represents a coordinate (row, column) on the game board. *)

type board_t = int array array
(** [board_t] represents the game board as a 2D array of integers. *)

type action = int
(** [action] represents a column index where a move can be made. *)

(** [get_h board] returns the number of rows (height) in the board.
    @param board the game board
    @return the number of rows in the board *)
val get_h : board_t -> int

(** [get_w board] returns the number of columns (width) in the board.
    @param board the game board
    @return the number of columns in the board
    @raise Failure if the board is invalid or empty *)
val get_w : board_t -> int

(** [point_is_in point board] checks if a given point is within the bounds of the board.
    @param point the coordinate (row, column) to check
    @param board the game board
    @return true if the point is within the bounds, false otherwise *)
val point_is_in : point_t -> board_t -> bool

(** [empty_board rows cols] creates an empty game board with the given dimensions.
    All cells are initialized to 0.
    @param rows the number of rows in the board
    @param cols the number of columns in the board
    @return a new empty board *)
val empty_board : int -> int -> board_t

(** [switch_player player] switches the current player to the other player.
    @param player the current player (1 or 2)
    @return the other player
    @raise Failure if the provided player is invalid *)
val switch_player : player_t -> player_t
