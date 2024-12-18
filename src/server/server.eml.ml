[@@@ocaml.warning "-8-27"]

open Core

let html_path = "./index.html"
let static_dir = "./static"
let decode_csv (line : string) : string list = line |> String.split ~on:','
let encode_csv (line : string list) : string = line |> String.concat ~sep:","

(* let%lwt () = "new_game,player-vs-agent,1" |> Dream.send ws in *)
(* process ws *)
(* let%lwt () = "invalid_action" |> Dream.send ws in *)
(* let%lwt () = "player_action,1,1" |> Dream.send ws in
   let%lwt () = "agent_action,2,2" |> Dream.send ws in
   let%lwt () = "block_action,0,0" |> Dream.send ws in *)
(* let%lwt () = "game_end,tie" |> Dream.send ws in *)
(* listen next msg *)

(* let new_game game_mode diff block_mode rows cols ws =
     let state =
       match block_mode with
       | "none" -> Connect4.initial_state rows cols 1
       | _ -> (
           let rand_col = Random.int cols in
           let rand_row = Random.int rows in
           let s_rand_col = string_of_int rand_col in
           let s_rand_row = string_of_int rand_row in
           match block_mode with
           | "random" ->
               Dream.send ws
               @@ encode_csv [ "block_action"; s_rand_row; s_rand_col ];
               Connect4_ban.initial_state rows cols 1 (rand_row, rand_col)
           | "reward" ->
               Dream.send ws
               @@ encode_csv [ "bonus_action"; s_rand_row; s_rand_col ];
               Connect4_bonus.initial_state rows cols 1 (rand_row, rand_col))
     in
     match game_mode with
     | "player-vs-player" -> failwith "unimplemented"
     | "player-vs-agent" ->


   module Agent = match diff with
      | "easy" ->  Minimax.Make()    minimax
      | "medium" -> alpha_beta
      | "hard" -> mcts

   let handle_player_action row col state =
     if Connect4.is_terminal state then
       let result =
         match Connect4.evaluate state with
         | 1.0 ->
             let winner =
               match game_mode with
               | "player-vs-player" -> "player2"
               | "player-vs-agent" -> "agent"
             in
             "game_end," ^ winner
         | -1.0 ->
             let winner =
               match game_mode with
               | "player-vs-player" -> "player1"
               | "player-vs-agent" -> "player"
             in
             "game_end," ^ winner
         | 0.0 -> "game_end,tie"
         | _ -> ()
       in
       let%lwt () = result |> Dream.send ws in
       process ws
     else failwith "unimplemented"

   let state = ref @@ Connect4.initial_state 6 6 1
   let agent
*)

(* let process (ws : Dream.websocket) : unit Lwt.t =
   match%lwt Dream.receive ws with
   | Some msg -> (
       print_endline msg;
       let msg_data = msg |> decode_csv in
       let msg_type = List.hd msg_data in
       match msg_type with
       | Some "new_game" -> process_new_game msg ws
       | Some "player_action" ->
           let [ row; col ] = List.tl_exn msg_data in
           let state = handle_player_action row col state in
           process ws
       | Some _ | None -> Dream.close_websocket ws)
   | None -> Dream.close_websocket ws *)
module C4Minimax = Minimax.Make (Connect4)
module C4Alpha = Alpha_beta.Make (Connect4)
module C4Mcts = Mcts.Make (Connect4)

let state_to_winner state =
  let is_end = Connect4.is_terminal state in
  match is_end with
  | true -> (
      match Connect4.evaluate state with
      | 1.0 -> "agent"
      | -1.0 -> "player"
      | 0.0 -> "tie"
      | _ -> "continue")
  | false -> "continue"

let rec process_player_action ws msg state diff =
  (* player move *)
  let [ msg_type; player_row; player_col ] = msg |> decode_csv in
  assert (String.equal msg_type "player_action");
  let state = Connect4.apply_action state (int_of_string player_col) in
  let res_row, res_col = state.last_move in
  let%lwt () =
    encode_csv [ "player_action"; string_of_int res_row; string_of_int res_col ]
    |> Dream.send ws
  in
  match state_to_winner state with
  | "continue" -> (
      (* agent move *)
      print_endline "Agent is thinking...";
      let agent_action =
        (* different agent *)
        match diff with
        | "easy" -> C4Minimax.best_action state 6
        | "medium" -> C4Alpha.search state 8
        | "hard" -> C4Mcts.search state 100000 0.7
        | _ -> failwith "invalid difficulty"
      in
      print_endline @@ "Agent chooses column: " ^ string_of_int agent_action;
      let state = Connect4.apply_action state agent_action in
      let res_row, res_col = state.last_move in
      let%lwt () =
        encode_csv
          [ "agent_action"; string_of_int res_row; string_of_int res_col ]
        |> Dream.send ws
      in
      match state_to_winner state with
      | "continue" -> (
          (* receive new `player_action` *)
          match%lwt Dream.receive ws with
          | None -> Dream.close_websocket ws
          | Some msg -> process_player_action ws msg state diff)
      | winner ->
          Core_unix.sleep 1;
          let%lwt () = encode_csv [ "game_end"; winner ] |> Dream.send ws in
          process ws)
  | winner ->
      Core_unix.sleep 1;
      let%lwt () = encode_csv [ "game_end"; winner ] |> Dream.send ws in
      process ws

and process_new_game ws msg =
  (* game initialization *)
  let [ msg_type; game_mode; diff; block_mode; rows; cols ] =
    msg |> decode_csv
  in
  assert (String.equal msg_type "new_game");
  assert (String.equal game_mode "player-vs-agent");
  assert (String.equal block_mode "none");
  (* assert (String.equal diff "easy"); *)
  let state =
    Connect4.initial_state (int_of_string rows) (int_of_string cols) 1
  in
  (* receive `player_action` *)
  match%lwt Dream.receive ws with
  | None -> Dream.close_websocket ws
  | Some msg -> process_player_action ws msg state diff

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
