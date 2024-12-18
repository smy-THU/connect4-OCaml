open Webapi
open Webapi.Dom
open Belt.Option

let host = window->Window.location->Location.host
let socket = WebSocket.make(`ws://${host}/websocket`)

let initializeGameState = (rows, cols) => {
  Array.make(~length=rows, Array.make(~length=cols, "empty"))
}

let isPlayerTurn = ref(true)
let enableNewGame = ref(true)
let toBlock = ref(false)

let gameMode = ref("")
let agentDifficulty = ref("")
let blockMode = ref("")
let boardRows = ref(-1)
let boardCols = ref(-1)

let isColFull = s_col => {
  let flag = ref(true)
  let rows = boardRows.contents
  for i in 0 to rows - 1 {
    let s_row = string_of_int(i)
    let cell_id = `cell-r${s_row}-c${s_col}`
    let cell_class =
      document
      ->Document.getElementById(cell_id)
      ->getExn
      ->Element.getAttribute("class")
      ->getExn

    if cell_class == "cell" || cell_class == "cell bonus-cell" {
      flag := false
    }
  }
  flag.contents
}

let handleCellClick = (row, col) => {
  switch isPlayerTurn.contents {
  | false => window->Window.alert("It's not your turn")
  | true =>
    let s_row = string_of_int(row)
    let s_col = string_of_int(col)
    switch isColFull(s_col) {
    | true => window->Window.alert("This column is full")
    | false =>
      isPlayerTurn := false
      socket->WebSocket.sendText(`player_action,${s_row},${s_col}`)
    }
  }
}

let createCell = (row, col) => {
  let cell = document->Document.createElement("div")
  cell->Element.setClassName("cell")
  let s_row = string_of_int(row)
  let s_col = string_of_int(col)
  cell->Element.setAttribute("id", `cell-r${s_row}-c${s_col}`)
  cell->Element.addEventListener("click", _ => handleCellClick(row, col))
  cell->Element.asHtmlElement->getExn
}

let renderBoard = () => {
  let rows = boardRows.contents
  let cols = boardCols.contents
  let s_rows = string_of_int(rows)
  let s_cols = string_of_int(cols)
  let board = document->Document.getElementById("board")->getExn
  board->Element.setInnerHTML("")
  let board_style = board->Element.asHtmlElement->getExn->HtmlElement.style
  let css_col_key = "grid-template-columns"
  let css_row_key = "grid-template-rows"
  board_style->CssStyleDeclaration.setProperty(css_col_key, `repeat(${s_cols}, 50px)`, "")
  board_style->CssStyleDeclaration.setProperty(css_row_key, `repeat(${s_rows}, 50px)`, "")
  for i in 0 to rows * cols - 1 {
    let cell = createCell(i / cols, mod(i, cols))
    board->Element.appendChild(~child=cell)
  }
}

let new_game = event => {
  Event.preventDefault(event)

  let mode_element = document->Document.getElementById("game-mode")->getExn
  let mode_element = HtmlSelectElement.ofElement(mode_element)->getExn
  gameMode := mode_element->HtmlSelectElement.value

  let difficulty_element = document->Document.getElementById("agent-difficulty")->getExn
  let difficulty_element = HtmlSelectElement.ofElement(difficulty_element)->getExn
  agentDifficulty := difficulty_element->HtmlSelectElement.value

  let block_element = document->Document.getElementById("block-mode")->getExn
  let block_element = HtmlSelectElement.ofElement(block_element)->getExn
  blockMode := block_element->HtmlSelectElement.value

  let row_element = document->Document.getElementById("board-rows")->getExn
  let row_element = HtmlInputElement.ofElement(row_element)->getExn
  boardRows := row_element->HtmlInputElement.value->int_of_string

  let col_element = document->Document.getElementById("board-cols")->getExn
  let col_element = HtmlInputElement.ofElement(col_element)->getExn
  boardCols := col_element->HtmlInputElement.value->int_of_string

  switch enableNewGame.contents {
  | false => window->Window.alert("You can't start a new game now.")
  | true => {
      renderBoard()
      enableNewGame := false
      isPlayerTurn := true

      Js.log("=============================")
      Js.log2("gameMode        : ", gameMode.contents)
      Js.log2("agentDifficulty : ", agentDifficulty.contents)
      Js.log2("blockMode       : ", blockMode.contents)
      Js.log2("boardRows       : ", boardRows.contents)
      Js.log2("boardCols       : ", boardCols.contents)
      Js.log("-----------------------------")
      Js.log2("isPlayerTurn    : ", isPlayerTurn.contents)
      Js.log2("enableNewGame   : ", enableNewGame.contents)
      Js.log("=============================")

      let param_list = [
        gameMode.contents,
        agentDifficulty.contents,
        blockMode.contents,
        string_of_int(boardRows.contents),
        string_of_int(boardCols.contents),
      ]

      socket->WebSocket.sendText(
        Belt.Array.reduce(param_list, "new_game", (acc, x) => `${acc},${x}`),
      )
    }
  }
}

