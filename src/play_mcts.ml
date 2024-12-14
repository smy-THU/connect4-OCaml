open Connect4


module ConnectFourMCTS = Mcts.Make(Connect4)

let play_game rows cols iterations exploration =
  let state = Connect4.initial_state rows cols in

  let rec game_loop state =
    (* Print the board for visualization *)
    Array.iter (fun row ->
      Array.iter (fun cell ->
        print_string (
          match cell with
          | 0 -> ". "
          | 1 -> "X "
          | 2 -> "O "
          | _ -> failwith "invalid board state"
        )) row;
      print_newline ()) state.board;
    print_newline ();

    if Connect4.is_terminal state then (
      match Connect4.evaluate state with
      | 1.0 -> print_endline "Player 1 wins!"
      | -1.0 -> print_endline "Player 2 wins!"
      | 0.0 -> print_endline "It's a draw!"
      | _ -> ()
    ) else (
      let action = ConnectFourMCTS.search state iterations exploration in
      let new_state = Connect4.apply_action state action in
      game_loop new_state
    )
  in
  game_loop state

let () =
  Random.self_init ();
  let rows = 6 in
  let cols = 7 in
  let iterations = 1000 in
  let exploration = 1.41 in
  play_game rows cols iterations exploration
