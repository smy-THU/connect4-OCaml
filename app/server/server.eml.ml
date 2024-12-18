open Core

let html_path = "./index.html"
let static_dir = "./static"

let rec process (ws : Dream.websocket) : unit Lwt.t =
  match%lwt Dream.receive ws with
  (* `Some msg` is from `ws.send` *)
  | Some msg ->
      (* handle msg *)
      print_endline msg;
      (* let%lwt () = json_string |> Dream.send ws in *)
      let%lwt () = "invalid_action" |> Dream.send ws in
      let%lwt () = "player_action,2,2" |> Dream.send ws in
      let%lwt () = "agent_action,3,2" |> Dream.send ws in
      (* listen next msg *)
      process ws
  | _ ->
      let%lwt () = "[wpg.backend] invalid msg" |> Dream.send ws in
      Dream.close_websocket ws

let () =
  Dream.run @@ Dream.logger
  @@ Dream.router
       [
         Dream.get "/" (fun _ -> Dream.html (html_path |> In_channel.read_all));
         Dream.get "/static/**" (Dream.static static_dir);
         Dream.get "/websocket" (fun _ -> Dream.websocket process);
       ]
