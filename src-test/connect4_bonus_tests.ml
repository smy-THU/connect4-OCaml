open OUnit2
open Connect4_bonus

let test_initial_state _ =
  let h, w = (6, 7) in
  let player = 1 in
  let bonus_point = (3, 3) in
  let state = initial_state h w player bonus_point in
  assert_equal state.h h;
  assert_equal state.w w;
  assert_equal state.current_player player;
  assert_equal state.bonus_point bonus_point;
  assert_equal state.get_bonus 0;
  assert_equal state.last_move (-1, -1);
  assert_bool "Bonus point should be marked as -2" (state.board.(3).(3) = -2);
  assert_raises (Failure "board size invalid") (fun () ->
      initial_state 5 10 1 (0, 0));
  assert_raises (Failure "player not valid when initial state") (fun () ->
      initial_state 10 10 3 (0, 0));
  assert_raises (Failure "bonus_point is not in board") (fun () ->
      initial_state 10 10 1 (15, 15))

let test_is_full_state _ =
  let h, w = (6, 7) in
  let player = 1 in
  let bonus_point = (3, 3) in
  let state = initial_state h w player bonus_point in
  (* Empty board should not be full *)
  assert_equal (is_full_state state) false;

  (* Fill the first row completely *)
  Array.iteri (fun col _ -> state.board.(0).(col) <- 1) state.board.(0);
  assert_equal (is_full_state state) true;

  let create_state board current_player h w last_move ban_point bonus_point
      get_bonus =
    {
      board;
      current_player;
      h;
      w;
      last_move;
      ban_point;
      bonus_point;
      get_bonus;
    }
  in

  (* Test get_bonus = 0 and board not full *)
  let board = [| [| 1; 0; -2 |]; [| 1; 2; 0 |] |] in
  let state = create_state board 1 6 3 (-1, -1) (-1, -1) (-1, -1) 0 in
  assert_equal false (is_full_state state) ~msg:"case1";

  (* Test get_bonus = 0 and board full *)
  let board = [| [| 1; 2; 1 |]; [| 1; 2; 1 |] |] in
  let state = create_state board 1 6 3 (-1, -1) (-1, -1) (-1, -1) 0 in
  assert_equal true (is_full_state state) ~msg:"case2";

  (* Test get_bonus = 1 *)
  let board = [| [| 1; 2; -2 |]; [| 1; 0; 1 |] |] in
  let state = create_state board 1 6 3 (-1, -1) (-1, -1) (-1, -1) 1 in
  assert_equal false (is_full_state state) ~msg:"case3";

  (* Test get_bonus = 2, no ban point in the first row *)
  let board = [| [| 1; 2; 1 |]; [| 0; 0; 0 |] |] in
  let state = create_state board 1 6 3 (-1, -1) (1, 1) (0, 1) 2 in
  assert_equal true (is_full_state state) ~msg:"case4";

  (* Test get_bonus = 2, with ban point and incomplete columns *)
  let board = [| [| 1; -1; 1 |]; [| 1; 1; 1 |] |] in
  let state = create_state board 1 6 3 (-1, -1) (1, 1) (0, 1) 2 in
  assert_equal true (is_full_state state) ~msg:"case5";

  (* Test get_bonus = 2, with ban point and full columns *)
  let board = [| [| 1; -1; 1 |]; [| 1; 1; 1 |] |] in
  let state = create_state board 1 6 3 (-1, -1) (1, 1) (0, 1) 2 in
  assert_equal true (is_full_state state) ~msg:"case6";

  (* Test invalid get_bonus status *)
  let board = [| [| 1; -1; 1 |]; [| 1; 1; 1 |] |] in
  let state = create_state board 1 6 3 (-1, -1) (1, 1) (0, 1) 3 in
  assert_raises (Failure "invalid get_bonus status in this state") (fun () ->
      is_full_state state);

  (* Test invalid point value on the board *)
  let board = [| [| 1; -1; 3 |]; [| 0; 1; 0 |] |] in
  let state = create_state board 1 6 3 (-1, -1) (1, 1) (0, 1) 2 in
  assert_raises (Failure "invalid point value on the board.") (fun () ->
      is_full_state state)

