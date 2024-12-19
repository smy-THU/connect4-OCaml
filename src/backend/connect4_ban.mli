module type Game = sig
  type state
  type action

  val is_terminal : state -> bool
  val evaluate : state -> float
  val generate_actions : state -> action list
  val apply_action : state -> action -> state
end

type player_t = int (* 1 for Player1, 2 for Player2 *)
type point_t = int * int
type board_t = int array array (* Flexible rows x cols board *)
type action = int

(* Type representing the game state *)
type state = {
  board : board_t; (* The current state of the board *)
  current_player : player_t; (* The player whose turn it is *)
  h : int; (* Height (number of rows) of the board *)
  w : int; (* Width (number of columns) of the board *)
  last_move : point_t; (* The last move made (row, column) *)
  ban_point : point_t; (* The position of the ban point (if any) *)
}

(* Initialize an empty board with specified dimensions *)
(* rows: The number of rows in the board *)
(* cols: The number of columns in the board *)
(* Returns: An empty board represented as a 2D array of integers *)
val empty_board : int -> int -> board_t

(* Create the initial state with specified dimensions *)
(* h: The height (number of rows) of the board *)
(* w: The width (number of columns) of the board *)
(* player: The player to start the game (1 for Player1, 2 for Player2) *)
(* ban_point: The position of the ban point (row, column) *)
(* Returns: The initial game state with an empty board, the given player, and the ban point placed *)
val initial_state : int -> int -> player_t -> point_t -> state

(* Check if the board is full (no more valid moves) *)
(* board: The current game board represented as a 2D array *)
(* Returns: true if the board is full, false otherwise *)
val is_full : board_t -> bool

(* Check if the bottom-most row of the board is empty *)
(* board: The current game board represented as a 2D array *)
(* Returns: true if the bottom-most row is empty (no pieces in it), false otherwise *)
val is_empty : board_t -> bool

(* Function to check if the current player has won the game by checking the board *)
(* board: The current game board represented as a 2D array *)
(* player: The player to check for victory (1 for Player1, 2 for Player2) *)
(* Returns: true if the given player has won the game, false otherwise *)
val check_winner : board_t -> player_t -> bool

(* Check if the game state is terminal (end of game) *)
(* state: The current game state *)
(* Returns: true if the game is in a terminal state (either full board or a player has won), false otherwise *)
val is_terminal : state -> bool

(* Function to evaluate the game state: returns 1.0 for Player1 win, -1.0 for Player2 win, 0.0 for draw or no winner *)
(* state: The current game state *)
(* Returns: A float score based on the game outcome:
        +1.0 for Player1 win, -1.0 for Player2 win, 0.0 for draw or no winner *)
val evaluate : state -> float

(* Generate a list of valid actions (columns to drop a piece in) *)
(* state: The current game state *)
(* Returns: A list of valid actions (column indices where a piece can be dropped) *)
val generate_actions : state -> action list

(* Function to apply an action (drop a piece in the given column) and return the updated state *)
(* state: The current game state *)
(* action: The action to apply, which is a column index to drop the piece in *)
(* Returns: The updated game state after applying the action *)
val apply_action : state -> action -> state

(* Function to check if the last move resulted in a win *)
(* state: The current game state *)
(* Returns: true if the last player (who made the last move) has won, false otherwise *)
val check_winner_with_last : state -> bool
