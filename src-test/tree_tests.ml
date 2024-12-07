open OUnit2
open Tree
open State

let state = create_state true 6 7 5 3

let test_create_node _ =
  let node = create_node state None in
  assert_equal state node.state;
  assert_equal None node.parent;
  assert_equal None node.first_child;
  assert_equal None node.next_sibling;
  assert_equal 0 node.win;
  assert_equal 0 node.visit

let test_expand _ =
  let node = create_node state None in
  match expand node with
  | None -> assert_failure "Expand failed"
  | Some child ->
      assert_equal (Some node) child.parent;
      assert_equal node.first_child (Some child)

let test_backup _ =
  let node = create_node state None in
  backup node 1;
  assert_equal 1 node.win;
  assert_equal 1 node.visit

let test_ucb1 _ =
  let parent = create_node state None in
  let child = create_node state (Some parent) in
  parent.visit <- 10;
  child.win <- 5;
  child.visit <- 5;
  let score = ucb1 parent child in
  assert_bool "UCB1 score should be positive" (score > 0.)

let test_best_child _ =
  let node = create_node state None in
  let _ = expand node in
  match best_child node with
  | None -> assert_failure "Best child not found"
  | Some child -> assert_equal (Some node) child.parent

let series =
  "Tree Tests"
  >::: [
         "Create Node" >:: test_create_node;
         (* "Expand" >:: test_expand; *)
         "Backup" >:: test_backup;
         (* "UCB1" >:: test_ucb1; *)
         (* "Best Child" >:: test_best_child; *)
       ]

(* let () = run_test_tt_main series *)
