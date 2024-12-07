open OUnit2

let test_user_win _ =
  let board =
    [|
      [| 0; 0; 0; 0; 0; 0; 0 |];
      [| 0; 0; 0; 0; 2; 0; 0 |];
      [| 0; 0; 0; 0; 0; 0; 0 |];
      [| 0; 0; 0; 1; 0; 0; 0 |];
      [| 0; 0; 2; 1; 0; 0; 0 |];
      [| 0; 0; 0; 1; 2; 0; 0 |];
      [| 0; 0; 0; 1; 0; 0; 0 |];
    |]
  in
  assert_equal true (Judge.user_win 3 3 7 7 board)

let test_machine_win _ =
  let board =
    [|
      [| 0; 0; 0; 0; 0; 0; 0 |];
      [| 0; 0; 0; 0; 0; 0; 0 |];
      [| 0; 0; 0; 0; 0; 0; 0 |];
      [| 0; 1; 1; 2; 1; 1; 0 |];
      [| 0; 0; 0; 2; 0; 0; 0 |];
      [| 0; 0; 0; 2; 0; 0; 0 |];
      [| 0; 0; 0; 2; 0; 0; 0 |];
    |]
  in
  assert_equal true (Judge.machine_win 3 3 7 7 board)

let test_is_tie _ =
  let top = [| 0; 0; 0; 0; 0; 0; 0 |] in
  assert_equal true (Judge.is_tie top)

let series =
  "Tests"
  >::: [
         "User Win" >:: test_user_win;
         "Machine Win" >:: test_machine_win;
         "Is Tie" >:: test_is_tie;
       ]

(* let () = run_test_tt_main series *)
