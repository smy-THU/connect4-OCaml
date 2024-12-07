type point = int * int

type t = {
  mutable player : bool; (* true for player, false for machine *)
  mutable next_choice : int; (* Column choice for the next move *)
  board : int array array;
      (* 2D board array where 0 = empty, 1 = player, 2 = machine *)
  top : int array; (* Tracks the topmost unoccupied row in each column *)
  h : int;
  w : int;
  ban_x : int;
  ban_y : int;
  mutable last_put : point; (* Last (x, y) coordinates where a move was made *)
}

val create_state : bool -> int -> int -> int -> int -> t
(** [create_state player height width ban_x ban_y] creates a new game state.
    @param player Indicates if the player starts first.
    @param height The height of the board.
    @param width The width of the board.
    @param ban_x The x-coordinate of the banned cell.
    @param ban_y The y-coordinate of the banned cell.
    @return The initial game state. *)

val copy_state : t -> t
(** [copy_state state] creates a deep copy of the given game state.
    @param state The game state to copy.
    @return A new game state that is a copy of the input state. *)

val next_state : t -> int -> int -> t
(** [next_state state x y] generates the next game state after a move.
    @param state The current game state.
    @param x The row index of the move.
    @param y The column index of the move.
    @return The new game state after the move. *)

val random_put : t -> int * int
(** [random_put state] generates a random valid move.
    @param state The current game state.
    @return A tuple (x, y) representing the row and column of the move. *)

val default_policy : t -> int
(** [default_policy state] simulates the game using a default policy.
    @param state The current game state.
    @return The result of the simulation: 1 for player win, -1 for machine win, 0 for tie. *)

val print_state : t -> unit
(** [print_state state] prints the current game state to the console.
    @param state The current game state. *)

val next_choice_state : t -> t option
(** [next_choice_state state] generates the next game state based on the next choice.
    @param state The current game state.
    @return An option type containing the new game state or None if no valid moves are left. *)
