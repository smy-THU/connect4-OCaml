open Webapi
open Webapi.Dom
open Belt.Option

let gameModeSelect = document->Document.getElementById("game-mode")->getExn
let agentDifficultyContainer =
  document->Document.getElementById("agent-difficulty-container")->getExn

gameModeSelect->Element.addEventListener("change", _ => {
  let gameMode = HtmlSelectElement.ofElement(gameModeSelect)->getExn
  let gameMode = gameMode->HtmlSelectElement.value
  let diffStyle = agentDifficultyContainer->Element.asHtmlElement->getExn->HtmlElement.style
  switch gameMode {
  | "player-vs-agent" => diffStyle->Dom.CssStyleDeclaration.setProperty("display", "block", "")
  | "player-vs-player" => diffStyle->Dom.CssStyleDeclaration.setProperty("display", "none", "")
  | _ => ()
  }
})
