# Web Connect4 Game in OCaml

## Overview

Our final goal is to implement a web gravity Connect4 game, where the player can play the game against the agent we trained by reinforcement learning algorithms in web browsers.

## Progress & TODO

### Backend

- [x] UCT algorithm implemented in OCaml
  
  We have implemented a variant of the Monte Carlo Tree Search algorithm, called UCT (Upper Confidence bounds applied to Trees), to train the agent. To avoid directly loading the winning strategy and showcase the robustness of our implemented UCT algorithm, a random obstacle is placed on the board at the beginning of each game.

  See detailed logic at [gamelogic.md](gamelogic.md).
  
  Specifically, the algorithm is structured as follows:
  - `Judge` provides functions to check if the game is over and who wins the game
  - `State` provides functions to create and manipulate the game state, including making moves and checking the game status
  - `Strategy` provides the main function to get the next move of our agent based on the current game state
  - `Tree` provides functions to create and manipulate the nodes of the UCT tree, including expansion and selection of the best child node
  - `Uct` provides the main UCT algorithm, including tree policy, simulation, and backpropagation

- [ ] A few strategy functionalities to implement

### Frontend

- [x] Web UI in JavaScript, where user can play against with a dummy agent (always place the piece at the second column)

- [ ] Replace the JavaScript with ReScript

  This is [half-done](rs/chess/src/chess.res) with minor issues (handling 2D array), but for demonstration purpose, we still use JavaScript in the frontend

## Workload Justification

- **30% progress**: We are over the halfway of the project and only remains a few functionalities to implement. There are 708 lines in total (`find src src-test -type f -name "*.ml*" | xargs cat | wc -l`).
- **3% evidence of a library**: code is modulized well in `src/lib`
- **3% has enough algorithmic complexity**: UCT algorithms is complex and would have a competitive performance against human players.
  <details>
  <summary>Pseudo Code for UCT</summary>

  ```text
  function UCTSEARCH(s0)
    Create the root node v0 from the state s0;
    while there is remaining computation time do:
      vL ← TREEPOLICY(v0);
      Δ ← DEFAULTPOLICY(state(vL));
      BACKUP(vL, Δ);
    end while
    return a(BESTCHILD(v0, 0));

  function TREEPOLICY(v)
    while the node v is not a terminal node do:
      if v is expandable then:
        return EXPAND(v)
      else:
        v ← BESTCHILD(v, c)
    return v

  function EXPAND(v)
    Choose an action a from the set of actions A(state(v)) that has not been chosen before;
    Add a new child node v′ to node v such that state(v′) = f(state(v), a), action(v′) = a;
    return v′

  function BESTCHILD(v, c)
    return argmaxv′ ∈ children of v (Q(v′) + c * √2 * ln(N(v)))

  function DEFAULTPOLICY(s)
    while s is not a terminal state do:
      Randomly choose an action a from the set of actions A(s);
      s ← f(s, a)
    return the reward of the state s

  function BACKUP(v, Δ)
    while v ≠ NULL do:
      N(v) ← N(v) + 1
      Q(v) ← Q(v) + Δ
      Δ ← −Δ
      v ← parent(v)
  ```

  </details>
- **24% module design and structure**: the code structure follows the convention in assignments like `src/bin`, `src/lib`, `src-test`, and has documentations in all the `.mli` files
- **25% code quality**: the code is modulized well and formatted with `.ocamlformat`
- **15% tests**: `src-test` has a 37.42% coverage of the codebase (`dune test && bisect-ppx-report summary`)
