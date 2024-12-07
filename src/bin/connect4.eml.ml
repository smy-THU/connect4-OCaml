open Core

let app_path : string = "./app/"
let index_path : string = "c4.html"
let assets_path : string = "assets/"

let home (index_path : string) : string =
  let html_path = app_path ^ index_path in
  html_path |> In_channel.read_all

let rec process (ws : Dream.websocket) : unit Lwt.t =
  match%lwt Dream.receive ws with
  (* `Some msg` is from `ws.send` *)
  | Some msg ->
      (* handle msg *)
      print_endline msg;
      let which_col = 1 in
      let%lwt () = string_of_int which_col |> Dream.send ws in
      (* listen next msg *)
      process ws
  | _ ->
      let%lwt () = "[wpg.backend] invalid msg" |> Dream.send ws in
      Dream.close_websocket ws

let () =
  Dream.run @@ Dream.logger
  @@ Dream.router
       [
         (* behavior for GET request *)
         Dream.get "/" (fun _ -> Dream.html (home index_path));
         Dream.get "/assets/**" (Dream.static @@ app_path ^ assets_path);
         Dream.get "/websocket" (fun _ -> Dream.websocket process);
       ]
