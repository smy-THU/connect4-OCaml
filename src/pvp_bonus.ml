open Connect4_bonus


let play_game rows cols player bonus_point =
  let state = Connect4_bonus.initial_state rows cols player bonus_point in

  let rec game_loop state =
    (* Print the board for visualization *)
    Array.iter (fun row ->
      Array.iter (fun cell ->
        print_string (
          match cell with
          | 0 -> ". "
          | 1 -> "X "
          | 2 -> "O "
          | -2 -> "B "
          | -1 -> "N "
          | _ -> failwith "invalid board state"
        )) row;
      print_newline ()) state.board;
    print_newline ();

    if Connect4_bonus.is_terminal state then (
      match Connect4_bonus.evaluate state with
      | 1.0 -> print_endline "Player 2 wins!"
      | -1.0 -> print_endline "Player 1 wins!"
      | 0.0 -> print_endline "It's a draw!"
      | _ -> ()
    ) else (
      let next_state =
        if state.current_player = 1 then (
          (* Human player's turn *)
          print_endline "Player1's turn. Enter a column (0-based index):";
          let rec get_user_action () =
            try
              let col = read_int () in
              if col < 0 || col >= state.w || state.board.(0).(col) <> 0 then (
                print_endline "Invalid move. Try again:";
                get_user_action ()
              ) else col
            with _ ->
              print_endline "Invalid input. Enter a valid column index:";
              get_user_action ()
          in
          let action = get_user_action () in
          Connect4_bonus.apply_action state action
        ) else (
          (* print_endline "MCTS Agent is thinking...";
          let action = ConnectFourMCTS.search state iterations exploration in
          print_endline ("MCTS Agent chooses column: " ^ string_of_int action);
          Connect4_bonus.apply_action state action *)
          print_endline "Player2's turn. Enter a column (0-based index):";
          let rec get_user_action () =
            try
              let col = read_int () in
              if col < 0 || col >= state.w || state.board.(0).(col) <> 0 then (
                print_endline "Invalid move. Try again:";
                get_user_action ()
              ) else col
            with _ ->
              print_endline "Invalid input. Enter a valid column index:";
              get_user_action ()
          in
          let action = get_user_action () in
          Connect4_bonus.apply_action state action
        )
      in
      game_loop next_state
    )
  in
  game_loop state

let () =
  Random.self_init ();
  let rows = 6 in
  let cols = 7 in
  let initial_player = 1 in
  let x = Random.int rows in
  let y = Random.int cols in
  let bonus_point = (x, y) in
  play_game rows cols initial_player bonus_point
