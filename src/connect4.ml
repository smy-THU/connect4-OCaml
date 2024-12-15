[@@@ocaml.warning "-27"]
module type Game = sig
  type state
  type action

  val initial_state : int -> int -> state
  val is_terminal : state -> bool
  val evaluate : state -> float
  val generate_actions : state -> action list
  val apply_action : state -> action -> state
end

type player_t = int (* 1 for Player1, 2 for Player2 *)

type point_t = int * int

type board_t = int array array (* Flexible rows x cols board *)

type action = int

type state = {
  board : board_t;
  current_player : player_t; (* Player1 or Player2 *)
  h : int;
  w : int;
  last_move : point_t;
}


(* Initialize an empty board with specified dimensions *)
let empty_board rows cols: board_t = 
  Array.make_matrix rows cols 0


(* Create the initial state with specified dimensions *)
let initial_state (h:int) (w:int) (player:player_t) : state = {
  board = empty_board h w;
  current_player = player;
  h;
  w;
  last_move = (-1, -1);
}

(* Check if the board is full *)
let is_full (board : board_t) : bool =
  Array.for_all (fun col -> col.(0) <> 0) board

let is_empty (board : board_t) : bool =
  let h = Array.length board in
  Array.for_all (fun col -> (col.(h-1) <> 1 && col.(h-1) <> 2)) board

let check_winner (board : board_t) (player : player_t) : bool =
  Judge.check_win_full board player

let check_winner_with_last (state:state) : bool =
  if state.last_move = (-1, -1) then false
  else 
    let (x, y) = state.last_move in
    let last_player = 3 - state.current_player in
    let h = Array.length state.board in
    let w = if h > 0 then Array.length state.board.(0) else 0 in
    Judge.check_win x y h w state.board last_player

(* Check if the state is terminal *)
let is_terminal (state : state) : bool =
  if is_empty state.board then 
    false
  else
    is_full state.board || check_winner_with_last state

(* Evaluate the board: return +1 for Player1 win, -1 for Player2 win, 0 otherwise *)
let evaluate (state : state) : float =
  if check_winner_with_last state then
    if state.current_player = 1 then 1.0 (*last_player player2 wins*)
    else -1.0 (*last_player player1 wins*)
  else 0.0

(* Generate a list of valid actions (columns that are not full) *)
let generate_actions (state : state) : action list =
  List.filter (fun col -> state.board.(0).(col) = 0) (List.init state.w (fun x -> x))

(* Apply an action to the board *)
let apply_action (state : state) (action : action) : state =
  if action < 0 || action >= state.w then
    failwith "Invalid column index";
  
  let new_board = Array.map Array.copy state.board in

  if new_board.(0).(action) = 1 || new_board.(0).(action) = 2 then
    failwith "Column is full, no space to drop";

  let rec drop row : point_t =
    if row = state.h || new_board.(row).(action) <> 0 then (
      new_board.(row - 1).(action) <- state.current_player;
      (row - 1, action)
    )
    else
      drop (row + 1)
  in

  let move = drop 0 in
  {
    board = new_board;
    current_player = 3 - state.current_player; (*switch player*)
    h = state.h;
    w = state.w;
    last_move = move;
  }