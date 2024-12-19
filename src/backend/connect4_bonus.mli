[@@@ocaml.warning "-27"]

module type Game = sig
  type state
  type action

  val is_terminal : state -> bool
  val evaluate : state -> float
  val generate_actions : state -> action list
  val apply_action : state -> action -> state
end

(* Type representing a player (Player 1 or Player 2) *)
type player_t = int (* 1 for Player1, 2 for Player2 *)

(* Type representing a point on the board (row, column) *)
type point_t = int * int

(* Type representing the board as a 2D array of integers *)
type board_t = int array array (* Flexible rows x columns board *)

(* Type representing an action (a column number to drop a piece) *)
type action = int

(* Type representing the game state *)
type state = {
  board : board_t; (* The current state of the board *)
  current_player : player_t; (* The player whose turn it is *)
  h : int; (* Height (number of rows) of the board *)
  w : int; (* Width (number of columns) of the board *)
  last_move : point_t; (* The last move made (row, column) *)
  ban_point : point_t; (* The position of the ban point (if any) *)
  bonus_point : point_t; (* The position of the bonus point *)
  get_bonus : int;
      (* Indicates bonus state: 0 for none, 1 for placing ban, 2 for ban placed *)
}

(* Function to create the initial game state with given dimensions and player *)
(* h: The height (number of rows) of the board *)
(* w: The width (number of columns) of the board *)
(* player: The player to start the game (1 for Player1, 2 for Player2) *)
(* bonus_point: The position of the bonus point (row, column) *)
(* Returns: The initial game state with an empty board, the given player, and the bonus point placed *)
val initial_state : int -> int -> player_t -> point_t -> state

(* Function to check if the board is full (no more valid moves) *)
(* state: The current game state *)
(* Returns: true if the board is full, meaning no more valid moves can be made *)
val is_full_state : state -> bool

(* Function to check if the bottom-most row of the board is empty *)
(* board: The game board represented as a 2D array *)
(* Returns: true if the bottom-most row is empty (no pieces in it), false otherwise *)
val is_empty : board_t -> bool

(* Function to check if the current player has won the game by checking the board *)
(* board: The game board represented as a 2D array *)
(* player: The player to check for victory (1 for Player1, 2 for Player2) *)
(* Returns: true if the given player has won the game, false otherwise *)
val check_winner : board_t -> player_t -> bool

(* Function to check if there is a winner based on the last move *)
(* state: The current game state *)
(* Returns: true if the last move results in a win for the player, false otherwise *)
val check_winner_with_last : state -> bool

(* Function to check if the game has reached a terminal state *)
(* state: The current game state *)
(* Returns: true if the game is in a terminal state (either full board or a player has won), false otherwise *)
val is_terminal : state -> bool

(* Function to evaluate the game state: returns 1.0 for Player1 win, -1.0 for Player2 win, 0.0 for draw or no winner *)
(* state: The current game state *)
(* Returns: A float score based on the game outcome:
      +1.0 for Player1 win, -1.0 for Player2 win, 0.0 for draw or no winner *)
val evaluate : state -> float

(* Function to generate a list of valid actions (columns to drop a piece in) *)
(* state: The current game state *)
(* Returns: A list of valid actions (column indices where a piece can be dropped) *)
val generate_actions : state -> action list

(* Function to apply an action (drop a piece in the given column) and return the updated state *)
(* state: The current game state *)
(* action: The action to apply, which is a column index to drop the piece in *)
(* Returns: The updated game state after applying the action *)
val apply_action : state -> action -> state
