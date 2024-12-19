<h1 style="text-align: center;">Web-Based Gravity Connect-4 Game</h1>

<p align="center">
  <a href="https://ocaml.org/"><img src="https://img.shields.io/badge/Backend-OCaml-orange" alt="OCaml"></a>
  <a href="https://rescript-lang.org/"><img src="https://img.shields.io/badge/Frontend-ReScript-blue" alt="ReScript"></a>
  <a href="https://aantron.github.io/dream/"><img src="https://img.shields.io/badge/WebServer-Dream-purple" alt="Dream"></a>
</p>

## 🔭 Overview 🔭

This repo implements a web-based Gravity Connect-4 with [OCaml](https://ocaml.org/) backend and [ReScript](https://rescript-lang.org/) frontend, communicating via [Dream](https://aantron.github.io/dream/).

> **What is *Gravity Connect-4?***
> - Whoever connects 4 pieces in a row, column, or diagonal wins the game
> - In *Gravity* Connect-4, pieces fall to the lowest available spot in the column

## 🛠️ Usage 🛠️

```sh
cd src
dune clean && dune build
dune test && bisect-ppx-report html # optional
npm install
npm run start
```
then visit http://localhost:8080 to play the game! 🤩

## ✨ Features ✨

🎮 **3 Levels of Agent Difficulty to Test Your Skills**  
- 🟢 **Easy**: Powered by the [**Minimax Algorithm**](https://en.wikipedia.org/wiki/Minimax) – Perfect for beginners.  
- 🟡 **Medium**: Enhanced with [**Alpha-Beta Pruning**](https://en.wikipedia.org/wiki/Alpha%E2%80%93beta_pruning) – A balanced challenge awaits!  
- 🔴 **Hard**: Masterfully crafted with [**Monte-Carlo Tree Search**](https://en.wikipedia.org/wiki/Monte_Carlo_tree_search) – Can you outsmart the smartest?  

🧩 **Classic Gameplay + 2 Exciting New Variants!**  
- **Traditional Mode**: Relive the nostalgic experience you love!  
- **Random Blocker Mode**: Adds unpredictability with **randomly placed blockers**.  
- **Reward Mode**: Reach the **special reward spot** to place an extra blocker – strategy at its finest!  

🤝 **Choose Who Goes First!**  
- **You First**: Take control of the game and strategize your way to victory.  
- **Agent First**: Bring your A-game against our powerful AI opponents.  

📏 **Customizable Board Sizes (6x6 to 12x12)**  
- **Compact Boards**: Perfect for quick, casual games.  
- **Larger Boards**: Explore endless strategies and more thrilling challenges!  

🌟 **Your Perfect Blend of Strategy, Fun, and Competition Awaits!** 🌟 
