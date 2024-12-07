type node = {
  state : State.t; (* The state associated with this node *)
  mutable parent : node option; (* The parent of the node *)
  mutable first_child : node option; (* The first child node *)
  mutable next_sibling : node option; (* The next sibling node *)
  mutable win : int; (* Number of wins for this node *)
  mutable visit : int; (* Number of visits for this node *)
}

val create_node : State.t -> node option -> node
val ucb1 : node -> node -> float
val expand : node -> node option
val best_child : node -> node option
val backup : node -> int -> unit
