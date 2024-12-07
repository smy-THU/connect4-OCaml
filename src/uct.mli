type t = { mutable root : Tree.node }

val create_uct : bool -> int -> int -> int -> int -> t
val tree_policy : t -> Tree.node
val get_best_move : t -> int * int
