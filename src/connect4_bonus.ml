[@@@ocaml.warning "-27"]
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

type state = {
  board : board_t;
  current_player : player_t; (* Player1 or Player2 *)
  h : int;
  w : int;
  last_move : point_t;
  ban_point : point_t;
  bonus_point : point_t;
  get_bonus : int; (* 0 for not getting bonus yet, 1 for has getting bonus and is placing the ban, 2 for has placed ban point*)
}



(* Create the initial state with specified dimensions *)
let initial_state (h:int) (w:int) (player:player_t) (bonus_point : point_t): state = 
  let new_board = Utils.empty_board h w in
  if h < 6 || h > 12 || w < 6 || w > 12 then 
    failwith "board size invalid"
  else if player <> 1 && player <> 2 then
    failwith "player not valid when initial state"
  else if not (Utils.point_is_in bonus_point new_board) then
    failwith "bonus_point is not in board"
  else
    let (x, y) = bonus_point in
    new_board.(x).(y) <- -2; 
    (* bonus_point is -2 on the board*)
  {
    board = new_board;
    current_player = player;
    h;
    w;
    last_move = (-1, -1);
    ban_point = (-1, -1); (* initial state when ban ponit is not placed yet*)
    bonus_point;
    get_bonus = 0; (* when initial, the bonus point has not been gotten by any player*)
  }

(* Check if the board is full, using the state *)
let is_full_state (state : state) : bool =
  let h = Utils.get_h state.board in
  if h < 6 then 
    failwith "the board is invalid."
  else
    match state.get_bonus with
    | 0 -> Array.for_all (fun ele -> ele <> 0 && ele <> -2) state.board.(0)
    | 1 -> false
    | 2 -> (* this is the situation when the ban point has been put on the board.*)
      let w = Utils.get_w state.board in
      let all_cols = (List.init w (fun x -> x)) in
      let ban_top_ls = List.filter (fun col -> state.board.(0).(col) = -1) all_cols in
      if List.length ban_top_ls = 0 then
        Array.for_all (fun ele -> ele <> 0 && ele <> -2) state.board.(0)
      else
        let full_ban_ls = List.filter (fun col -> state.board.(1).(col) = 1 || state.board.(1).(col) = 2) ban_top_ls in
        let is_full_col (col:int) : bool =
          match state.board.(0).(col) with
          | 0 -> false
          | 1 -> true
          | 2 -> true
          | -1 -> if (List.mem col full_ban_ls) then true else false
          | _ -> failwith "invalid point value on the board."
        in
        List.for_all is_full_col all_cols
      | _ -> failwith "invalid get_bonus status in this state"

let is_empty (board : board_t) : bool =
  let h = Array.length board in
  if h < 1 then 
    failwith "the board is invalid."
  else
    Array.for_all (fun col -> col <> 1 && col <> 2) board.(h-1)

let check_winner (board : board_t) (player : player_t) : bool =
  Judge.check_win_full board player

let check_winner_with_last (state:state) : bool =
  (* the state is initial state*)
  if state.last_move = (-1, -1) then
    false
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
    is_full_state state || check_winner state.board state.current_player || check_winner state.board (Utils.switch_player state.current_player)

(* Evaluate the board: return +1 for Player1 win, -1 for Player2 win, 0 otherwise *)
let evaluate (state : state) : float =
  if check_winner_with_last state then
    if state.current_player = 1 then 1.0 (*last_player player2 wins*)
    else -1.0 (*last_player player1 wins*)
  else 0.0

