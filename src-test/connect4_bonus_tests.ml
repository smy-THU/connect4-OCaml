open OUnit2
open Connect4_bonus

let test_initial_state _ =
  let h, w = 6, 7 in
  let player = 1 in
  let bonus_point = (3, 3) in
  let state = initial_state h w player bonus_point in
  assert_equal state.h h;
  assert_equal state.w w;
  assert_equal state.current_player player;
  assert_equal state.bonus_point bonus_point;
  assert_equal state.get_bonus 0;
  assert_equal state.last_move (-1, -1);
  assert_bool "Bonus point should be marked as -2" 
    (state.board.(3).(3) = -2)

let test_is_full_state _ =
  let h, w = 6, 7 in
  let player = 1 in
  let bonus_point = (3, 3) in
  let state = initial_state h w player bonus_point in
  (* Empty board should not be full *)
  assert_equal (is_full_state state) false;

  (* Fill the first row completely *)
  Array.iteri (fun col _ -> state.board.(0).(col) <- 1) state.board.(0);
  assert_equal (is_full_state state) true

let test_is_terminal _ =
  let h, w = 6, 7 in
  let player = 1 in
  let bonus_point = (3, 3) in
  let state = initial_state h w player bonus_point in
  (* Empty board is not terminal *)
  assert_equal (is_terminal state) false;

  (* Fill the board completely *)
  Array.iteri (fun row _ -> 
    Array.iteri (fun col _ -> state.board.(row).(col) <- 1) state.board.(row)) state.board;
  assert_equal (is_terminal state) true

let test_apply_action _ =
  let h, w = 6, 7 in
  let player = 1 in
  let bonus_point = (3, 3) in
  let state = initial_state h w player bonus_point in

  let action = 0 in
  let new_state = apply_action state action in
  assert_equal new_state.current_player 2;
  assert_equal new_state.board.(5).(0) 1

let test_generate_actions _ =
  let h, w = 6, 7 in
  let player = 1 in
  let bonus_point = (3, 3) in
  let state = initial_state h w player bonus_point in
  (* All columns should be valid actions on an empty board *)
  let actions = generate_actions state in
  assert_equal (List.length actions) w;

  (* Fill a column completely *)
  Array.iteri (fun row _ -> state.board.(row).(0) <- 1) state.board;
  let actions = generate_actions state in
  assert_equal (List.length actions) (w - 1)

let test_evaluate _ =
  let h, w = 6, 7 in
  let player = 1 in
  let bonus_point = (3, 3) in
  let state = initial_state h w player bonus_point in
  assert_equal 0.0 (evaluate state);

  (* Simulate a winning state *)
  let state = apply_action state 3 in
  let state = apply_action state 3 in
  let state = apply_action state 4 in
  let state = apply_action state 4 in
  let state = apply_action state 5 in
  let state = apply_action state 5 in
  let state = apply_action state 2 in
  assert_equal (-1.0) (evaluate state) 

let series =
  "TestConnect4Bonus" >::: [
    "test_initial_state" >:: test_initial_state;
    "test_is_full_state" >:: test_is_full_state;
    "test_is_terminal" >:: test_is_terminal;
    "test_apply_action" >:: test_apply_action;
    "test_generate_actions" >:: test_generate_actions;
    "test_evaluate" >:: test_evaluate;
  ]

let () =
  run_test_tt_main series
