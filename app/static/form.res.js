(() => {
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
    var nodeType5 = function(self) {
      return decodeNodeType(self.nodeType);
    };
    return {
      nodeType: nodeType5
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
    var insertAdjacentElement3 = function(self, position, element) {
      self.insertAdjacentElement(encodeInsertPosition(position), element);
    };
    var insertAdjacentHTML3 = function(self, position, text) {
      self.insertAdjacentHTML(encodeInsertPosition(position), text);
    };
    var insertAdjacentText3 = function(self, position, text) {
      self.insertAdjacentText(encodeInsertPosition(position), text);
    };
    return {
      asHtmlElement,
      ofNode,
      insertAdjacentElement: insertAdjacentElement3,
      insertAdjacentHTML: insertAdjacentHTML3,
      insertAdjacentText: insertAdjacentText3
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
    var contentEditable2 = function(self) {
      return decodeContentEditable(self.contentEditable);
    };
    var setContentEditable2 = function(self, value) {
      self.contentEditable = encodeContentEditable(value);
    };
    var dir2 = function(self) {
      return decodeDir(self.dir);
    };
    var setDir2 = function(self, value) {
      self.dir = encodeDir(value);
    };
    return {
      ofElement: asHtmlElement,
      contentEditable: contentEditable2,
      setContentEditable: setContentEditable2,
      dir: dir2,
      setDir: setDir2
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

  // node_modules/rescript-webapi/src/Webapi/Dom/Webapi__Dom__HtmlSelectElement.res.mjs
  Impl({});
  var include3 = Impl2({});
  var include$12 = Impl8({});
  var include$2 = Impl9({});
  function ofElement(el) {
    var match = el.tagName;
    if (match === "SELECT") {
      return some(el);
    }
  }
  var nodeType4 = include3.nodeType;
  var ofNode3 = include$12.ofNode;
  var insertAdjacentElement2 = include$12.insertAdjacentElement;
  var insertAdjacentHTML2 = include$12.insertAdjacentHTML;
  var insertAdjacentText2 = include$12.insertAdjacentText;
  var contentEditable = include$2.contentEditable;
  var setContentEditable = include$2.setContentEditable;
  var dir = include$2.dir;
  var setDir = include$2.setDir;

  // client/form.res.mjs
  var gameModeSelect = getExn(nullable_to_opt(document.getElementById("game-mode")));
  var agentDifficultyContainer = getExn(nullable_to_opt(document.getElementById("agent-difficulty-container")));
  gameModeSelect.addEventListener("change", function(param) {
    var gameMode = getExn(ofElement(gameModeSelect));
    var gameMode$1 = gameMode.value;
    var diffStyle = getExn(asHtmlElement(agentDifficultyContainer)).style;
    switch (gameMode$1) {
      case "player-vs-agent":
        diffStyle.setProperty("display", "block", "");
        return;
      case "player-vs-player":
        diffStyle.setProperty("display", "none", "");
        return;
      default:
        return;
    }
  });
})();