(* Generate a list of valid actions (columns that are not full) *)
let generate_actions (state : state) : action list =
  (* the list consists of the column number of ban_points on the 0th row*)
  let all_actions = List.init state.w (fun x -> x) in
  match state.get_bonus with
  | 0 ->
    List.filter (fun col -> state.board.(0).(col) = 0) all_actions
  | 1 ->
      (* in this situation, the player can put the ban point to any col that is not full*)
      let not_full (col:int) : bool =
        state.board.(0).(col) = 0
      in
      List.filter not_full all_actions
  | 2 ->
    (* this is the situation when the ban_point has been put onto the board.*)
    let ban_top_ls = List.filter (fun col -> state.board.(0).(col) = 1) all_actions in

    (* normal situation: no ban point on the 0th row*)
    if List.length ban_top_ls = 0 then
      List.filter (fun col -> state.board.(0).(col) = 0) all_actions
    else
      (* ban point on 0th row columns which has empty space under, which means actions is valid here*)
      let empty_ban_ls = List.filter (fun col -> state.board.(1).(col) = 0) ban_top_ls in
      let all_actions = List.init state.w (fun x -> x) in
      let is_valid (col:int) : bool =
        state.board.(0).(col) = 0 ||
        (List.mem col ban_top_ls && List.mem col empty_ban_ls)
      in
      List.filter is_valid all_actions
  | _ -> failwith "invalid get_bonus value"


  

(* Apply an action to the board *)
let apply_action (state : state) (action : action) : state =
  if action < 0 || action >= state.w then
    failwith "Invalid column index";
  
  let new_board = Array.map Array.copy state.board in

  if new_board.(0).(action) = 1 || new_board.(0).(action) = 2 then
    failwith "Column is full, no space to drop";

  let rec drop_wo_mutation row : point_t =
    if row = state.h || new_board.(row).(action) = 1 || new_board.(row).(action) = 2 then (
      (* new_board.(row - 1).(action) <- state.current_player; *)
      (row - 1, action)
    )
    (* deal with ban point*)
    else if new_board.(row).(action) = -1 then (
      (* if no space under ban point*)
      if row = (state.h-1) || new_board.(row+1).(action) <> 0 then (
        (* new_board.(row - 1).(action) <- state.current_player; *)
        (row - 1, action)
      )
      else
        drop_wo_mutation (row + 1)
    )
    else if new_board.(row).(action) = -2 then (
      if row = (state.h-1) || new_board.(row+1).(action) <> 0 then (
        (row, action)
      )
      else
        drop_wo_mutation (row + 1)
    )
    else
      drop_wo_mutation (row + 1)
  in

  let (move_x, move_y) = drop_wo_mutation 0 in
  match state.get_bonus with
  | 0 -> 
    if new_board.(move_x).(move_y) = -2 then(
      (* this player get the bonus,*)
      new_board.(move_x).(move_y) <- state.current_player;
      {
        board = new_board;
        current_player = state.current_player; (*do not switch player!*)
        h = state.h;
        w = state.w;
        last_move = (move_x, move_y);
        ban_point = state.ban_point;
        bonus_point = state.bonus_point;
        get_bonus = 1;
      }
    )
    else(
      new_board.(move_x).(move_y) <- state.current_player;
      {
        board = new_board;
        current_player = Utils.switch_player state.current_player; (*switch player!*)
        h = state.h;
        w = state.w;
        last_move = (move_x, move_y);
        ban_point = state.ban_point;
        bonus_point = state.bonus_point;
        get_bonus = 0;
      }
    )
  | 1 -> (
    new_board.(move_x).(move_y) <- -1; (* ban point be put into this move place*)
    {
      board = new_board;
      current_player = Utils.switch_player state.current_player; (* switch player!*)
      h = state.h;
      w = state.w;
      last_move = state.last_move; (* NOTICE: last move do not change*)
      ban_point = (move_x, move_y); (* NOTICE: ban point has been put*)
      bonus_point = (-1, -1); (* NOTICE: bonus has been eaten*)
      get_bonus = 2; (* switch to bonus state 2*)
    }
  )
  | 2 -> (
    new_board.(move_x).(move_y) <- state.current_player;
    {
      board = new_board;
      current_player = Utils.switch_player state.current_player; 
      h = state.h;
      w = state.w;
      last_move = (move_x, move_y);
      ban_point = state.ban_point;
      bonus_point = state.bonus_point;
      get_bonus = state.get_bonus; (* remain as 2*)
    }
  )
  | _ -> failwith "invalid get_bonus vlaue"