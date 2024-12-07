type point = int * int

type t = {
  mutable player : bool;         (* true for player, false for machine *)
  mutable next_choice : int;     (* Column choice for the next move *)
  board : int array array;       (* 2D board array where 0 = empty, 1 = player, 2 = machine *)
  top : int array;               (* Tracks the topmost unoccupied row in each column *)
  h: int;
  w: int;
  ban_x: int;
  ban_y: int;
  mutable last_put : point;      (* Last (x, y) coordinates where a move was made *)
}

val create_state : bool -> int -> int -> int -> int -> t
val copy_state : t -> t
val next_state : t -> int -> int -> t
val random_put : t -> int * int
val default_policy : t -> int
val print_state : t -> unit
val next_choice_state : t -> t option