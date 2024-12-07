include Tree

type t = { mutable root : Tree.node }

let create_uct player h w ban_x ban_y =
  let root_state = State.create_state player h w ban_x ban_y in
  { root = Tree.create_node root_state None }


let tree_policy uct =
  let rec traverse cur =
    if cur.state.next_choice = cur.state.w && cur.first_child <> None then
      match Tree.best_child cur with
      | None -> failwith "Tree.best_child returned None unexpectedly"
      | Some best -> traverse best
    else
      match expand cur with
      | None -> cur
      | Some expanded -> expanded
  in
  traverse uct.root

let get_best_move uct =
  let start_time = Unix.gettimeofday () in
  let time_limit = 3.0 in (* 3 second time limit *)
  let rec simulate counter =
    if counter mod 100 <> 0 || Unix.gettimeofday () -. start_time < time_limit then begin
      let node = tree_policy uct in
      let delta = State.default_policy node.state in
      let rec backup n delta =
        match n with
        | None -> ()
        | Some node ->
            node.visit <- node.visit + 1;
            node.win <- node.win + delta;
            backup node.parent (-delta)
      in
      backup (Some node) delta;
      simulate (counter + 1)
    end
  in
  simulate 0;

  (* Find the best child based on visit count *)
  let rec find_best_child best_node max_visit children =
    match children with
    | None -> best_node
    | Some child ->
        if child.visit > max_visit then
          find_best_child (Some child) child.visit child.next_sibling
        else
          find_best_child best_node max_visit child.next_sibling
  in
  match find_best_child None min_int uct.root.first_child with
  | None -> failwith "No child found"
  | Some best_child -> best_child.state.last_put

let move_root uct put =
  (* Expand the current root until no more expansion is possible *)
  let rec expand_all node =
    match expand node with
    | None -> ()
    | Some _ -> expand_all node
  in
  expand_all uct.root;
  (* Find and move the root to the child matching the move `put` *)
  let rec find_and_remove_matching children =
    match children with
    | None -> None
    | Some child ->
        if child.state.last_put = put then (
          (* Found the matching child, detach it *)
          child.next_sibling <- None;
          Some child
        ) else
          find_and_remove_matching child.next_sibling
  in
  match find_and_remove_matching uct.root.first_child with
  | None -> failwith "No matching child found"
  | Some new_root ->
      new_root.parent <- None;
      uct.root <- new_root