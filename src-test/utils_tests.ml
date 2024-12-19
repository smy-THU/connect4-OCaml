open OUnit2
open Utils

let test_get_h _ =
  let board = empty_board 6 7 in
  assert_equal 6 (get_h board);
  let board = empty_board 10 8 in
  assert_equal 10 (get_h board)

let test_get_w _ =
  let board = empty_board 6 7 in
  assert_equal 7 (get_w board);
  let board = empty_board 10 8 in
  assert_equal 8 (get_w board)

let test_point_is_in _ =
  let board = empty_board 6 7 in
  assert_equal true (point_is_in (0, 0) board);
  assert_equal true (point_is_in (5, 6) board);
  assert_equal false (point_is_in (6, 6) board);
  assert_equal false (point_is_in (-1, 0) board);
  assert_equal false (point_is_in (0, 7) board);
  assert_equal false (point_is_in (7, -1) board)

let test_empty_board _ =
  let rows = 6 and cols = 7 in
  let board = empty_board rows cols in
  assert_equal rows (Array.length board);
  assert_equal cols (Array.length board.(0));
  Array.iter (fun row -> Array.iter (fun cell -> assert_equal 0 cell) row) board

let test_switch_player _ =
  assert_equal 2 (switch_player 1);
  assert_equal 1 (switch_player 2);
  assert_raises (Failure "player invalid") (fun () -> switch_player 0);
  assert_raises (Failure "player invalid") (fun () -> switch_player 3)

let series =
  "Utils Test Suite"
  >::: [
         "test_get_h" >:: test_get_h;
         "test_get_w" >:: test_get_w;
         "test_point_is_in" >:: test_point_is_in;
         "test_empty_board" >:: test_empty_board;
         "test_switch_player" >:: test_switch_player;
       ]

let () = run_test_tt_main series
