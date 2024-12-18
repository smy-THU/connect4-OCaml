(() => {
  // node_modules/rescript/lib/es6/caml_array.js
  function sub(x, offset, len) {
    var result = new Array(len);
    var j = 0;
    var i = offset;
    while (j < len) {
      result[j] = x[i];
      j = j + 1 | 0;
      i = i + 1 | 0;
    }
    ;
    return result;
  }

  // node_modules/rescript/lib/es6/curry.js
  function app(_f, _args) {
    while (true) {
      var args = _args;
      var f = _f;
      var init_arity = f.length;
      var arity = init_arity === 0 ? 1 : init_arity;
      var len = args.length;
      var d = arity - len | 0;
      if (d === 0) {
        return f.apply(null, args);
      }
      if (d >= 0) {
        return /* @__PURE__ */ function(f2, args2) {
          return function(x) {
            return app(f2, args2.concat([x]));
          };
        }(f, args);
      }
      _args = sub(args, arity, -d | 0);
      _f = f.apply(null, sub(args, 0, arity));
      continue;
    }
    ;
  }
  function _2(o, a0, a1) {
    var arity = o.length;
    if (arity === 2) {
      return o(a0, a1);
    } else {
      switch (arity) {
        case 1:
          return app(o(a0), [a1]);
        case 2:
          return o(a0, a1);
        case 3:
          return function(param) {
            return o(a0, a1, param);
          };
        case 4:
          return function(param, param$1) {
            return o(a0, a1, param, param$1);
          };
        case 5:
          return function(param, param$1, param$2) {
            return o(a0, a1, param, param$1, param$2);
          };
        case 6:
          return function(param, param$1, param$2, param$3) {
            return o(a0, a1, param, param$1, param$2, param$3);
          };
        case 7:
          return function(param, param$1, param$2, param$3, param$4) {
            return o(a0, a1, param, param$1, param$2, param$3, param$4);
          };
        default:
          return app(o, [
            a0,
            a1
          ]);
      }
    }
  }
  function __2(o) {
    var arity = o.length;
    if (arity === 2) {
      return o;
    } else {
      return function(a0, a1) {
        return _2(o, a0, a1);
      };
    }
  }

  // node_modules/rescript/lib/es6/caml_option.js
  function some(x) {
    if (x === void 0) {
      return {
        BS_PRIVATE_NESTED_SOME_NONE: 0
      };
    } else if (x !== null && x.BS_PRIVATE_NESTED_SOME_NONE !== void 0) {
      return {
        BS_PRIVATE_NESTED_SOME_NONE: x.BS_PRIVATE_NESTED_SOME_NONE + 1 | 0
      };
    } else {
      return x;
    }
  }
  function nullable_to_opt(x) {
    if (x == null) {
      return;
    } else {
      return some(x);
    }
  }
  function valFromOption(x) {
    if (!(x !== null && x.BS_PRIVATE_NESTED_SOME_NONE !== void 0)) {
      return x;
    }
    var depth = x.BS_PRIVATE_NESTED_SOME_NONE;
    if (depth === 0) {
      return;
    } else {
      return {
        BS_PRIVATE_NESTED_SOME_NONE: depth - 1 | 0
      };
    }
  }

  // node_modules/rescript/lib/es6/belt_Array.js
  function reduceU(a, x, f) {
    var r = x;
    for (var i = 0, i_finish = a.length; i < i_finish; ++i) {
      r = f(r, a[i]);
    }
    return r;
  }
  function reduce(a, x, f) {
    return reduceU(a, x, __2(f));
  }

  // node_modules/rescript/lib/es6/caml_int32.js
  function div(x, y) {
    if (y === 0) {
      throw {
        RE_EXN_ID: "Division_by_zero",
        Error: new Error()
      };
    }
    return x / y | 0;
  }
  function mod_(x, y) {
    if (y === 0) {
      throw {
        RE_EXN_ID: "Division_by_zero",
        Error: new Error()
      };
    }
    return x % y;
  }

  // node_modules/rescript/lib/es6/belt_Option.js
  function getExn(x) {
    if (x !== void 0) {
      return valFromOption(x);
    }
    throw {
      RE_EXN_ID: "Not_found",
      Error: new Error()
    };
  }

  // node_modules/rescript/lib/es6/caml_format.js
  function parse_digit(c) {
    if (c >= 65) {
      if (c >= 97) {
        if (c >= 123) {
          return -1;
        } else {
          return c - 87 | 0;
        }
      } else if (c >= 91) {
        return -1;
      } else {
        return c - 55 | 0;
      }
    } else if (c > 57 || c < 48) {
      return -1;
    } else {
      return c - /* '0' */
      48 | 0;
    }
  }
  function int_of_string_base(param) {
    switch (param) {
      case "Oct":
        return 8;
      case "Hex":
        return 16;
      case "Dec":
        return 10;
      case "Bin":
        return 2;
    }
  }
  function parse_sign_and_base(s) {
    var sign = 1;
    var base = "Dec";
    var i = 0;
    var match = s.codePointAt(i);
    switch (match) {
      case 43:
        i = i + 1 | 0;
        break;
      case 45:
        sign = -1;
        i = i + 1 | 0;
        break;
      default:
    }
    if (s.codePointAt(i) === /* '0' */
    48) {
      var match$1 = s.codePointAt(i + 1 | 0);
      if (match$1 >= 89) {
        if (match$1 >= 111) {
          if (match$1 < 121) {
            switch (match$1) {
              case 111:
                base = "Oct";
                i = i + 2 | 0;
                break;
              case 117:
                i = i + 2 | 0;
                break;
              case 112:
              case 113:
              case 114:
              case 115:
              case 116:
              case 118:
              case 119:
                break;
              case 120:
                base = "Hex";
                i = i + 2 | 0;
                break;
            }
          }
        } else if (match$1 === 98) {
          base = "Bin";
          i = i + 2 | 0;
        }
      } else if (match$1 !== 66) {
        if (match$1 >= 79) {
          switch (match$1) {
            case 79:
              base = "Oct";
              i = i + 2 | 0;
              break;
            case 85:
              i = i + 2 | 0;
              break;
            case 80:
            case 81:
            case 82:
            case 83:
            case 84:
            case 86:
            case 87:
              break;
            case 88:
              base = "Hex";
              i = i + 2 | 0;
              break;
          }
        }
      } else {
        base = "Bin";
        i = i + 2 | 0;
      }
    }
    return [
      i,
      sign,
      base
    ];
  }
  function int_of_string(s) {
    var match = parse_sign_and_base(s);
    var i = match[0];
    var base = int_of_string_base(match[2]);
    var threshold = 4294967295;
    var len = s.length;
    var c = i < len ? s.codePointAt(i) : (
      /* '\000' */
      0
    );
    var d = parse_digit(c);
    if (d < 0 || d >= base) {
      throw {
        RE_EXN_ID: "Failure",
        _1: "int_of_string",
        Error: new Error()
      };
    }
    var aux = function(_acc, _k) {
      while (true) {
        var k = _k;
        var acc = _acc;
        if (k === len) {
          return acc;
        }
        var a = s.codePointAt(k);
        if (a === /* '_' */
        95) {
          _k = k + 1 | 0;
          continue;
        }
        var v = parse_digit(a);
        if (v < 0 || v >= base) {
          throw {
            RE_EXN_ID: "Failure",
            _1: "int_of_string",
            Error: new Error()
          };
        }
        var acc$1 = base * acc + v;
        if (acc$1 > threshold) {
          throw {
            RE_EXN_ID: "Failure",
            _1: "int_of_string",
            Error: new Error()
          };
        }
        _k = k + 1 | 0;
        _acc = acc$1;
        continue;
      }
      ;
    };
    var res = match[1] * aux(d, i + 1 | 0);
    var or_res = res | 0;
    if (base === 10 && res !== or_res) {
      throw {
        RE_EXN_ID: "Failure",
        _1: "int_of_string",
        Error: new Error()
      };
    }
    return or_res;
  }

  // node_modules/@rescript/core/src/Core__Array.res.mjs
  function make(length, x) {
    if (length <= 0) {
      return [];
    }
    var arr = new Array(length);
    arr.fill(x);
    return arr;
  }

  // node_modules/rescript/lib/es6/pervasivesU.js
  function string_of_bool(b) {
    if (b) {
      return "true";
    } else {
      return "false";
    }
  }

  // node_modules/rescript-webapi/src/Webapi/Dom/Webapi__Dom__Types.res.mjs
  function encodeContentEditable(x) {
    switch (x) {
      case "True":
        return "true";
      case "False":
        return "false";
      case "Inherit":
        return "inherit";
      case "Unknown":
        return "";
    }
  }
  function decodeContentEditable(x) {
    switch (x) {
      case "false":
        return "False";
      case "inherit":
        return "Inherit";
      case "true":
        return "True";
      default:
        return "Unknown";
    }
  }
  function encodeDir(x) {
    switch (x) {
      case "Ltr":
        return "ltr";
      case "Rtl":
        return "rtl";
      case "Unknown":
        return "";
    }
  }
  function decodeDir(x) {
    switch (x) {
      case "ltr":
        return "Ltr";
      case "rtl":
        return "Rtl";
      default:
        return "Unknown";
    }
  }
  function encodeInsertPosition(x) {
    switch (x) {
      case "BeforeBegin":
        return "beforebegin";
      case "AfterBegin":
        return "afterbegin";
      case "BeforeEnd":
        return "beforeend";
      case "AfterEnd":
        return "afterend";
    }
  }
  function decodeNodeType(x) {
    switch (x) {
      case 1:
        return "Element";
      case 2:
        return "Attribute";
      case 3:
        return "Text";
      case 4:
        return "CDATASection";
      case 5:
        return "EntityReference";
      case 6:
        return "Entity";
      case 7:
        return "ProcessingInstruction";
      case 8:
        return "Comment";
      case 9:
        return "Document";
      case 10:
        return "DocumentType";
      case 11:
        return "DocumentFragment";
      case 12:
        return "Notation";
      default:
        return "Unknown";
    }
  }

  // node_modules/rescript-webapi/src/Webapi/Dom/Webapi__Dom__EventTarget.res.mjs
  function Impl(T) {
    return {};
  }

  // node_modules/rescript-webapi/src/Webapi/Dom/Webapi__Dom__Node.res.mjs
  function Impl2(T) {
    var nodeType6 = function(self) {
      return decodeNodeType(self.nodeType);
    };
    return {
      nodeType: nodeType6
    };
  }
  Impl({});
  function nodeType(self) {
    return decodeNodeType(self.nodeType);
  }

  // node_modules/rescript-webapi/src/Webapi/Dom/Webapi__Dom__Slotable.res.mjs
  function Impl3(T) {
    return {};
  }

  // node_modules/rescript-webapi/src/Webapi/Dom/Webapi__Dom__ChildNode.res.mjs
  function Impl4(T) {
    return {};
  }

  // node_modules/rescript-webapi/src/Webapi/Dom/Webapi__Dom__ParentNode.res.mjs
  function Impl5(T) {
    return {};
  }

  // node_modules/rescript-webapi/src/Webapi/Dom/Webapi__Dom__GlobalEventHandlers.res.mjs
  function Impl6(T) {
    return {};
  }

  // node_modules/rescript-webapi/src/Webapi/Dom/Webapi__Dom__NonDocumentTypeChildNode.res.mjs
  function Impl7(T) {
    return {};
  }

  // node_modules/rescript-webapi/src/Webapi/Dom/Webapi__Dom__Element.res.mjs
  function ofNode(node) {
    if (nodeType(node) === "Element") {
      return some(node);
    }
  }
  var asHtmlElement = function(element) {
    if (window.constructor.name !== void 0 && /^HTML\w*Element$/.test(element.constructor.name) || /^\[object HTML\w*Element\]$/.test(element.constructor.toString())) {
      return element;
    }
  };
  function Impl8(T) {
    var insertAdjacentElement4 = function(self, position, element) {
      self.insertAdjacentElement(encodeInsertPosition(position), element);
    };
    var insertAdjacentHTML4 = function(self, position, text) {
      self.insertAdjacentHTML(encodeInsertPosition(position), text);
    };
    var insertAdjacentText4 = function(self, position, text) {
      self.insertAdjacentText(encodeInsertPosition(position), text);
    };
    return {
      asHtmlElement,
      ofNode,
      insertAdjacentElement: insertAdjacentElement4,
      insertAdjacentHTML: insertAdjacentHTML4,
      insertAdjacentText: insertAdjacentText4
    };
  }
  var include = Impl2({});
  Impl({});
  Impl6({});
  Impl5({});
  Impl7({});
  Impl4({});
  Impl3({});
  var nodeType2 = include.nodeType;

  // node_modules/rescript-webapi/src/Webapi/Dom/Webapi__Dom__HtmlElement.res.mjs
  function Impl9(T) {
    var contentEditable3 = function(self) {
      return decodeContentEditable(self.contentEditable);
    };
    var setContentEditable3 = function(self, value) {
      self.contentEditable = encodeContentEditable(value);
    };
    var dir3 = function(self) {
      return decodeDir(self.dir);
    };
    var setDir3 = function(self, value) {
      self.dir = encodeDir(value);
    };
    return {
      ofElement: asHtmlElement,
      contentEditable: contentEditable3,
      setContentEditable: setContentEditable3,
      dir: dir3,
      setDir: setDir3
    };
  }
  var include2 = Impl2({});
  Impl({});
  Impl6({});
  Impl5({});
  Impl7({});
  Impl4({});
  var include$1 = Impl8({});
  Impl3({});
  var nodeType3 = include2.nodeType;
  var asHtmlElement2 = include$1.asHtmlElement;
  var ofNode2 = include$1.ofNode;
  var insertAdjacentElement = include$1.insertAdjacentElement;
  var insertAdjacentHTML = include$1.insertAdjacentHTML;
  var insertAdjacentText = include$1.insertAdjacentText;

  // node_modules/rescript-webapi/src/Webapi/Dom/Webapi__Dom__HtmlInputElement.res.mjs
  Impl({});
  var include3 = Impl2({});
  var include$12 = Impl8({});
  var include$2 = Impl9({});
  var nodeType4 = include3.nodeType;
  var asHtmlElement3 = include$12.asHtmlElement;
  var ofNode3 = include$12.ofNode;
  var insertAdjacentElement2 = include$12.insertAdjacentElement;
  var insertAdjacentHTML2 = include$12.insertAdjacentHTML;
  var insertAdjacentText2 = include$12.insertAdjacentText;
  var ofElement = include$2.ofElement;
  var contentEditable = include$2.contentEditable;
  var setContentEditable = include$2.setContentEditable;
  var dir = include$2.dir;
  var setDir = include$2.setDir;

  // node_modules/rescript-webapi/src/Webapi/Dom/Webapi__Dom__HtmlSelectElement.res.mjs
  Impl({});
  var include4 = Impl2({});
  var include$13 = Impl8({});
  var include$22 = Impl9({});
  function ofElement2(el) {
    var match = el.tagName;
    if (match === "SELECT") {
      return some(el);
    }
  }
  var nodeType5 = include4.nodeType;
  var ofNode4 = include$13.ofNode;
  var insertAdjacentElement3 = include$13.insertAdjacentElement;
  var insertAdjacentHTML3 = include$13.insertAdjacentHTML;
  var insertAdjacentText3 = include$13.insertAdjacentText;
  var contentEditable2 = include$22.contentEditable;
  var setContentEditable2 = include$22.setContentEditable;
  var dir2 = include$22.dir;
  var setDir2 = include$22.setDir;

  // client/client.res.mjs
  var host = window.location.host;
  var socket = new WebSocket("ws://" + host + "/websocket");
  function initializeGameState(rows, cols) {
    return make(rows, make(cols, "empty"));
  }
  var isPlayerTurn = {
    contents: true
  };
  var enableNewGame = {
    contents: true
  };
  var toBlock = {
    contents: false
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
  function isColFull(s_col) {
    var flag = true;
    var rows = boardRows.contents;
    for (var i = 0; i < rows; ++i) {
      var s_row = String(i);
      var cell_id = "cell-r" + s_row + "-c" + s_col;
      var cell_class = getExn(nullable_to_opt(getExn(nullable_to_opt(document.getElementById(cell_id))).getAttribute("class")));
      if (cell_class === "cell" || cell_class === "cell bonus-cell") {
        flag = false;
      }
    }
    return flag;
  }
  function handleCellClick(row, col) {
    if (isPlayerTurn.contents) {
      var s_row = String(row);
      var s_col = String(col);
      if (isColFull(s_col)) {
        window.alert("This column is full");
      } else {
        isPlayerTurn.contents = false;
        socket.send("player_action," + s_row + "," + s_col);
      }
      return;
    }
    window.alert("It's not your turn");
  }
  function createCell(row, col) {
    var cell = document.createElement("div");
    cell.className = "cell";
    var s_row = String(row);
    var s_col = String(col);
    cell.setAttribute("id", "cell-r" + s_row + "-c" + s_col);
    cell.addEventListener("click", function(param) {
      handleCellClick(row, col);
    });
    return getExn(asHtmlElement(cell));
  }
  function renderBoard() {
    var rows = boardRows.contents;
    var cols = boardCols.contents;
    var s_rows = String(rows);
    var s_cols = String(cols);
    var board = getExn(nullable_to_opt(document.getElementById("board")));
    board.innerHTML = "";
    var board_style = getExn(asHtmlElement(board)).style;
    board_style.setProperty("grid-template-columns", "repeat(" + s_cols + ", 50px)", "");
    board_style.setProperty("grid-template-rows", "repeat(" + s_rows + ", 50px)", "");
    for (var i = 0, i_finish = Math.imul(rows, cols); i < i_finish; ++i) {
      var cell = createCell(div(i, cols), mod_(i, cols));
      board.appendChild(cell);
    }
  }
  function new_game($$event) {
    $$event.preventDefault();
    var mode_element = getExn(nullable_to_opt(document.getElementById("game-mode")));
    var mode_element$1 = getExn(ofElement2(mode_element));
    gameMode.contents = mode_element$1.value;
    var difficulty_element = getExn(nullable_to_opt(document.getElementById("agent-difficulty")));
    var difficulty_element$1 = getExn(ofElement2(difficulty_element));
    agentDifficulty.contents = difficulty_element$1.value;
    var block_element = getExn(nullable_to_opt(document.getElementById("block-mode")));
    var block_element$1 = getExn(ofElement2(block_element));
    blockMode.contents = block_element$1.value;
    var row_element = getExn(nullable_to_opt(document.getElementById("board-rows")));
    var row_element$1 = getExn(ofElement(row_element));
    boardRows.contents = int_of_string(row_element$1.value);
    var col_element = getExn(nullable_to_opt(document.getElementById("board-cols")));
    var col_element$1 = getExn(ofElement(col_element));
    boardCols.contents = int_of_string(col_element$1.value);
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
      socket.send(reduce(param_list, "new_game", function(acc, x) {
        return acc + "," + x;
      }));
      return;
    }
    window.alert("You can't start a new game now.");
  }
  getExn(nullable_to_opt(document.getElementById("board-size-form"))).addEventListener("submit", new_game);
  function updateBoard(s_row, s_col, value) {
    console.log("===== updateBoard =====");
    console.log("updateBoard: " + s_row + ", " + s_col + ", " + value);
    var cell_id = "cell-r" + s_row + "-c" + s_col;
    var cell_element = getExn(nullable_to_opt(document.getElementById(cell_id)));
    var is_bonus = getExn(nullable_to_opt(cell_element.getAttribute("class"))) === "cell bonus-cell";
    if (blockMode.contents === "reward" && toBlock.contents === true) {
      cell_element.className = "cell block-cell";
      console.log("toBlock: " + string_of_bool(toBlock.contents) + "->false");
      toBlock.contents = false;
      if (value === "player-cell") {
        console.log("isPlayerTurn: " + string_of_bool(isPlayerTurn.contents) + "->false");
        isPlayerTurn.contents = false;
      } else if (value === "agent-cell") {
        console.log("isPlayerTurn: " + string_of_bool(isPlayerTurn.contents) + "->true");
        isPlayerTurn.contents = true;
      }
    } else {
      cell_element.className = "cell " + value;
      if (is_bonus && blockMode.contents === "reward") {
        if (value === "player-cell") {
          console.log("isPlayerTurn: " + string_of_bool(isPlayerTurn.contents) + "->true");
          isPlayerTurn.contents = true;
        } else if (value === "agent-cell") {
          console.log("isPlayerTurn: " + string_of_bool(isPlayerTurn.contents) + "->false");
          isPlayerTurn.contents = false;
        }
      } else if (value === "player-cell") {
        console.log("isPlayerTurn: " + string_of_bool(isPlayerTurn.contents) + "->false");
        isPlayerTurn.contents = false;
      } else if (value === "agent-cell") {
        console.log("isPlayerTurn: " + string_of_bool(isPlayerTurn.contents) + "->true");
        isPlayerTurn.contents = true;
      }
    }
    if (is_bonus && blockMode.contents === "reward" && toBlock.contents === false) {
      console.log("toBlock: " + string_of_bool(toBlock.contents) + "->true");
      toBlock.contents = true;
      return;
    }
  }
  socket.addEventListener("open", function(param) {
    console.log("Connected.");
  });
  socket.addEventListener("message", function($$event) {
    var data = JSON.stringify($$event.data).slice(1, -1).split(",");
    var match = getExn(data[0]);
    switch (match) {
      case "agent_action":
        var s_row = getExn(data[1]);
        var s_col = getExn(data[2]);
        return updateBoard(s_row, s_col, "agent-cell");
      case "block_action":
        var s_row$1 = getExn(data[1]);
        var s_col$1 = getExn(data[2]);
        updateBoard(s_row$1, s_col$1, "block-cell");
        isPlayerTurn.contents = true;
        return;
      case "bonus_action":
        var s_row$2 = getExn(data[1]);
        var s_col$2 = getExn(data[2]);
        updateBoard(s_row$2, s_col$2, "bonus-cell");
        isPlayerTurn.contents = true;
        return;
      case "game_end":
        var winner = getExn(data[1]);
        if (winner === "tie") {
          window.alert("Tie!");
        } else {
          window.alert(winner + " Wins!");
        }
        enableNewGame.contents = true;
        isPlayerTurn.contents = false;
        return;
      case "player_action":
        var s_row$3 = getExn(data[1]);
        var s_col$3 = getExn(data[2]);
        return updateBoard(s_row$3, s_col$3, "player-cell");
      default:
        console.log("???");
        return;
    }
  });
  socket.addEventListener("close", function(param) {
    console.log("Disconnected.");
  });
})();
