type t = { mutable root : Tree.node }

let create_uct player h w ban_x ban_y =
  let root_state = State.create_state player h w ban_x ban_y in
  { root = Tree.create_node root_state None }

let tree_policy uct =
  let rec expand_or_best node =
    if Tree.expand node <> None then node
    else match Tree.best_child node with
      | None -> node
      | Some best -> expand_or_best best
  in
  expand_or_best uct.root

let get_best_move uct =
  let start_time = Unix.gettimeofday () in
  while Unix.gettimeofday () -. start_time < 2.7 do
    let node = tree_policy uct in
    let delta = State.default_policy node.state in
    Tree.backup node delta
  done;
  match Tree.best_child uct.root with
  | None -> (-1, -1)
  | Some best -> best.state.last_put