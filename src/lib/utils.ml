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

let get_h (board:board_t) : int =
  Array.length board

let get_w (board: board_t) : int = 
  if Array.length board < 1 then
    failwith "board invalid"
  else
    Array.length board.(0)

let point_is_in (point:point_t) (board:board_t) : bool =
  let h = get_h board in
  if h < 1 then false
  else
    let w = get_w board in
    match point with
    | (x, y) -> 
      if x<0 || x>=h then false
      else if y<0 || y>=w then false
      else true


(* Initialize an empty board with specified dimensions *)
let empty_board rows cols: board_t = 
  Array.make_matrix rows cols 0