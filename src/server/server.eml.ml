[@@@ocaml.warning "-8-27"]

open Core

let html_path = "./index.html"
let static_dir = "./static"
let decode_csv (line : string) : string list = line |> String.split ~on:','
let encode_csv (line : string list) : string = line |> String.concat ~sep:","

module C4Minimax = Minimax.Make (Connect4)
module C4Alpha = Alpha_beta.Make (Connect4)
module C4Mcts = Mcts.Make (Connect4)
module C4BanMinimax = Minimax.Make (Connect4_ban)
module C4BanAlpha = Alpha_beta.Make (Connect4_ban)
module C4BanMcts = Mcts.Make (Connect4_ban)
module C4BonusMinimax = Minimax.Make (Connect4_bonus)
module C4BonusAlpha = Alpha_beta.Make (Connect4_bonus)
module C4BonusMcts = Mcts.Make (Connect4_bonus)

type all_state =
  | C_st of Connect4.state
  | C_ban_st of Connect4_ban.state
  | C_bonus_st of Connect4_bonus.state

let state_to_winner state =
  let is_end =
    match state with
    | C_st state -> Connect4.is_terminal state
    | C_ban_st state -> Connect4_ban.is_terminal state
    | C_bonus_st state -> Connect4_bonus.is_terminal state
  in
  match is_end with
  | true -> (
      let winner =
        match state with
        | C_st state -> Connect4.evaluate state
        | C_ban_st state -> Connect4_ban.evaluate state
        | C_bonus_st state -> Connect4_bonus.evaluate state
      in
      match winner with
      | 1.0 -> "agent"
      | -1.0 -> "player"
      | 0.0 -> "tie"
      | _ -> "continue")
  | false -> "continue"

let get_last_move state =
  match state with
  | C_st state -> state.last_move
  | C_ban_st state -> state.last_move
  | C_bonus_st state -> state.last_move

let apply_action state action =
  match state with
  | C_st state -> C_st (Connect4.apply_action state action)
  | C_ban_st state -> C_ban_st (Connect4_ban.apply_action state action)
  | C_bonus_st state -> C_bonus_st (Connect4_bonus.apply_action state action)

let get_current_player state =
  match state with
  | C_st state -> state.current_player
  | C_ban_st state -> state.current_player
  | C_bonus_st state -> state.current_player

let rec after_place ws msg state diff =
  match state_to_winner state with
  | "continue" -> (
      match get_current_player state with
      | 1 -> (
          (* receive new `player_action` *)
          match%lwt Dream.receive ws with
          | None -> Dream.close_websocket ws
          | Some msg -> process_player_action ws msg state diff)
      | _ -> process_agent_action ws msg state diff)
  | winner ->
      Core_unix.sleep 1;
      let%lwt () = encode_csv [ "game_end"; winner ] |> Dream.send ws in
      process ws

and process_agent_action ws msg state diff =
  (* agent move *)
  print_endline "Agent is thinking...";
  let agent_action =
    (* different agent *)
    match (state, diff) with
    | C_st state, "easy" -> C4Minimax.best_action state 5
    | C_st state, "medium" -> C4Alpha.search state 8
    | C_st state, "hard" -> C4Mcts.search state 10000 0.7
    | C_ban_st state, "easy" -> C4BanMinimax.best_action state 5
    | C_ban_st state, "medium" -> C4BanAlpha.search state 8
    | C_ban_st state, "hard" -> C4BanMcts.search state 10000 0.7
    | C_bonus_st state, "easy" -> C4BonusMinimax.best_action state 5
    | C_bonus_st state, "medium" -> C4BonusAlpha.search state 8
    | C_bonus_st state, "hard" -> C4BonusMcts.search state 10000 0.7
    | _ -> failwith "invalid difficulty"
  in
  print_endline @@ "Agent chooses column: " ^ string_of_int agent_action;
  let state = apply_action state agent_action in
  let res_row, res_col = get_last_move state in
  let%lwt () =
    encode_csv [ "agent_action"; string_of_int res_row; string_of_int res_col ]
    |> Dream.send ws
  in
  after_place ws msg state diff

and process_player_action ws msg state diff =
  (* player move *)
  let [ msg_type; player_row; player_col ] = msg |> decode_csv in
  let i_player_col = int_of_string player_col in
  assert (String.equal msg_type "player_action");
  let state = apply_action state i_player_col in
  let res_row, res_col = get_last_move state in
  let%lwt () =
    encode_csv [ "player_action"; string_of_int res_row; string_of_int res_col ]
    |> Dream.send ws
  in
  after_place ws msg state diff

and process_new_game ws msg =
  (* game initialization *)
  let [ msg_type; game_mode; diff; block_mode; rows; cols ] =
    msg |> decode_csv
  in
  assert (String.equal msg_type "new_game");
  assert (String.equal game_mode "player-vs-agent");
  let i_rows = int_of_string rows in
  let i_cols = int_of_string cols in
  let shared_commands state =
    (* receive `player_action` *)
    match%lwt Dream.receive ws with
    | None -> Dream.close_websocket ws
    | Some msg -> process_player_action ws msg state diff
  in
  (* assert (String.equal block_mode "none"); *)
  match block_mode with
  | "none" ->
      let state = Connect4.initial_state i_rows i_cols 1 in
      shared_commands (C_st state)
  | _ -> (
      let rand_col = Random.int i_cols in
      (* let rand_row = Random.int i_rows in *)
      let rand_row = i_rows - 1 in
      let s_rand_col = string_of_int rand_col in
      let s_rand_row = string_of_int rand_row in
      print_endline s_rand_col;
      print_endline s_rand_row;
      match block_mode with
      | "random" ->
          let state =
            Connect4_ban.initial_state i_rows i_cols 1 (rand_row, rand_col)
          in
          let%lwt () =
            encode_csv [ "block_action"; s_rand_row; s_rand_col ]
            |> Dream.send ws
          in
          shared_commands (C_ban_st state)
      | "reward" ->
          let state =
            Connect4_bonus.initial_state i_rows i_cols 1 (rand_row, rand_col)
          in
          let%lwt () =
            encode_csv [ "bonus_action"; s_rand_row; s_rand_col ]
            |> Dream.send ws
          in
          shared_commands (C_bonus_st state))

and process (ws : Dream.websocket) : unit Lwt.t =
  (* receive `new_game` *)
  match%lwt Dream.receive ws with
  | None -> Dream.close_websocket ws
  | Some msg -> process_new_game ws msg

let () =
  Dream.run @@ Dream.logger
  @@ Dream.router
       [
         Dream.get "/" (fun _ -> Dream.html (html_path |> In_channel.read_all));
         Dream.get "/static/**" (Dream.static static_dir);
         Dream.get "/websocket" (fun _ -> Dream.websocket process);
       ]
