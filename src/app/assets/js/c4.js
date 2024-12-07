var socket = new WebSocket("ws://" + window.location.host + "/websocket");
const board = document.getElementById("board");
let gameState = Array(4)
  .fill(null)
  .map(() => Array(4).fill(null));
let isPlayerTurn = true;

// Create board UI
for (let i = 0; i < 4; i++) {
  for (let j = 0; j < 4; j++) {
    const cell = document.createElement("div");
    cell.className = "cell";
    cell.dataset.row = i;
    cell.dataset.col = j;
    cell.addEventListener("click", () => placePiece(j, "player"));
    board.appendChild(cell);
  }
}

function placePiece(col, piece) {
  if (piece === "player" && !isPlayerTurn) return;
  const row = findLowestEmptyRow(col);
  if (row === -1) return;
  updateBoard(row, col, piece);
  if (piece === "player") {
    isPlayerTurn = false;
    sendBoardState();
  } else {
    isPlayerTurn = true;
  }
}

function findLowestEmptyRow(col) {
  for (let row = 3; row >= 0; row--) {
    if (gameState[row][col] === null) {
      return row;
    }
  }
  return -1;
}

function updateBoard(row, col, piece) {
  gameState[row][col] = piece;
  const cell = document.querySelector(
    `.cell[data-row="${row}"][data-col="${col}"]`
  );
  cell.textContent = piece === "player" ? "●" : "○";
  cell.className = `cell ${piece}`;
}

function sendBoardState() {
  socket.send(JSON.stringify({ type: "move", board: gameState }));
}

socket.onmessage = (event) => {
  console.log(event.data);
  agent_col = Number(event.data);
  placePiece(agent_col, "agent");
};

socket.onopen = () => console.log("WebSocket connected");
socket.onclose = () => console.log("WebSocket disconnected");
