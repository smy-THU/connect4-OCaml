open Printf

type point = int * int

type t = {
  mutable player : bool;
  mutable next_choice : int;
  board : int array array;
  top : int array;
  h: int;
  w: int;
  ban_x: int;
  ban_y: int;
  mutable last_put : point;
}


let create_state player height width ban_x_val ban_y_val =
  let board = Array.make_matrix height width 0 in
  let top = Array.make width height in
  if ban_x_val = height - 1 then top.(ban_y_val) <- height - 1;
  {
    player;
    next_choice = 0;
    board;
    top;
    last_put = (-1, -1);
    h = height;
    w = width;
    ban_x = ban_x_val;
    ban_y = ban_y_val;
  }

let copy_state state =
  {
    player = state.player;
    next_choice = state.next_choice;
    board = Array.map Array.copy state.board;
    top = Array.copy state.top;
    last_put = state.last_put;
    h = state.h;
    w = state.w;
    ban_x = state.ban_x;
    ban_y = state.ban_y;
  }

let next_state state x y =
  let new_state = copy_state state in
  new_state.player <- not state.player;
  new_state.board.(x).(y) <- if state.player then 1 else 2;
  new_state.top.(y) <-
    if x - 1 = state.ban_x && y = state.ban_y then x - 1 else x;
  new_state.next_choice <- 0;
  new_state.last_put <- (x, y);
  (* Update next_choice based on top array *)
  for i = 0 to state.w - 1 do
    if new_state.top.(i) = 0 then new_state.next_choice <- new_state.next_choice + 1
  done;
  new_state

let random_put state =
  let valid_columns =
    Array.to_list (Array.mapi (fun i t -> if t > 0 then Some i else None) state.top)
    |> List.filter_map Fun.id
  in
  match valid_columns with
  | [] -> (-1, -1)
  | cols ->
      let col = List.nth cols (Random.int (List.length cols)) in
      (state.top.(col) - 1, col)

let next_choice_state state =
  if state.next_choice = state.w then None
  else
    let new_state = next_state state (state.top.(state.next_choice) - 1) state.next_choice in
    (* Prepare for next choice *)
    let find_next_choice () =
      if state.next_choice < state.w && state.top.(state.next_choice) = 0 then
        state.next_choice <- state.next_choice + 1;
      if state.next_choice = state.w then None else Some new_state
    in
    find_next_choice ()

let default_policy state =
  let state = copy_state state in
  let rec loop state = 
    let (x, y) = random_put state in
    if x = -1 then 0 (* tie *)
    else
      let new_board = Array.copy state.board in
      new_board.(x).(y) <- (if state.player then 1 else 2);
      let new_top = Array.copy state.top in
      new_top.(y) <- (if x - 1 = state.ban_x && y = state.ban_y then x - 1 else x);
      if (state.player && Judge.machine_win x y state.h state.w new_board) || (not state.player && Judge.user_win x y state.h state.w new_board) then
       if state.player then 1 else -1 (* Win or loss *)
     else
       (* Switch player and continue simulation *)
       let new_state = copy_state state in
       new_state.player <- not state.player;
       loop new_state
  in
  loop state




let print_state state =
  Array.iteri
    (fun i row ->
      Array.iteri
        (fun j cell ->
          if cell = 0 then
            if i = state.ban_x && j = state.ban_y then printf "O "
            else printf ". "
          else if cell = 1 then printf "P "
          else printf "F ")
        row;
      printf "\n")
    state.board