let test_is_terminal _ =
  let h, w = (6, 7) in
  let player = 1 in
  let bonus_point = (3, 3) in
  let state = initial_state h w player bonus_point in
  (* Empty board is not terminal *)
  assert_equal (is_terminal state) false;

  (* Fill the board completely *)
  Array.iteri
    (fun row _ ->
      Array.iteri (fun col _ -> state.board.(row).(col) <- 1) state.board.(row))
    state.board;
  assert_equal (is_terminal state) true

let test_apply_action _ =
  let h, w = (6, 7) in
  let player = 1 in
  let bonus_point = (3, 3) in
  let state = initial_state h w player bonus_point in

  let action = 0 in
  let new_state = apply_action state action in
  assert_equal new_state.current_player 2;
  assert_equal new_state.board.(5).(0) 1

let test_generate_actions _ =
  let h, w = (6, 7) in
  let player = 1 in
  let bonus_point = (3, 3) in
  let state = initial_state h w player bonus_point in
  (* All columns should be valid actions on an empty board *)
  let actions = generate_actions state in
  assert_equal (List.length actions) w;

  (* Fill a column completely *)
  Array.iteri (fun row _ -> state.board.(row).(0) <- 1) state.board;
  let actions = generate_actions state in
  assert_equal (List.length actions) (w - 1);

  let create_state board current_player h w last_move ban_point bonus_point
      get_bonus =
    {
      board;
      current_player;
      h;
      w;
      last_move;
      ban_point;
      bonus_point;
      get_bonus;
    }
  in

  (* Test get_bonus = 0 (No bonus point yet) *)
  let board_0 = [| [| 0; 0; 0 |]; [| 0; 0; 0 |] |] in
  let state_0 = create_state board_0 1 2 3 (-1, -1) (-1, -1) (0, 0) 0 in
  assert_equal
    [ 0; 1; 2 ] (* All columns are empty in the first row *)
    (generate_actions state_0) ~msg:"Test failed for get_bonus = 0";

  (* Test get_bonus = 1 (Bonus point acquired, not yet placed) *)
  let board_1 = [| [| 0; 0; 0 |]; [| 0; 0; 0 |] |] in
  let state_1 = create_state board_1 1 2 3 (-1, -1) (-1, -1) (0, 0) 1 in
  assert_equal
    [ 0; 1; 2 ] (* All columns are empty, valid to place ban point *)
    (generate_actions state_1) ~msg:"Test failed for get_bonus = 1";

  (* Test get_bonus = 2 with no valid columns under ban points *)
  let board_3 = [| [| 1; 1; 0 |]; [| 1; 1; 0 |] |] in
  let state_3 = create_state board_3 1 2 3 (1, 0) (0, 0) (0, 0) 2 in
  assert_equal
    [ 2 ] (* Only column 2 is empty in the first row *)
    (generate_actions state_3)
    ~msg:"Test failed for get_bonus = 2, no valid columns under ban points";

  (* Test invalid get_bonus value *)
  let board_invalid = [| [| 0; 0; 0 |]; [| 0; 0; 0 |] |] in
  let state_invalid =
    create_state board_invalid 1 2 3 (-1, -1) (-1, -1) (0, 0) 3
  in
  assert_raises (Failure "invalid get_bonus value") (fun () ->
      generate_actions state_invalid)

let test_evaluate _ =
  let h, w = (6, 7) in
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
  "TestConnect4Bonus"
  >::: [
         "test_initial_state" >:: test_initial_state;
         "test_is_full_state" >:: test_is_full_state;
         "test_is_terminal" >:: test_is_terminal;
         "test_apply_action" >:: test_apply_action;
         "test_generate_actions" >:: test_generate_actions;
         "test_evaluate" >:: test_evaluate;
       ]

let () = run_test_tt_main series
