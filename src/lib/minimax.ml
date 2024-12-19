module type Game = sig
  type state
  type action

  val is_terminal : state -> bool
  val evaluate : state -> float
  val generate_actions : state -> action list
  val apply_action : state -> action -> state
end

module Make (G : Game) = struct
  (* Minimax functor *)
  let rec minimax (state : G.state) (depth : int) (maximizing : bool) : float =
    (* Check if the game is over or if we have reached the maximum depth *)
    if G.is_terminal state || depth = 0 then G.evaluate state
    else
      let actions = G.generate_actions state in
      if maximizing then
        (* Maximize: Find the highest value over all possible actions *)
        List.fold_left
          (fun best_score action ->
            let new_state = G.apply_action state action in
            max best_score (minimax new_state (depth - 1) false))
          (-.infinity) actions
      else
        (* Minimize: Find the lowest value over all possible actions *)
        List.fold_left
          (fun best_score action ->
            let new_state = G.apply_action state action in
            min best_score (minimax new_state (depth - 1) true))
          infinity actions

  (* Wrapper for the minimax that starts with maximizing player *)
  let best_action (state : G.state) (depth : int) : G.action =
    let actions = G.generate_actions state in
    let _, best_action =
      List.fold_left
        (fun (best_score, best_action) action ->
          let new_state = G.apply_action state action in
          let score = minimax new_state depth false in
          if score > best_score then (score, action)
          else (best_score, best_action))
        (-.infinity, List.hd actions)
        actions
    in
    best_action
end
