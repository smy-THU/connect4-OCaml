type node = {
  state : State.t; (* The state associated with this node *)
  mutable parent : node option; (* The parent of the node *)
  mutable first_child : node option; (* The first child node *)
  mutable next_sibling : node option; (* The next sibling node *)
  mutable win : int; (* Number of wins for this node *)
  mutable visit : int; (* Number of visits for this node *)
}

val create_node : State.t -> node option -> node
(** [create_node state parent] creates a new node with the given state and parent.
    @param state The state associated with the new node.
    @param parent The parent of the new node.
    @return The newly created node. *)

val ucb1 : node -> node -> float
(** [ucb1 parent child] calculates the UCB1 score for a child node.
    @param parent The parent node.
    @param child The child node.
    @return The UCB1 score for the child node. *)

val expand : node -> node option
(** [expand node] expands the given node by creating a new child node.
    @param node The node to be expanded.
    @return [Some child] if a new child node is created, [None] otherwise. *)

val best_child : node -> node option
(** [best_child node] finds the best child node based on the UCB1 score.
    @param node The node whose best child is to be found.
    @return [Some best_child] if a best child is found, [None] otherwise. *)

val backup : node -> int -> unit
(** [backup node delta] updates the win and visit counts for the node and its ancestors.
    @param node The node to be updated.
    @param delta The value to be added to the win count.
    @return [unit] *)
