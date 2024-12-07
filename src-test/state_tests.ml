open OUnit2
open State

let state = create_state true 6 7 5 3

let test_create_state _ =
  assert_equal state.player true;
  assert_equal state.h 6;
  assert_equal state.w 7;
  assert_equal state.ban_x 5;
  assert_equal state.ban_y 3;
  assert_equal state.board.(5).(3) 0

let test_copy_state _ =
  let state_copy = copy_state state in
  assert_equal state.player state_copy.player;
  assert_equal state.h state_copy.h;
  assert_equal state.w state_copy.w;
  assert_equal state.ban_x state_copy.ban_x;
  assert_equal state.ban_y state_copy.ban_y;
  assert_equal state.board state_copy.board

let test_next_state _ =
  let new_state = next_state state 5 3 in
  assert_equal new_state.player false;
  assert_equal new_state.board.(5).(3) 1;
  assert_equal new_state.last_put (5, 3)

let test_random_put _ =
  let x, y = random_put state in
  assert_bool "Random put should be within bounds"
    (x >= 0 && x < 6 && y >= 0 && y < 7)

let test_default_policy _ =
  let result = default_policy state in
  assert_bool "Default policy result should be -1, 0, or 1"
    (result = -1 || result = 0 || result = 1)

let test_next_choice_state _ =
  let state = create_state true 6 7 5 3 in
  let next_state_opt = next_choice_state state in
  match next_state_opt with
  | None -> assert_equal state.next_choice state.w
  | Some next_state ->
      assert_bool "Next choice state should be valid"
        (next_state.next_choice >= 0 && next_state.next_choice < state.w)

let series =
  "Tests"
  >::: [
         "Create State" >:: test_create_state;
         "Copy State" >:: test_copy_state;
         "Next State" >:: test_next_state;
         "Random Put" >:: test_random_put;
         (* "Default Policy" >:: test_default_policy; *)
         "Next Choice State" >:: test_next_choice_state;
       ]

let () = run_test_tt_main series
