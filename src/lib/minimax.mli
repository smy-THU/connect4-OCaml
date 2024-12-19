module type Game = sig
  type state
  (** Represents the state of the game. *)

  type action
  (** Represents an action that can be taken in the game. *)

  val is_terminal : state -> bool
  (** [is_terminal state] checks if the given [state] is a terminal state (i.e.,
      the game is over). *)

  val evaluate : state -> float
  (** [evaluate state] computes the evaluation score for the given [state].
      - A positive score favors the maximizing player.
      - A negative score favors the minimizing player. *)

  val generate_actions : state -> action list
  (** [generate_actions state] generates a list of possible actions from the
      given [state]. *)

  val apply_action : state -> action -> state
  (** [apply_action state action] applies the given [action] to the [state] and
      returns the resulting state. *)
end

module Make (G : Game) : sig
  val minimax : G.state -> int -> bool -> float
  (** [minimax state depth maximizing] computes the optimal score for the given
      [state].
      - [state]: The current game state.
      - [depth]: The remaining depth to search in the game tree.
      - [maximizing]: If true, the algorithm tries to maximize the score.
        Otherwise, it minimizes the score.

      @return The optimal score for the given state. *)

  val best_action : G.state -> int -> G.action
  (** [best_action state depth] finds the best action for the maximizing player
      in the given [state].
      - [state]: The current game state.
      - [depth]: The depth limit for the minimax search.

      @return
        The action that leads to the best possible outcome for the maximizing
        player. *)
end
