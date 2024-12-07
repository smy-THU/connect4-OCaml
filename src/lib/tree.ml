type node = {
  state : State.t;
  mutable parent : node option;
  mutable first_child : node option;
  mutable next_sibling : node option;
  mutable win : int;
  mutable visit : int;
}

let create_node state parent =
  { state; parent; first_child = None; next_sibling = None; win = 0; visit = 0 }

let ucb1 parent child =
  let c = 0.5 in
  let child_score = float_of_int child.win /. float_of_int child.visit in
  let parent_visits = float_of_int parent.visit in
  let child_visits = float_of_int child.visit in
  -.child_score +. (c *. sqrt (2.0 *. log parent_visits /. child_visits))

let expand node =
  match State.next_choice_state node.state with
  | None -> None
  | Some new_state ->
      let child = create_node new_state (Some node) in
      (* Insert child into linked list *)
      child.next_sibling <- node.first_child;
      node.first_child <- Some child;
      Some child

let best_child node =
  let rec find_best best_score best_node = function
    | None -> best_node
    | Some child ->
        let score = ucb1 node child in
        if score > best_score then
          find_best score (Some child) child.next_sibling
        else find_best best_score best_node child.next_sibling
  in
  find_best neg_infinity None node.first_child

let backup node delta =
  let rec update n d =
    match n with
    | None -> ()
    | Some n ->
        n.visit <- n.visit + 1;
        n.win <- n.win + d;
        update n.parent (-d)
  in
  update (Some node) delta
