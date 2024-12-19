open OUnit2
open Mcts

(* Define a simple mock game module to test the MCTS implementation *)
module MockGame = struct
  type state = int
  type action = int

  let is_terminal state = state <= 0
  let evaluate state = float_of_int state
  let generate_actions state = if state <= 0 then [] else [ 1; 2; 3 ]
  let apply_action state action = state - action
end

module MCTS = Make (MockGame)

let test_create_node _ =
  let state = 5 in
  let node = MCTS.create_node state in
  assert_equal node.state 5;
  assert_equal node.wins 0.0;
  assert_equal node.visits 0;
  assert_equal node.children [];
  assert_equal node.parent None;
  assert_equal node.action None

let test_ucb1 _ =
  let node =
    {
      MCTS.state = 5;
      action = None;
      wins = 10.0;
      visits = 5;
      children = [];
      parent = None;
    }
  in
  let total_visits = 20 in
  let exploration = 1.41 in
  let ucb = MCTS.ucb1 node total_visits exploration in
  assert_bool "UCB1 is positive" (ucb > 0.0)

let test_expand _ =
  let state = 5 in
  let node = MCTS.create_node state in
  MCTS.expand node;
  assert_equal (List.length node.children) 3;
  let child_states = List.map (fun child -> child.MCTS.state) node.children in
  assert_equal (List.sort compare child_states) [ 2; 3; 4 ]

let test_simulate _ =
  let state = 3 in
  let result = MCTS.simulate state in
  assert_bool "Simulation result is non-negative" (result >= 0.0)

let test_backpropagate _ =
  let root = MCTS.create_node 5 in
  let child = MCTS.create_node ~parent:(Some root) 4 in
  MCTS.backpropagate child 1.0;
  assert_equal root.visits 1;
  assert_equal root.wins 1.0;
  assert_equal child.visits 1;
  assert_equal child.wins 1.0

let test_search _ =
  let root_state = 5 in
  let iterations = 5 in
  let exploration = 1.41 in
  let action = MCTS.search root_state iterations exploration in
  assert_bool "Search produces a valid action" (List.mem action [ 1; 2; 3 ])

let series =
  "MCTS Tests"
  >::: [
         "test_create_node" >:: test_create_node;
         "test_ucb1" >:: test_ucb1;
         "test_expand" >:: test_expand;
         "test_simulate" >:: test_simulate;
         "test_backpropagate" >:: test_backpropagate;
         "test_search" >:: test_search;
       ]

let () = run_test_tt_main series
