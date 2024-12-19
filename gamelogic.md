# Connect-Four Game Rules and Experiment Overview

## Game Rules

In this game, two players compete using pieces of different colors. Assume:

- **Player A** holds white pieces.
- **Player B** holds black pieces.
- **Player A** plays first.

### Gameplay

1. The game is played on a grid of **M rows** and **N columns**.
2. Players take turns dropping a piece into one of the columns.
   - Each piece falls to the **lowest available position** in the chosen column.
   - If a column is full, no further pieces can be dropped in that column.
3. The graphical interface allows players to click any cell in a column, automatically placing the piece at the lowest available position in that column.

### Winning Condition

A player wins by aligning **four or more of their pieces** in any of the following directions:
- Horizontally
- Vertically
- Diagonally (both directions)

If neither player achieves this by the time the grid is completely filled, the game ends in a **draw**.

---

## Rules and Enhancements

### Motivation for Enhancements

Some configurations of Connect-Four grids have **perfect strategies** that guarantee one player's victory. For example:

- On a **6x7 board**, a well-known algorithm ensures that the first player (Player A) can force a win.

To prevent such deterministic outcomes and ensure meaningful evaluations, we have introduced **enhanced rules** for this game.

---

### Rule Enhancements

1. **Randomized Grid Size**:
   - The grid's dimensions are randomly selected within the range **[4, 12]** for both width (columns) and height (rows).
   - This introduces variability, as not all board sizes have pre-determined winning strategies.

2. **Restricted Cells**:
   - After the grid is generated, **one random cell** is marked as a **forbidden position**, indicated by a red "X" on the board.
   - Players cannot place a piece in this cell. If a piece is dropped into the column containing the forbidden position, the next available position is adjusted accordingly.

3. **Bonus Cell**
    - In the bonus cell game mode, we create a random bonus cell on the board. The player who put piece on the bonus cell can immediately put a ban point for both players as a piece.

Given these modifications, the task of our agent is to develop a strategy that is **adaptive and versatile**.


# UCT Algorithm
The **Upper Confidence Bounds for Trees (UCT)** algorithm is a popular method for decision-making in environments such as games or planning problems. It is a key part of Monte Carlo Tree Search (MCTS) and uses the exploration-exploitation trade-off to iteratively simulate moves and evaluate the potential of different actions.

In the UCT algorithm, the objective is to explore a decision tree and select the most promising moves based on the results of simulations. It works by balancing two main objectives:
- **Exploration**: Trying out different actions that have not been explored thoroughly to see their potential.
- **Exploitation**: Focusing on actions that have shown high rewards based on past experience.

This balance is managed using **Upper Confidence Bounds (UCB)**, which quantifies the confidence in the estimated values of each action. UCT uses the **UCB1 formula** to select actions, which guides the algorithm toward promising parts of the tree while still exploring unvisited branches. The core components of the UCT algorithm involve the **Tree Policy**, **Default Policy**, and **Backup** functions, which are executed repeatedly during simulations to refine the decision tree.

## a simple abstract of the algorithm 
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