document
->Document.getElementById("board-size-form")
->getExn
->Element.addEventListener("submit", new_game)

let updateBoard = (s_row, s_col, value) => {
  Js.log("===== updateBoard =====")
  Js.log(`updateBoard: ${s_row}, ${s_col}, ${value}`)

  let cell_id = `cell-r${s_row}-c${s_col}`
  let cell_element = document->Document.getElementById(cell_id)->getExn
  let is_bonus = cell_element->Element.getAttribute("class")->getExn == "cell bonus-cell"

  if blockMode.contents == "reward" && toBlock.contents == true {
    cell_element->Element.setClassName(`cell block-cell`)
    Js.log(`toBlock: ${string_of_bool(toBlock.contents)}->false`)
    toBlock := false
    if value == "player-cell" {
      Js.log(`isPlayerTurn: ${string_of_bool(isPlayerTurn.contents)}->false`)
      isPlayerTurn := false
    } else if value == "agent-cell" {
      Js.log(`isPlayerTurn: ${string_of_bool(isPlayerTurn.contents)}->true`)
      isPlayerTurn := true
    }
  } else {
    cell_element->Element.setClassName(`cell ${value}`)
    if is_bonus && blockMode.contents == "reward" {
      if value == "player-cell" {
        Js.log(`isPlayerTurn: ${string_of_bool(isPlayerTurn.contents)}->true`)
        isPlayerTurn := true
      } else if value == "agent-cell" {
        Js.log(`isPlayerTurn: ${string_of_bool(isPlayerTurn.contents)}->false`)
        isPlayerTurn := false
      }
    } else if value == "player-cell" {
      Js.log(`isPlayerTurn: ${string_of_bool(isPlayerTurn.contents)}->false`)
      isPlayerTurn := false
    } else if value == "agent-cell" {
      Js.log(`isPlayerTurn: ${string_of_bool(isPlayerTurn.contents)}->true`)
      isPlayerTurn := true
    }
  }

  if is_bonus && blockMode.contents == "reward" && toBlock.contents == false {
    Js.log(`toBlock: ${string_of_bool(toBlock.contents)}->true`)
    toBlock := true
  }
}

socket->WebSocket.addOpenListener(_ => {
  Js.log("Connected.")
})

socket->WebSocket.addMessageListener(event => {
  let data =
    event.data
    ->Js.Json.stringify
    ->String.slice(~start=1, ~end=-1)
    ->String.split(",")
  switch data[0]->getExn {
  | "player_action" => {
      let s_row = data[1]->getExn
      let s_col = data[2]->getExn
      updateBoard(s_row, s_col, "player-cell")
    }
  | "agent_action" => {
      let s_row = data[1]->getExn
      let s_col = data[2]->getExn
      updateBoard(s_row, s_col, "agent-cell")
    }
  | "block_action" => {
      let s_row = data[1]->getExn
      let s_col = data[2]->getExn
      updateBoard(s_row, s_col, "block-cell")
      isPlayerTurn := true
    }
  | "bonus_action" => {
      let s_row = data[1]->getExn
      let s_col = data[2]->getExn
      updateBoard(s_row, s_col, "bonus-cell")
      isPlayerTurn := true
    }
  | "game_end" => {
      let winner = data[1]->getExn
      switch winner {
      | "tie" => window->Window.alert("Tie!")
      | _ => window->Window.alert(`${winner} Wins!`)
      }
      enableNewGame := true
      isPlayerTurn := false
    }
  | _ => Js.log("???")
  }
})

socket->WebSocket.addCloseListener(_ => {
  Js.log("Disconnected.")
})
