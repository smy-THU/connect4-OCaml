module type Game = sig
  type state
  type action

  val is_terminal : state -> bool
  val evaluate : state -> float
  val generate_actions : state -> action list
  val apply_action : state -> action -> state
end

module Make (G : Game) : sig
  val minimax :
    G.state -> int -> float -> float -> bool -> float * G.action option
  (** [minimax state depth alpha beta maximizing] computes the minimax value of
      the given [state] with alpha-beta pruning.

      @param state the current state of the game
      @param depth the depth limit for the search
      @param alpha the best value that the maximizing player can guarantee
      @param beta the best value that the minimizing player can guarantee
      @param maximizing
        true if the current player is the maximizing player, otherwise false
      @return
        a pair where the first element is the computed value and the second
        element is the best action *)

  val search : G.state -> int -> G.action
  (** [search state depth] performs a minimax search with alpha-beta pruning and
      returns the best action.

      @param state the current state of the game
      @param depth the depth limit for the search
      @return the best action determined by the algorithm *)
end
