// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Belt_Array from "rescript/lib/es6/belt_Array.js";
import * as Caml_int32 from "rescript/lib/es6/caml_int32.js";
import * as Belt_Option from "rescript/lib/es6/belt_Option.js";
import * as Caml_format from "rescript/lib/es6/caml_format.js";
import * as Caml_option from "rescript/lib/es6/caml_option.js";
import * as Core__Array from "@rescript/core/src/Core__Array.res.mjs";
import * as Webapi__Dom__Element from "rescript-webapi/src/Webapi/Dom/Webapi__Dom__Element.res.mjs";
import * as Webapi__Dom__HtmlInputElement from "rescript-webapi/src/Webapi/Dom/Webapi__Dom__HtmlInputElement.res.mjs";
import * as Webapi__Dom__HtmlSelectElement from "rescript-webapi/src/Webapi/Dom/Webapi__Dom__HtmlSelectElement.res.mjs";

var host = window.location.host;

var socket = new WebSocket("ws://" + host + "/websocket");

function initializeGameState(rows, cols) {
  return Core__Array.make(rows, Core__Array.make(cols, "empty"));
}

var isPlayerTurn = {
  contents: true
};

var enableNewGame = {
  contents: true
};

var gameMode = {
  contents: ""
};

var agentDifficulty = {
  contents: ""
};

var blockMode = {
  contents: ""
};

var boardRows = {
  contents: -1
};

var boardCols = {
  contents: -1
};

function handleCellClick(row, col) {
  if (isPlayerTurn.contents) {
    var s_row = String(row);
    var s_col = String(col);
    isPlayerTurn.contents = false;
    socket.send("player_action," + s_row + "," + s_col);
    return ;
  }
  window.alert("It's not your turn");
}

function createCell(row, col) {
  var cell = document.createElement("div");
  cell.className = "cell";
  var s_row = String(row);
  var s_col = String(col);
  cell.setAttribute("id", "cell-r" + s_row + "-c" + s_col);
  cell.addEventListener("click", (function (param) {
          handleCellClick(row, col);
        }));
  return Belt_Option.getExn(Webapi__Dom__Element.asHtmlElement(cell));
}

function renderBoard() {
  var rows = boardRows.contents;
  var cols = boardCols.contents;
  var s_rows = String(rows);
  var s_cols = String(cols);
  var board = Belt_Option.getExn(Caml_option.nullable_to_opt(document.getElementById("board")));
  board.innerHTML = "";
  var board_style = Belt_Option.getExn(Webapi__Dom__Element.asHtmlElement(board)).style;
  board_style.setProperty("grid-template-columns", "repeat(" + s_cols + ", 50px)", "");
  board_style.setProperty("grid-template-rows", "repeat(" + s_rows + ", 50px)", "");
  for(var i = 0 ,i_finish = Math.imul(rows, cols); i < i_finish; ++i){
    var cell = createCell(Caml_int32.div(i, cols), Caml_int32.mod_(i, cols));
    board.appendChild(cell);
  }
}

