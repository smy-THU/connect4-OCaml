module MockGame = struct
  type state = int
  type action = int

  let is_terminal state = state <= 0  (* Terminal if state is 0 or less *)

  let evaluate state = float_of_int state  (* Simply return the state as the evaluation *)

  let generate_actions state =
    if state <= 0 then [] else [1; 2; 3]  (* Generate actions 1, 2, or 3 if state > 0 *)

  let apply_action state action = state - action  (* Apply the action by subtracting it from the state *)
end

open OUnit2
open Alpha_beta  (* This is the module that will be created by Make(MockGame) *)

module AlphaBeta = Make(MockGame)

(* Test case 1: Testing Minimax on terminal state *)
let test_minimax_terminal _ =
  let state = 0 in  (* Terminal state *)
  let depth = 3 in  (* Arbitrary depth *)
  let alpha = neg_infinity in
  let beta = infinity in
  let maximizing = true in
  let value, action = AlphaBeta.minimax state depth alpha beta maximizing in
  assert_equal value 0.0;  (* Terminal state, should evaluate to 0.0 *)
  assert_equal action None  (* No valid action *)

(* Test case 2: Testing Minimax with simple state *)
let test_minimax_simple _ =
  let state = 3 in  (* Initial state *)
  let depth = 2 in  (* Depth of 2 *)
  let alpha = neg_infinity in
  let beta = infinity in
  let maximizing = true in
  let value, action = AlphaBeta.minimax state depth alpha beta maximizing in
  (* Expected value and action depend on the mock game logic *)
  assert_equal 0.0 value ~printer:string_of_float; 
  assert_equal action (Some 3) ~printer: (fun a -> match a with |Some a -> string_of_int a |None -> "none")

(* Test case 3: Testing Search function *)
let test_search _ =
  let state = 5 in  (* Initial state *)
  let depth = 2 in  (* Depth of 2 *)
  let action = AlphaBeta.search state depth in
  (* Expected action depends on the mock game logic *)
  assert_equal action 1  (* The best action according to minimax should be action 1 *)

(* Test case 4: Testing the minimizing player (depth 1) *)
let test_minimax_minimizing _ =
  let state = 3 in
  let depth = 1 in  (* Only one level of depth *)
  let alpha = neg_infinity in
  let beta = infinity in
  let maximizing = false in  (* Minimizing player *)
  let value, action = AlphaBeta.minimax state depth alpha beta maximizing in
  (* Expected value is the minimal one from the next actions *)
  assert_equal value 0.0;  (* The minimizing player will try to go to state 0, which is terminal *)
  assert_equal action (Some 3)  (* The minimizing player will pick action 3 to reach terminal state 0 *)

(* Combine all tests into a test suite *)
let series =
  "AlphaBeta Tests" >::: [
    "test_minimax_terminal" >:: test_minimax_terminal;
    "test_minimax_simple" >:: test_minimax_simple;
    "test_search" >:: test_search;
    "test_minimax_minimizing" >:: test_minimax_minimizing;
  ]

(* Run the tests *)
let () =
  run_test_tt_main series
