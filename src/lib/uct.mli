type t = { mutable root : Tree.node }

val create_uct : bool -> int -> int -> int -> int -> t
(** [create_uct player h w ban_x ban_y] creates a new UCT instance.
    - [player]: The starting player (true for the current program, false for the opponent).
    - [h], [w]: The height and width of the game board.
    - [ban_x], [ban_y]: The coordinates of the banned cell on the board. *)

val tree_policy : t -> Tree.node
(** [tree_policy uct] performs a tree policy traversal on the UCT tree, 
    returning the node selected for simulation.
    - [uct]: The UCT instance to perform the tree policy on. *)

val get_best_move : t -> int * int
(** [get_best_move uct] runs simulations and returns the best move as a pair of coordinates.
    - [uct]: The UCT instance used for the move selection. *)

val move_root : t -> State.point -> unit
(** [move_root uct point] updates the root of the UCT tree based on the opponent's move.
    - [uct]: The UCT instance to update.
    - [point]: The coordinates of the opponent's last move. *)
