module type Game = sig
    (** Represents the state of the game. *)
    type state
  
    (** Represents an action that can be taken in the game. *)
    type action
  
    (** [is_terminal state] checks if the given [state] is a terminal state (i.e., the game is over). *)
    val is_terminal : state -> bool
  
    (** [evaluate state] computes the evaluation score for the given [state].
        - A positive score favors the maximizing player.
        - A negative score favors the minimizing player.
    *)
    val evaluate : state -> float
  
    (** [generate_actions state] generates a list of possible actions from the given [state]. *)
    val generate_actions : state -> action list
  
    (** [apply_action state action] applies the given [action] to the [state] and returns the resulting state. *)
    val apply_action : state -> action -> state
  end
  
  module Make (G : Game) : sig
    (** [minimax state depth maximizing] computes the optimal score for the given [state].
        - [state]: The current game state.
        - [depth]: The remaining depth to search in the game tree.
        - [maximizing]: If true, the algorithm tries to maximize the score. Otherwise, it minimizes the score.
        @return The optimal score for the given state.
    *)
    val minimax : G.state -> int -> bool -> float
  
    (** [best_action state depth] finds the best action for the maximizing player in the given [state].
        - [state]: The current game state.
        - [depth]: The depth limit for the minimax search.
        @return The action that leads to the best possible outcome for the maximizing player.
    *)
    val best_action : G.state -> int -> G.action
  end
  