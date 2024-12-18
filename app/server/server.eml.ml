open Core

let html_path = "./index.html"
let static_dir = "./static"

let () =
  Dream.run @@ Dream.logger
  @@ Dream.router
       [
         Dream.get "/" (fun _ -> Dream.html (html_path |> In_channel.read_all));
         Dream.get "/static/**" (Dream.static static_dir);
       ]