function new_game($$event) {
  $$event.preventDefault();
  var mode_element = Belt_Option.getExn(Caml_option.nullable_to_opt(document.getElementById("game-mode")));
  var mode_element$1 = Belt_Option.getExn(Webapi__Dom__HtmlSelectElement.ofElement(mode_element));
  gameMode.contents = mode_element$1.value;
  var difficulty_element = Belt_Option.getExn(Caml_option.nullable_to_opt(document.getElementById("agent-difficulty")));
  var difficulty_element$1 = Belt_Option.getExn(Webapi__Dom__HtmlSelectElement.ofElement(difficulty_element));
  agentDifficulty.contents = difficulty_element$1.value;
  var block_element = Belt_Option.getExn(Caml_option.nullable_to_opt(document.getElementById("block-mode")));
  var block_element$1 = Belt_Option.getExn(Webapi__Dom__HtmlSelectElement.ofElement(block_element));
  blockMode.contents = block_element$1.value;
  var row_element = Belt_Option.getExn(Caml_option.nullable_to_opt(document.getElementById("board-rows")));
  var row_element$1 = Belt_Option.getExn(Webapi__Dom__HtmlInputElement.ofElement(row_element));
  boardRows.contents = Caml_format.int_of_string(row_element$1.value);
  var col_element = Belt_Option.getExn(Caml_option.nullable_to_opt(document.getElementById("board-cols")));
  var col_element$1 = Belt_Option.getExn(Webapi__Dom__HtmlInputElement.ofElement(col_element));
  boardCols.contents = Caml_format.int_of_string(col_element$1.value);
  if (enableNewGame.contents) {
    renderBoard();
    enableNewGame.contents = false;
    isPlayerTurn.contents = true;
    console.log("=============================");
    console.log("gameMode        : ", gameMode.contents);
    console.log("agentDifficulty : ", agentDifficulty.contents);
    console.log("blockMode       : ", blockMode.contents);
    console.log("boardRows       : ", boardRows.contents);
    console.log("boardCols       : ", boardCols.contents);
    console.log("-----------------------------");
    console.log("isPlayerTurn    : ", isPlayerTurn.contents);
    console.log("enableNewGame   : ", enableNewGame.contents);
    console.log("=============================");
    var param_list = [
      gameMode.contents,
      agentDifficulty.contents,
      blockMode.contents,
      String(boardRows.contents),
      String(boardCols.contents)
    ];
    socket.send(Belt_Array.reduce(param_list, "new_game", (function (acc, x) {
                return acc + "," + x;
              })));
    return ;
  }
  window.alert("You can't start a new game now.");
}

Belt_Option.getExn(Caml_option.nullable_to_opt(document.getElementById("board-size-form"))).addEventListener("submit", new_game);

function updateBoard(s_row, s_col, value) {
  var cell_id = "cell-r" + s_row + "-c" + s_col;
  Belt_Option.getExn(Caml_option.nullable_to_opt(document.getElementById(cell_id))).className = "cell " + value;
}

socket.addEventListener("open", (function (param) {
        console.log("Connected.");
      }));

socket.addEventListener("message", (function ($$event) {
        var data = JSON.stringify($$event.data).slice(1, -1).split(",");
        var match = Belt_Option.getExn(data[0]);
        switch (match) {
          case "agent_action" :
              var s_row = Belt_Option.getExn(data[1]);
              var s_col = Belt_Option.getExn(data[2]);
              updateBoard(s_row, s_col, "agent-cell");
              isPlayerTurn.contents = true;
              return ;
          case "block_action" :
              var s_row$1 = Belt_Option.getExn(data[1]);
              var s_col$1 = Belt_Option.getExn(data[2]);
              updateBoard(s_row$1, s_col$1, "block-cell");
              isPlayerTurn.contents = true;
              return ;
          case "bonus_action" :
              var s_row$2 = Belt_Option.getExn(data[1]);
              var s_col$2 = Belt_Option.getExn(data[2]);
              updateBoard(s_row$2, s_col$2, "bonus-cell");
              isPlayerTurn.contents = true;
              return ;
          case "game_end" :
              var winner = Belt_Option.getExn(data[1]);
              if (winner === "tie") {
                window.alert("Game over! It's a tie! You can start a new game now!");
              } else {
                window.alert("Game over! Winner: " + winner + ". You can start a new game now!");
              }
              enableNewGame.contents = true;
              return ;
          case "invalid_action" :
              window.alert("You can't place here");
              return ;
          case "player_action" :
              var s_row$3 = Belt_Option.getExn(data[1]);
              var s_col$3 = Belt_Option.getExn(data[2]);
              return updateBoard(s_row$3, s_col$3, "player-cell");
          default:
            console.log("???");
            return ;
        }
      }));

socket.addEventListener("close", (function (param) {
        console.log("Disconnected.");
      }));

export {
  host ,
  socket ,
  initializeGameState ,
  isPlayerTurn ,
  enableNewGame ,
  gameMode ,
  agentDifficulty ,
  blockMode ,
  boardRows ,
  boardCols ,
  handleCellClick ,
  createCell ,
  renderBoard ,
  new_game ,
  updateBoard ,
}
/* host Not a pure module */
