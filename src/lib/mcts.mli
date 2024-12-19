module type Game = sig
  type state
  type action

  val is_terminal : state -> bool
  val evaluate : state -> float
  val generate_actions : state -> action list
  val apply_action : state -> action -> state
end

module Make (G : Game) : sig
  type node = {
    state : G.state;
    action : G.action option;
    mutable wins : float;
    mutable visits : int;
    mutable children : node list;
    parent : node option;
  }
  (** A node in the MCTS tree.
      @param state The state of the game at this node.
      @param action The action that led to this node (None for root).
      @param wins The total wins recorded for this node.
      @param visits The total number of visits to this node.
      @param children The list of child nodes.
      @param parent The parent node (None for root). *)

  val create_node :
    ?action:G.action option -> ?parent:node option -> G.state -> node
  (** Creates a new node.
      @param state The state of the game at the node.
      @param action Optional action that led to this node (default: None).
      @param parent Optional parent node (default: None).
      @return A new node with the specified state, action, and parent. *)

  val ucb1 : node -> int -> float -> float
  (** Calculates the Upper Confidence Bound for Trees (UCB1) value for a child
      node.
      @param child The child node to calculate the value for.
      @param total_visits The total number of visits to the parent node.
      @param exploration The exploration constant.
      @return The UCB1 value for the child node. *)

  val select_best_node : node -> float -> node
  (** Selects the best child node based on the UCB1 value.
      @param node The parent node.
      @param exploration The exploration constant.
      @return The child node with the highest UCB1 value. *)

  val expand : node -> unit
  (** Expands a node by generating its child nodes.
      @param node The node to expand.
      @return Unit. The children of the node are updated in place. *)

  val simulate : G.state -> float
  (** Simulates a random playout from a given state.
      @param state The starting state for the simulation.
      @return The evaluation result of the terminal state reached. *)

  val backpropagate : node -> float -> unit
  (** Backpropagates the result of a simulation up the tree.
      @param node The leaf node where the simulation ended.
      @param result The result of the simulation.
      @return Unit. The wins and visits of the nodes in the path are updated. *)

  val search : G.state -> int -> float -> G.action
  (** Runs the MCTS algorithm to find the best action.
      @param root_state The initial state of the game.
      @param iterations The number of iterations to perform.
      @param exploration The exploration constant for UCB1.
      @return The best action found by the algorithm. *)
end
