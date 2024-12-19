open OUnit2

(* Define a module alias for convenience *)
module C4 = Connect4

(* Helper function to create a test state *)
let create_test_state () = C4.initial_state 6 7 1

let test_initial_state _ =
  let state = C4.initial_state 6 7 1 in
  assert_equal state.C4.h 6;
  assert_equal state.C4.w 7;
  assert_equal state.C4.current_player 1;
  assert_equal state.C4.last_move (-1, -1);
  assert_bool "Board should be empty" (C4.is_empty state.board)

let test_is_full _ =
  let state = C4.initial_state 6 7 1 in
  let full_board = Array.make_matrix 6 7 1 in
  assert_bool "Board should not be full" (not (C4.is_full state.board));
  assert_bool "Board should be full" (C4.is_full full_board)

let test_check_winner _ =
  let state = create_test_state () in
  let board = state.C4.board in
  (* Simulate a winning board state for player 1 *)
  for i = 0 to 3 do
    board.(5).(i) <- 1
  done;
  assert_bool "Player 1 should win" (C4.check_winner board 1);
  assert_bool "Player 2 should not win" (not (C4.check_winner board 2))

let test_apply_action _ =
  let state = create_test_state () in
  let new_state = C4.apply_action state 3 in
  assert_equal new_state.C4.current_player 2;
  assert_equal new_state.C4.last_move (5, 3);
  assert_equal new_state.C4.board.(5).(3) 1

let test_generate_actions _ =
  let state = create_test_state () in
  let actions = C4.generate_actions state in
  assert_equal actions [ 0; 1; 2; 3; 4; 5; 6 ];
  let full_column = Array.make_matrix 6 7 1 in
  let full_state = { state with C4.board = full_column } in
  let no_actions = C4.generate_actions full_state in
  assert_equal no_actions []

let test_is_terminal _ =
  let state = create_test_state () in
  assert_bool "Empty board should not be terminal" (not (C4.is_terminal state));

  let state = C4.apply_action state 3 in
  let state = C4.apply_action state 2 in
  let state = C4.apply_action state 3 in
  let state = C4.apply_action state 2 in
  let state = C4.apply_action state 3 in
  let state = C4.apply_action state 2 in
  let state = C4.apply_action state 3 in

  assert_bool "Winning board should be terminal" (C4.is_terminal state);

  let full_board = Array.make_matrix 6 7 1 in
  let full_state = { state with C4.board = full_board } in
  assert_bool "full board should be terminal" (C4.is_terminal full_state)

let series =
  "Connect4 Tests"
  >::: [
         "test_initial_state" >:: test_initial_state;
         "test_is_full" >:: test_is_full;
         "test_check_winner" >:: test_check_winner;
         "test_apply_action" >:: test_apply_action;
         "test_generate_actions" >:: test_generate_actions;
         "test_is_terminal" >:: test_is_terminal;
       ]

let () = run_test_tt_main series
