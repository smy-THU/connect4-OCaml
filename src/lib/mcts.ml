module type Game = sig
  type state
  type action

  val is_terminal : state -> bool
  val evaluate : state -> float
  val generate_actions : state -> action list
  val apply_action : state -> action -> state
end

module Make (G : Game) = struct
  type node = {
    state : G.state;
    action : G.action option;
    mutable wins : float;
    mutable visits : int;
    mutable children : node list;
    parent : node option;
  }

  let create_node ?(action=None) ?(parent=None) state = {
    state;
    action;
    wins = 0.0;
    visits = 0;
    children = [];
    parent;
  }

  let ucb1 (child : node) (total_visits : int) (exploration : float) : float =
    if child.visits = 0 then infinity
    else
      (child.wins /. float_of_int child.visits)
      +. exploration *. sqrt (2.0 *. log (float_of_int total_visits) /. float_of_int child.visits)

  let select_best_node (node : node) (exploration : float) : node =
    List.fold_left
      (fun best child ->
         if ucb1 child node.visits exploration > ucb1 best node.visits exploration then
           child
         else
           best)
      (List.hd node.children)
      node.children

  let expand (node : node) : unit =
    if node.children = [] && not (G.is_terminal node.state) then
      let actions = G.generate_actions node.state in
      node.children <-
        List.map
          (fun action ->
             let child_state = G.apply_action node.state action in
             create_node ~action:(Some action) ~parent:(Some node) child_state)
          actions

  let simulate (state : G.state) : float =
    let rec random_playout state =
      if G.is_terminal state then G.evaluate state
      else
        let actions = G.generate_actions state in
        let random_action = List.nth actions (Random.int (List.length actions)) in
        random_playout (G.apply_action state random_action)
    in
    random_playout state

  let backpropagate (node : node) (result : float) : unit =
    let rec propagate current =
      current.visits <- current.visits + 1;
      current.wins <- current.wins +. result;
      match current.parent with
      | Some parent -> propagate parent
      | None -> ()
    in
    propagate node

  let search (root_state : G.state) (iterations : int) (exploration : float) : G.action =
    let root = create_node root_state in
    for _ = 1 to iterations do
      let rec select node =
        if node.children = [] then node
        else if List.exists (fun child -> child.visits = 0) node.children then
          List.find (fun child -> child.visits = 0) node.children
        else
          select (select_best_node node exploration)
      in
      let selected_node = select root in
      expand selected_node;
      let simulation_result = simulate selected_node.state in
      backpropagate selected_node simulation_result;
    done;
    let best_child =
      List.fold_left
        (fun best child ->
           if float_of_int child.visits > float_of_int best.visits then child else best)
        (List.hd root.children)
        root.children
    in
    match best_child.action with
    | Some action -> action
    | None -> failwith "No valid action found"
end
