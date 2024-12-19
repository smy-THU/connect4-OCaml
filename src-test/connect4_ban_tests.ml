open OUnit2
open Connect4_ban

(* Helper function to create an initial state for testing *)
let test_initial_state _ =
  let h = 6 in
  let w = 7 in
  let player = 1 in
  let ban_point = (2, 3) in
  let state = initial_state h w player ban_point in
  assert_equal state.board.(2).(3) (-1);
  (* Ban point marked with -1 *)
  assert_equal state.current_player player;
  assert_equal state.h h;
  assert_equal state.w w;
  assert_equal state.last_move (-1, -1);
  assert_equal state.ban_point ban_point

(* Test for is_full function *)
let test_is_full_full_board _ =
  let full_board = Array.make_matrix 6 7 1 in
  assert_equal (is_full full_board) true

let test_is_full_not_full _ =
  let h = 6 in
  let w = 7 in
  let state = initial_state h w 1 (3, 4) in
  assert_equal (is_full state.board) false

let test_is_full_with_ban _ =
  let board_with_ban =
    [|
      [| -1; 2; 0; 1 |];
      (* 1st row: ban point in the first column *)
      [| 2; 1; 0; 2 |];
      (* 2nd row: partially filled *)
      [| 1; 2; 0; 1 |];
      (* 3rd row: partially filled *)
    |]
  in
  assert_equal false (is_full board_with_ban) ~msg:"case 1";

  let board_full_with_ban =
    [|
      [| -1; 2; 1; 1 |];
      (* 1st row: ban point in the first column *)
      [| 2; 1; 2; 1 |];
      (* 2nd row: fully filled *)
      [| 1; 2; 1; 2 |];
      (* 3rd row: fully filled *)
    |]
  in
  assert_equal true (is_full board_full_with_ban) ~msg:"case 2";

  let board_ban_full_column =
    [|
      [| -1; 0; 0; 0 |];
      (* 1st row: ban point in the first column *)
      [| 2; 0; 0; 0 |];
      (* 2nd row: empty columns except under the ban point *)
      [| 1; 0; 0; 0 |];
      (* 3rd row: empty columns except under the ban point *)
    |]
  in
  assert_equal false (is_full board_ban_full_column) ~msg:"case 3";

  let board_full_with_ban =
    [|
      [| -1; 2; 1; 1 |];
      (* 1st row: ban point in the first column *)
      [| 0; 1; 2; 1 |];
      (* 2nd row: fully filled *)
      [| 1; 2; 1; 2 |];
      (* 3rd row: fully filled *)
    |]
  in
  assert_equal false (is_full board_full_with_ban) ~msg:"case 4"

(* Test for is_empty function *)
let test_is_empty_empty_board _ =
  let h = 6 in
  let w = 7 in
  let state = initial_state h w 1 (3, 4) in
  assert_equal (is_empty state.board) true

let test_is_empty_not_empty _ =
  let h = 6 in
  let w = 7 in
  let state = initial_state h w 1 (5, 4) in
  assert_equal (is_empty state.board) true (* even the bottom has a ban_point*)

(* Test for check_winner_with_last function *)
let test_check_winner_with_last_no_winner _ =
  let h = 6 in
  let w = 7 in
  let state = initial_state h w 1 (3, 4) in
  assert_equal (check_winner_with_last state) false

let test_check_winner_with_last _ =
  let h = 6 in
  let w = 7 in
  let state = initial_state h w 1 (4, 3) in
  let state = apply_action state 3 in
  let state = apply_action state 3 in
  let state = apply_action state 4 in
  let state = apply_action state 4 in
  let state = apply_action state 5 in
  let state = apply_action state 5 in
  let state = apply_action state 2 in
  assert_equal (check_winner_with_last state) true

