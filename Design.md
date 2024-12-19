# Project Design Proposal

## Overview

We are going to implement a interactive web Connect4 game, where the player can play against an agent trained by reinforcement learning algorithms (i.e., Monte Carlo Tree Search). For the web application design and implementation, we will use the `dream` library and ReScript in replacement of JavaScript.

## Mock Use

1. Enter [`src`](src) and run [run.sh](src/run.sh) to start the server
2. Then open the browser and visit `http://localhost:8080/` to play the game

## Libraries and Demo

- Dependencies: see [src/connect4.opam](src/connect4.opam)
- Demo usage: enter [demo/dream](demo/dream) and run [run.sh](demo/dream/run.sh)

## Module Type Declarations
There are 3 functors
