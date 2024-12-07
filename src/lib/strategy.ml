(*
open Printf


(* Helper function to check if the game is new *)
let is_new_game board =
  Array.fold_left (fun acc row -> acc + Array.fold_left ( + ) 0 row) 0 board <= 2

(* Function to clear the board resources (not needed in OCaml due to garbage collection) *)
let clear_board _ = ()

(* The main strategy function *)
let get_point m n top board last_x last_y no_x no_y =
  (* Static variables to persist state between calls *)
  (* let module State = struct
    let uct = ref None
    let my_move = ref { x = -1; y = -1 }
  end in *)

  (* Initialize the state if it’s a new game *)
  if is_new_game board then (
    printf "A new game is started.\n";
    (* State.create_state true m n no_x no_y; *)

    (* Create a new UCT instance *)
    State.uct :=
      Some
        (if last_x = -1 && last_y = -1 then
           Uct.create_uct true m n no_x no_y(* Start with the current player *)
         else (
           let uct = Uct.create_uct false m n no_x no_y (* Opponent starts *)
           in
           Uct.move_root uct (last_x, last_y);
           uct
         ))
  ) else (
    (* If not a new game, update the UCT tree *)
    match !(State.uct) with
    | None -> failwith "UCT is not initialized!"
    | Some uct ->
        (* Update moves for both players *)
        Uct.move_root uct !(State.my_move);
        Uct.move_root uct (last_x, last_y)
  );

  (* Get the best move from the UCT *)
  match !(State.uct) with
  | None -> failwith "UCT is not initialized!"
  | Some uct ->
      let move = Uct.get_best_move uct in
      State.my_move := move;
      printf "I move to (%d, %d)\n" move.x move.y;
      move


*)
[@@@ocaml.warning "-27"]
let get_point m n top board last_x last_y no_x no_y =
  failwith "unimplemented"