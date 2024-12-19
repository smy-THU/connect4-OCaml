open OUnit2

(* Mock Game module for testing *)
module MockGame : sig
  type state = int
  type action = int

  val is_terminal : state -> bool
  val evaluate : state -> float
  val generate_actions : state -> action list
  val apply_action : state -> action -> state
end = struct
  type state = int
  type action = int

  (* Terminal state is defined as state 0 *)
  let is_terminal state = state = 0

  (* Evaluation function simply returns the state as a float *)
  let evaluate state = float_of_int state

  (* Generate actions as decrements *)
  let generate_actions state = if state > 0 then [ 1; 2 ] else []

  (* Apply action by subtracting the action value from the state *)
  let apply_action state action = state - action
end

module Minimax = Minimax.Make (MockGame)

let test_minimax_terminal _ =
  let state = 0 in
  let score = Minimax.minimax state 3 true in
  assert_equal ~msg:"Terminal state evaluation" ~printer:string_of_float 0.0
    score

let test_minimax_non_terminal _ =
  let state = 5 in
  let score = Minimax.minimax state 3 true in
  assert_equal ~msg:"Non-terminal state evaluation" ~printer:string_of_float 1.0
    score

let test_best_action _ =
  let state = 5 in
  let best_action = Minimax.best_action state 2 in
  assert_equal ~msg:"Best action selection" ~printer:string_of_int 1 best_action

let series =
  "Minimax Tests"
  >::: [
         "test_minimax_terminal" >:: test_minimax_terminal;
         "test_minimax_non_terminal" >:: test_minimax_non_terminal;
         "test_best_action" >:: test_best_action;
       ]

let () = run_test_tt_main series
