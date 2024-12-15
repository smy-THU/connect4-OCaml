module type Game = sig
  type state
  type action

  val is_terminal : state -> bool
  val evaluate : state -> float
  val generate_actions : state -> action list
  val apply_action : state -> action -> state
end

module Make (G : Game) = struct
  let rec minimax (state : G.state) (depth : int) (alpha : float) (beta : float) (maximizing : bool) : float * G.action option =
    if depth = 0 || G.is_terminal state then
      (G.evaluate state, None)
    else
      let actions = G.generate_actions state in
      if maximizing then
        (* Maximizing player *)
        let rec max_value alpha best_action = function
          | [] -> (alpha, best_action)
          | action :: rest ->
            let next_state = G.apply_action state action in
            let value, _ = minimax next_state (depth - 1) alpha beta false in
            if value > alpha then
              max_value (max alpha value) (Some action) rest
            else
              max_value alpha best_action rest
        in
        max_value alpha None actions
      else
        (* Minimizing player *)
        let rec min_value beta best_action = function
          | [] -> (beta, best_action)
          | action :: rest ->
            let next_state = G.apply_action state action in
            let value, _ = minimax next_state (depth - 1) alpha beta true in
            if value < beta then
              min_value (min beta value) (Some action) rest
            else
              min_value beta best_action rest
        in
        min_value beta None actions

  let search (state : G.state) (depth : int) : G.action =
    let _, action = minimax state depth neg_infinity infinity true in
    match action with
    | Some a -> a
    | None -> failwith "No valid action found"
end
