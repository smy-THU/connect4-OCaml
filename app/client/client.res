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
let boardRows = ref(6)
let boardCols = ref(3)

let handleCellClick = (row, col) => {
  switch isPlayerTurn.contents {
  | false => window->Window.alert("It's not your turn")
  | true =>
    let s_row = string_of_int(row)
    let s_col = string_of_int(col)
    isPlayerTurn := false
    socket->WebSocket.sendText(`${s_row},${s_col}`)
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
  let board_style = board->Element.asHtmlElement->getExn->HtmlElement.style
  board_style->Dom.CssStyleDeclaration.setProperty(
    "grid-template-columns",
    `repeat(${s_cols}, 50px)`,
    "",
  )
  board_style->Dom.CssStyleDeclaration.setProperty(
    "grid-template-rows",
    `repeat(${s_rows}, 50px)`,
    "",
  )
  for i in 0 to rows * cols - 1 {
    let cell = createCell(i / cols, mod(i, cols))
    board->Element.appendChild(~child=cell)
  }
}

let new_game = event => {
  Event.preventDefault(event)

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
    }
  }
}

document
->Document.getElementById("board-size-form")
->getExn
->Element.addEventListener("submit", new_game)

let updateBoard = (s_row, s_col, value) => {
  let cell_id = `cell-r${s_row}-c${s_col}`
  document
  ->Document.getElementById(cell_id)
  ->getExn
  ->Element.setTextContent(value)
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
      updateBoard(s_row, s_col, "X")
    }
  | "agent_action" => {
      let s_row = data[1]->getExn
      let s_col = data[2]->getExn
      updateBoard(s_row, s_col, "O")
      isPlayerTurn := true
    }
  | "invalid_action" => window->Window.alert("You can't place here")
  | "game_end" => {
      let winner = data[1]->getExn
      window->Window.alert(`Game over! Winner: ${winner}. You can start a new game now!`)
      enableNewGame := true
    }
  | _ => Js.log("???")
  }
})

socket->WebSocket.addCloseListener(_ => {
  Js.log("Disconnected.")
})
