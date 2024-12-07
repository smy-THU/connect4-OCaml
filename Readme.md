# Web Connect4 Game in OCaml

## Overview

Our final goal is to implement a web Connect4 game, where the player can play Connect4 game against the agent we trained by reinforcement learning algorithms in web browsers.


## Progress & TODO

### Backend

- [x] UCT algorithm implemented in OCaml
Specifically, we have implemented a variant of the Monte Carlo Tree Search algorithm, called UCT (Upper Confidence bounds applied to Trees), to train the agent. To avoid loading the 必胜策略 and showcase the robustness of our implemented UCT algorithm, a random block is placed on the board at the beginning of each game.
- [ ] Fix issues in the UCT algorithm implementation
- [ ] 
### Frontend

- [x] Simple frontend with JavaScript, where user can play with a dummy policy of the agent
- [ ] Replace the JavaScript with ReScript

