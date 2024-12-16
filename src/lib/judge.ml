type board_t = int array array
type player_t = int
type point_t = int * int

(* Helper function for horizontal checking *)
let horizontal_win x y n board player =
  let rec left i count =
    if i < 0 || board.(x).(i) <> player then count else left (i - 1) (count + 1)
  in
  let rec right i count =
    if i >= n || board.(x).(i) <> player then count
    else right (i + 1) (count + 1)
  in
  left (y - 1) 1 + right (y + 1) 0 >= 4

(* Helper function for vertical checking *)
let vertical_win x y m board player =
  let rec down i count =
    if i >= m || board.(i).(y) <> player then count else down (i + 1) (count + 1)
  in
  down (x + 1) 1 >= 4

(* Helper function for diagonal checking (left-bottom to right-top) *)
let diagonal_lbrt_win x y m n board player =
  let rec left_down i j count =
    if i >= m || j < 0 || board.(i).(j) <> player then count
    else left_down (i + 1) (j - 1) (count + 1)
  in
  let rec right_up i j count =
    if i < 0 || j >= n || board.(i).(j) <> player then count
    else right_up (i - 1) (j + 1) (count + 1)
  in
  left_down (x + 1) (y - 1) 1 + right_up (x - 1) (y + 1) 0 >= 4

(* Helper function for diagonal checking (left-top to right-bottom) *)
let diagonal_ltrb_win x y m n board player =
  let rec left_up i j count =
    if i < 0 || j < 0 || board.(i).(j) <> player then count
    else left_up (i - 1) (j - 1) (count + 1)
  in
  let rec right_down i j count =
    if i >= m || j >= n || board.(i).(j) <> player then count
    else right_down (i + 1) (j + 1) (count + 1)
  in
  left_up (x - 1) (y - 1) 1 + right_down (x + 1) (y + 1) 0 >= 4

(* General win-checking function *)
let check_win x y m n board player =
  horizontal_win x y n board player
  || vertical_win x y m board player
  || diagonal_lbrt_win x y m n board player
  || diagonal_ltrb_win x y m n board player

(* Specific functions for user and machine *)
let user_win x y m n board = check_win x y m n board 1
let machine_win x y m n board = check_win x y m n board 2

(* Function to check for a tie *)
let is_tie top = Array.for_all (fun t -> t <= 0) top


let check_win_full (board : board_t) (player : player_t) : bool =
  let h = Array.length board in
  let w = if h > 0 then Array.length board.(0) else 0 in
  let check_direction start_row start_col delta_row delta_col =
    let rec loop count row col =
      if count = 4 then true
      else if row < 0 || row >= h || col < 0 || col >= w then false
      else if board.(row).(col) = player then loop (count + 1) (row + delta_row) (col + delta_col)
      else false
    in
    loop 0 start_row start_col
  in
  let directions = [(0, 1); (1, 0); (1, 1); (1, -1)] in
  Array.mapi (fun row line ->
    Array.mapi (fun col _ ->
      List.exists (fun (dr, dc) -> check_direction row col dr dc) directions
    ) line |> Array.exists (fun x -> x)
  ) board |> Array.exists (fun x -> x)

let point_is_in (point:point_t) (board:board_t) : bool =
  let h = Array.length board in
  if h < 1 then false
  else
    let w = Array.length board.(0) in
    match point with
    | (x, y) -> 
      if x<0 || x>=h then false
      else if y<0 || y>=w then false
      else true