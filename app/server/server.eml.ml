open Core

[@@@ocaml.warning "-8-27"]

let html_path = "./index.html"
let static_dir = "./static"
let parse_csv_line (line : string) : string list = line |> String.split ~on:','

(* let%lwt () = "new_game,player-vs-agent,1" |> Dream.send ws in *)
(* process ws *)
(* let%lwt () = "invalid_action" |> Dream.send ws in *)
(* let%lwt () = "player_action,1,1" |> Dream.send ws in
   let%lwt () = "agent_action,2,2" |> Dream.send ws in
   let%lwt () = "block_action,0,0" |> Dream.send ws in *)
(* let%lwt () = "game_end,tie" |> Dream.send ws in *)
(* listen next msg *)

let rec process (ws : Dream.websocket) : unit Lwt.t =
  match%lwt Dream.receive ws with
  | Some msg -> (
      print_endline msg;
      let msg_data = msg |> parse_csv_line in
      let msg_type = List.hd msg_data in
      match msg_type with
      | Some "new_game" ->
          (* let [ game_mode; difficulty; block_mode; board_rows; board_cols ] =
               List.tl_exn msg_data
             in *)
          process ws
      | Some "player_action" -> process ws
      | None -> Dream.close_websocket ws)

let () =
  Dream.run @@ Dream.logger
  @@ Dream.router
       [
         Dream.get "/" (fun _ -> Dream.html (html_path |> In_channel.read_all));
         Dream.get "/static/**" (Dream.static static_dir);
         Dream.get "/websocket" (fun _ -> Dream.websocket process);
       ]
