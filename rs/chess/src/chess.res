open Webapi
open Webapi.Dom

let socket = WebSocket.make("ws://" ++ window->Window.location->Location.host ++ "/websocket")
let board = document->Document.getElementById("board")->Belt.Option.getExn
let gameState = Array.make(~length=4, Array.make(~length=4, None))
let isPlayerTurn = ref(true)

let getGameStateElement = (col, row) =>
  Belt.Array.getExn(Belt.Array.getExn(gameState, col), row)

let sendBoardState = () => {
  socket->WebSocket.sendText("move|gameState")
}

let findLowestEmptyRow = col => {
  for row in 3 downto 0 {
    switch Belt.Array.getExn(Belt.Array.getExn(gameState, col), row)  {
    | None => row
    | Some(_) => ()
    }
  }
  -1
}

let handleCellClick = col => {
  if isPlayerTurn.contents {
    switch findLowestEmptyRow(col) {
    | -1 => ()
    | row =>
      updateBoard(row, col, "black")
      isPlayerTurn := false
      sendBoardState()
    }
  }
}

// Create board UI
for i in 0 to 3 {
  for j in 0 to 3 {
    let cell = document->Document.createElement("div")
    cell->Element.setClassName("cell")
    cell->Element.setAttribute("data-row", string_of_int(i))
    cell->Element.setAttribute("data-col", string_of_int(j))
    cell->Element.addEventListener("click", _ => handleCellClick(j))
    board->Node.appendChild(cell->Element.asNode)
  }
}

let updateBoard = (row, col, piece) => {
  gameState[row][col] = Some(piece)
  let cell =
    document
    ->Document.querySelector(
      ".cell[data-row=\"" ++ string_of_int(row) ++ "\"][data-col=\"" ++ string_of_int(col) ++ "\"]",
    )
    ->Belt.Option.getExn
  cell->Element.setInnerText(piece == "black" ? "●" : "○")
  cell->Element.setClassName("cell " ++ piece)
}

socket->WebSocket.addEventListener("message", event => {
  let data = JSON.parse(event->WebSocket.MessageEvent.data)
  let row = data["row"]
  let col = data["col"]
  let piece = data["piece"]
  updateBoard(row, col, piece)
  isPlayerTurn := true
})

socket->WebSocket.addEventListener("open", _ => Js.log("WebSocket connected"))
socket->WebSocket.addEventListener("close", _ => Js.log("WebSocket disconnected"))