(* Test for is_terminal function *)
let test_is_terminal_terminal _ =
  let h = 6 in
  let w = 7 in
  let state = initial_state h w 1 (3, 4) in
  let state = apply_action state 2 in
  let state = apply_action state 3 in
  let state = apply_action state 2 in
  let state = apply_action state 3 in
  let state = apply_action state 2 in
  let state = apply_action state 3 in
  let state = apply_action state 2 in

  assert_equal (is_terminal state) true

let test_is_terminal_not_terminal _ =
  let h = 6 in
  let w = 7 in
  let state = initial_state h w 1 (3, 4) in
  assert_equal (is_terminal state) false

(* Test for generate_actions function *)
let test_generate_actions_normal _ =
  let h = 6 in
  let w = 7 in
  let state = initial_state h w 1 (3, 4) in
  assert_equal (generate_actions state) [ 0; 1; 2; 3; 4; 5; 6 ]
(* All columns are available *)

let test_generate_actions_with_ban_point _ =
  let h = 6 in
  let w = 7 in
  let state = initial_state h w 1 (2, 3) in
  assert_equal (generate_actions state) [ 0; 1; 2; 3; 4; 5; 6 ]
(* All columns should still be valid, except dropping on (2, 3) *)

(* Test for apply_action function *)
let test_apply_action_valid_move _ =
  let h = 6 in
  let w = 7 in
  let state = initial_state h w 1 (2, 3) in
  let new_state = apply_action state 3 in
  assert_equal new_state.current_player 2;
  assert_equal
    new_state.board.(5).(3)
    1 (* Player 1 drops piece on the 3rd column *)

let test_apply_action_invalid_column _ =
  let h = 6 in
  let w = 7 in
  let state = initial_state h w 1 (2, 3) in
  assert_raises (Failure "Invalid column index") (fun () ->
      apply_action state (-1));
  assert_raises (Failure "Invalid column index") (fun () ->
      apply_action state 7)

let test_apply_action_column_full _ =
  let h = 6 in
  let w = 7 in
  let state = initial_state h w 1 (2, 3) in
  Array.fill state.board.(0) 0 7 1;
  (* making column full *)
  assert_raises (Failure "Column is full, no space to drop") (fun () ->
      apply_action state 3)

let test_apply_action_with_ban_point _ =
  let h = 6 in
  let w = 7 in
  let state = initial_state h w 1 (5, 3) in
  let new_state = apply_action state 3 in
  assert_equal new_state.board.(4).(3) 1;
  (* drop above the ban point *)
  let state = initial_state h w 1 (4, 3) in
  let state = apply_action state 3 in
  assert_equal state.board.(5).(3) 1;
  let state = apply_action state 3 in
  assert_equal state.board.(3).(3) 2 (* drop above the ban point *)

(* Run all the tests *)
let series =
  "Connect4_ban Tests"
  >::: [
         "test_initial_state" >:: test_initial_state;
         "test_is_full_full_board" >:: test_is_full_full_board;
         "test_is_full_not_full" >:: test_is_full_not_full;
         "test_is_full_with_ban" >:: test_is_full_with_ban;
         "test_is_empty_empty_board" >:: test_is_empty_empty_board;
         "test_is_empty_not_empty" >:: test_is_empty_not_empty;
         "test_check_winner_with_last_no_winner"
         >:: test_check_winner_with_last_no_winner;
         "test_check_winner_with_last_winner" >:: test_check_winner_with_last;
         "test_is_terminal_terminal" >:: test_is_terminal_terminal;
         "test_is_terminal_not_terminal" >:: test_is_terminal_not_terminal;
         "test_generate_actions_normal" >:: test_generate_actions_normal;
         "test_generate_actions_with_ban_point"
         >:: test_generate_actions_with_ban_point;
         "test_apply_action_valid_move" >:: test_apply_action_valid_move;
         "test_apply_action_invalid_column" >:: test_apply_action_invalid_column;
         "test_apply_action_column_full" >:: test_apply_action_column_full;
         "test_apply_action_with_ban_point" >:: test_apply_action_with_ban_point;
       ]

let () = run_test_tt_main series
