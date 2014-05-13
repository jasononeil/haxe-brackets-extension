(function () { "use strict";
var $estr = function() { return js.Boot.__string_rec(this,''); };
var EReg = function(r,opt) {
	opt = opt.split("u").join("");
	this.r = new RegExp(r,opt);
};
EReg.__name__ = true;
EReg.prototype = {
	match: function(s) {
		if(this.r.global) this.r.lastIndex = 0;
		this.r.m = this.r.exec(s);
		this.r.s = s;
		return this.r.m != null;
	}
	,matched: function(n) {
		if(this.r.m != null && n >= 0 && n < this.r.m.length) return this.r.m[n]; else throw "EReg::matched";
	}
};
var HxOverrides = function() { };
HxOverrides.__name__ = true;
HxOverrides.cca = function(s,index) {
	var x = s.charCodeAt(index);
	if(x != x) return undefined;
	return x;
};
HxOverrides.substr = function(s,pos,len) {
	if(pos != null && pos != 0 && len != null && len < 0) return "";
	if(len == null) len = s.length;
	if(pos < 0) {
		pos = s.length + pos;
		if(pos < 0) pos = 0;
	} else if(len < 0) len = s.length + len - pos;
	return s.substr(pos,len);
};
HxOverrides.indexOf = function(a,obj,i) {
	var len = a.length;
	if(i < 0) {
		i += len;
		if(i < 0) i = 0;
	}
	while(i < len) {
		if(a[i] === obj) return i;
		i++;
	}
	return -1;
};
HxOverrides.iter = function(a) {
	return { cur : 0, arr : a, hasNext : function() {
		return this.cur < this.arr.length;
	}, next : function() {
		return this.arr[this.cur++];
	}};
};
var Lambda = function() { };
Lambda.__name__ = true;
Lambda.has = function(it,elt) {
	var $it0 = $iterator(it)();
	while( $it0.hasNext() ) {
		var x = $it0.next();
		if(x == elt) return true;
	}
	return false;
};
var Reflect = function() { };
Reflect.__name__ = true;
Reflect.field = function(o,field) {
	try {
		return o[field];
	} catch( e ) {
		return null;
	}
};
Reflect.deleteField = function(o,field) {
	if(!Object.prototype.hasOwnProperty.call(o,field)) return false;
	delete(o[field]);
	return true;
};
var Std = function() { };
Std.__name__ = true;
Std.string = function(s) {
	return js.Boot.__string_rec(s,"");
};
var StringBuf = function() {
	this.b = "";
};
StringBuf.__name__ = true;
StringBuf.prototype = {
	add: function(x) {
		this.b += Std.string(x);
	}
};
var StringTools = function() { };
StringTools.__name__ = true;
StringTools.htmlEscape = function(s,quotes) {
	s = s.split("&").join("&amp;").split("<").join("&lt;").split(">").join("&gt;");
	if(quotes) return s.split("\"").join("&quot;").split("'").join("&#039;"); else return s;
};
StringTools.startsWith = function(s,start) {
	return s.length >= start.length && HxOverrides.substr(s,0,start.length) == start;
};
StringTools.isSpace = function(s,pos) {
	var c = HxOverrides.cca(s,pos);
	return c > 8 && c < 14 || c == 32;
};
StringTools.ltrim = function(s) {
	var l = s.length;
	var r = 0;
	while(r < l && StringTools.isSpace(s,r)) r++;
	if(r > 0) return HxOverrides.substr(s,r,l - r); else return s;
};
StringTools.rtrim = function(s) {
	var l = s.length;
	var r = 0;
	while(r < l && StringTools.isSpace(s,l - r - 1)) r++;
	if(r > 0) return HxOverrides.substr(s,0,l - r); else return s;
};
StringTools.trim = function(s) {
	return StringTools.ltrim(StringTools.rtrim(s));
};
var adobebrackets = {};
adobebrackets.editor = {};
adobebrackets.editor.CodeHintProvider = function() { };
adobebrackets.editor.CodeHintProvider.__name__ = true;
var dtx = {};
dtx.DOMCollection = function(nodes) {
	this.collection = [];
	if(nodes != null) {
		var $it0 = $iterator(nodes)();
		while( $it0.hasNext() ) {
			var n = $it0.next();
			if(n != null) this.collection.push(n);
		}
	}
};
dtx.DOMCollection.__name__ = true;
dtx.DOMCollection.prototype = {
	iterator: function() {
		return HxOverrides.iter(this.collection);
	}
	,add: function(node,pos) {
		if(pos == null) pos = -1;
		if(pos < 0 || pos > this.collection.length) pos = this.collection.length;
		if(node != null) {
			if(HxOverrides.indexOf(this.collection,node,0) == -1) this.collection.splice(pos,0,node);
		}
		return this;
	}
	,addCollection: function(collection,elementsOnly) {
		if(elementsOnly == null) elementsOnly = false;
		if(collection != null) {
			var $it0 = $iterator(collection)();
			while( $it0.hasNext() ) {
				var node = $it0.next();
				if(elementsOnly == false || dtx.single.ElementManipulation.isElement(node)) this.add(node);
			}
		}
		return this;
	}
	,addNodeList: function(nodeList,elementsOnly) {
		if(elementsOnly == null) elementsOnly = false;
		if(nodeList != null) {
			var _g1 = 0;
			var _g = nodeList.length;
			while(_g1 < _g) {
				var i = _g1++;
				var node = nodeList.item(i);
				if(elementsOnly == false || dtx.single.ElementManipulation.isElement(node)) this.add(node);
			}
		}
		return this;
	}
};
dtx.DOMType = function() { };
dtx.DOMType.__name__ = true;
dtx.Tools = function() { };
dtx.Tools.__name__ = true;
dtx.Tools.create = function(tagName) {
	var elm = null;
	if(tagName != null) try {
		elm = document.createElement(tagName);
	} catch( e ) {
		elm = null;
	}
	return elm;
};
dtx.Tools.parse = function(xml) {
	var q;
	if(xml != null && xml != "") {
		var parentTag = "div";
		if(dtx.Tools.firstTag.match(xml)) {
			var tagName = dtx.Tools.firstTag.matched(1);
			switch(tagName) {
			case "tbody":
				parentTag = "table";
				break;
			case "tfoot":
				parentTag = "table";
				break;
			case "thead":
				parentTag = "table";
				break;
			case "colgroup":
				parentTag = "table";
				break;
			case "col":
				parentTag = "colgroup";
				break;
			case "tr":
				parentTag = "tbody";
				break;
			case "th":
				parentTag = "tr";
				break;
			case "td":
				parentTag = "tr";
				break;
			default:
				parentTag = "div";
			}
		}
		var n = dtx.Tools.create(parentTag);
		dtx.single.ElementManipulation.setInnerHTML(n,xml);
		q = dtx.single.Traversing.children(n,false);
	} else q = new dtx.DOMCollection();
	return q;
};
dtx.collection = {};
dtx.collection.ElementManipulation = function() { };
dtx.collection.ElementManipulation.__name__ = true;
dtx.collection.ElementManipulation.text = function(collection) {
	var text = "";
	if(collection != null) {
		var $it0 = HxOverrides.iter(collection.collection);
		while( $it0.hasNext() ) {
			var node = $it0.next();
			text = text + dtx.single.ElementManipulation.text(node);
		}
	}
	return text;
};
dtx.collection.ElementManipulation.innerHTML = function(collection) {
	var sb = new StringBuf();
	if(collection != null) {
		var $it0 = HxOverrides.iter(collection.collection);
		while( $it0.hasNext() ) {
			var node = $it0.next();
			sb.add(dtx.single.ElementManipulation.innerHTML(node));
		}
	}
	return sb.b;
};
dtx.collection.Traversing = function() { };
dtx.collection.Traversing.__name__ = true;
dtx.collection.Traversing.find = function(collection,selector) {
	var newDOMCollection = new dtx.DOMCollection();
	if(collection != null && selector != null && selector != "") {
		var $it0 = HxOverrides.iter(collection.collection);
		while( $it0.hasNext() ) {
			var node = $it0.next();
			if(dtx.single.ElementManipulation.isElement(node) || dtx.single.ElementManipulation.isDocument(node)) {
				var element = node;
				if(document.querySelectorAll) {
					var results = element.querySelectorAll(selector);
					newDOMCollection.addNodeList(results);
				} else {
					var engine =
								(('undefined' != typeof Sizzle && Sizzle) ||
								(('undefined' != typeof jQuery) && jQuery.find) ||
								(('undefined' != typeof $) && $.find))
							;
					var results1 = engine(selector,node);
					newDOMCollection.addCollection(results1);
				}
			}
		}
	}
	return newDOMCollection;
};
dtx.single = {};
dtx.single.ElementManipulation = function() { };
dtx.single.ElementManipulation.__name__ = true;
dtx.single.ElementManipulation.isElement = function(node) {
	return node != null && node.nodeType == dtx.DOMType.ELEMENT_NODE;
};
dtx.single.ElementManipulation.isComment = function(node) {
	return node != null && node.nodeType == dtx.DOMType.COMMENT_NODE;
};
dtx.single.ElementManipulation.isTextNode = function(node) {
	return node != null && node.nodeType == dtx.DOMType.TEXT_NODE;
};
dtx.single.ElementManipulation.isDocument = function(node) {
	return node != null && node.nodeType == dtx.DOMType.DOCUMENT_NODE;
};
dtx.single.ElementManipulation.attr = function(elm,attName) {
	var ret = "";
	if(dtx.single.ElementManipulation.isElement(elm) && attName != null) {
		var element = elm;
		ret = element.getAttribute(attName);
		if(ret == null) ret = "";
	}
	return ret;
};
dtx.single.ElementManipulation.text = function(elm) {
	var text = "";
	if(elm != null) {
		if(dtx.single.ElementManipulation.isElement(elm) || dtx.single.ElementManipulation.isDocument(elm)) text = elm.textContent; else text = elm.nodeValue;
	}
	return text;
};
dtx.single.ElementManipulation.innerHTML = function(elm) {
	var ret = "";
	if(dtx.single.ElementManipulation.isElement(elm) || dtx.single.ElementManipulation.isDocument(elm)) {
		var sb = new StringBuf();
		var $it0 = new dtx.DOMCollection().addNodeList(elm.childNodes,false).iterator();
		while( $it0.hasNext() ) {
			var child = $it0.next();
			dtx.single.ElementManipulation.printHtml(child,sb,false);
		}
		ret = sb.b;
	} else if(elm != null) ret = elm.textContent;
	return ret;
};
dtx.single.ElementManipulation.setInnerHTML = function(elm,html) {
	if(html == null) html = "";
	if(elm != null) {
		var _g = elm.nodeType;
		switch(_g) {
		case dtx.DOMType.ELEMENT_NODE:
			var element = elm;
			element.innerHTML = html;
			break;
		default:
			elm.textContent = html;
		}
	}
	return elm;
};
dtx.single.ElementManipulation.printHtml = function(n,sb,preserveTagNameCase) {
	if(dtx.single.ElementManipulation.isElement(n)) {
		var elmName;
		if(preserveTagNameCase) elmName = n.nodeName; else elmName = n.nodeName.toLowerCase();
		sb.b += "<" + elmName;
		var _g1 = 0;
		var _g = n.attributes.length;
		while(_g1 < _g) {
			var i = _g1++;
			var attNode = n.attributes[i];
			sb.b += " " + attNode.nodeName + "=\"";
			dtx.single.ElementManipulation.addHtmlEscapedString(attNode.nodeValue,sb,true);
			sb.b += "\"";
		}
		var children = new dtx.DOMCollection().addNodeList(n.childNodes,false);
		if(children.collection.length > 0) {
			sb.b += ">";
			var $it0 = HxOverrides.iter(children.collection);
			while( $it0.hasNext() ) {
				var child = $it0.next();
				dtx.single.ElementManipulation.printHtml(child,sb,preserveTagNameCase);
			}
			sb.b += "</" + elmName + ">";
		} else if(Lambda.has(dtx.single.ElementManipulation.selfClosingElms,elmName)) sb.b += " />"; else sb.b += "></" + elmName + ">";
	} else if(dtx.single.ElementManipulation.isDocument(n)) {
		var $it1 = dtx.single.Traversing.children(n,false).iterator();
		while( $it1.hasNext() ) {
			var child1 = $it1.next();
			dtx.single.ElementManipulation.printHtml(child1,sb,preserveTagNameCase);
		}
	} else if(dtx.single.ElementManipulation.isTextNode(n)) dtx.single.ElementManipulation.addHtmlEscapedString(n.nodeValue,sb,false); else if(dtx.single.ElementManipulation.isComment(n)) {
		sb.b += "<!--";
		sb.b += n.nodeValue;
		sb.b += "-->";
	}
};
dtx.single.ElementManipulation.addHtmlEscapedString = function(str,sb,encodeQuotes) {
	var _g1 = 0;
	var _g = str.length;
	while(_g1 < _g) {
		var i = _g1++;
		var charCode = str.charCodeAt(i);
		if(charCode == 38) {
			var peekIndex = i + 1;
			var isEntity = false;
			while(peekIndex < str.length) {
				var c = str.charCodeAt(peekIndex);
				if(c == 59) {
					isEntity = peekIndex > i + 1;
					break;
				}
				if(c >= 97 && c <= 122 || c >= 65 && c <= 90 || c >= 48 && c <= 57 || c == 35) {
					peekIndex++;
					continue;
				} else break;
			}
			if(isEntity) sb.b += "&"; else sb.b += "&amp;";
		} else if(charCode == 60) sb.b += "&lt;"; else if(charCode == 62) sb.b += "&gt;"; else if(charCode == 160) sb.b += "&nbsp;"; else if(encodeQuotes && charCode == 39) sb.b += "&#039;"; else if(encodeQuotes && charCode == 34) sb.b += "&quot;"; else if(charCode < 161) sb.b += String.fromCharCode(charCode); else sb.b += "&#" + charCode + ";";
	}
};
dtx.single.Traversing = function() { };
dtx.single.Traversing.__name__ = true;
dtx.single.Traversing.children = function(node,elementsOnly) {
	if(elementsOnly == null) elementsOnly = true;
	if(node != null && dtx.single.ElementManipulation.isElement(node)) return new dtx.DOMCollection().addNodeList(node.childNodes,elementsOnly); else return new dtx.DOMCollection();
};
dtx.single.Traversing.find = function(node,selector) {
	var newDOMCollection = new dtx.DOMCollection();
	if(node != null && dtx.single.ElementManipulation.isElement(node) || dtx.single.ElementManipulation.isDocument(node)) {
		var element = node;
		if(document.querySelectorAll) {
			var results = element.querySelectorAll(selector);
			newDOMCollection.addNodeList(results);
		} else {
			var engine =
						(('undefined' != typeof Sizzle && Sizzle) ||
						(('undefined' != typeof jQuery) && jQuery.find) ||
						(('undefined' != typeof $) && $.find))
					;
			var results1 = engine(selector,node);
			newDOMCollection.addCollection(results1);
		}
	}
	return newDOMCollection;
};
var haxe = {};
haxe.ds = {};
haxe.ds.Option = { __ename__ : true, __constructs__ : ["Some","None"] };
haxe.ds.Option.Some = function(v) { var $x = ["Some",0,v]; $x.__enum__ = haxe.ds.Option; $x.toString = $estr; return $x; };
haxe.ds.Option.None = ["None",1];
haxe.ds.Option.None.toString = $estr;
haxe.ds.Option.None.__enum__ = haxe.ds.Option;
haxe.io = {};
haxe.io.Path = function(path) {
	var c1 = path.lastIndexOf("/");
	var c2 = path.lastIndexOf("\\");
	if(c1 < c2) {
		this.dir = HxOverrides.substr(path,0,c2);
		path = HxOverrides.substr(path,c2 + 1,null);
		this.backslash = true;
	} else if(c2 < c1) {
		this.dir = HxOverrides.substr(path,0,c1);
		path = HxOverrides.substr(path,c1 + 1,null);
	} else this.dir = null;
	var cp = path.lastIndexOf(".");
	if(cp != -1) {
		this.ext = HxOverrides.substr(path,cp + 1,null);
		this.file = HxOverrides.substr(path,0,cp);
	} else {
		this.ext = null;
		this.file = path;
	}
};
haxe.io.Path.__name__ = true;
haxe.io.Path.withoutExtension = function(path) {
	var s = new haxe.io.Path(path);
	s.ext = null;
	return s.toString();
};
haxe.io.Path.directory = function(path) {
	var s = new haxe.io.Path(path);
	if(s.dir == null) return "";
	return s.dir;
};
haxe.io.Path.extension = function(path) {
	var s = new haxe.io.Path(path);
	if(s.ext == null) return "";
	return s.ext;
};
haxe.io.Path.prototype = {
	toString: function() {
		return (this.dir == null?"":this.dir + (this.backslash?"\\":"/")) + this.file + (this.ext == null?"":"." + this.ext);
	}
};
var haxeextension = {};
haxeextension.HaxeExtension = function() { };
haxeextension.HaxeExtension.__name__ = true;
haxeextension.HaxeExtension.main = function() {
	define(haxeextension.HaxeExtension.load);
};
haxeextension.HaxeExtension.load = function(require,exports,module) {
	adobebrackets.language.LanguageManager.defineLanguage("haxe",{ name : "Haxe", mode : "haxe", fileExtensions : ["hx"], lineComment : ["//"], blockComment : ["/*","*/"]});
	adobebrackets.language.LanguageManager.defineLanguage("hxml",{ name : "Hxml (Haxe Build File)", mode : "haxe", fileExtensions : ["hxml"], lineComment : ["#"]});
	var haxeDomain = new adobebrackets.utils.NodeDomain("haxe",adobebrackets.utils.ExtensionUtils.getModulePath(module,"node/HaxeDomain"));
	adobebrackets.utils.AppInit.appReady(function() {
		adobebrackets.editor.CodeHintManager.registerHintProvider(new haxeextension.codehint.HaxeHint(haxeDomain),["hx"],0);
		haxeextension.commands.BuildCurrentFile.registerCommand();
		haxeextension.commands.SelectBuild.registerCommand();
	});
	adobebrackets.utils.AppInit.htmlReady(function() {
		var less = ".haxe-hint {\n\t.hint-code {\n\t\tcolor: rgb(0,0,0);\n\t}\n\t.hint-type {\n\t\tfont-style: italic;\n\t\tcolor: rgb(150,150,150);\n\t}\n}\n";
		var cssPromise = adobebrackets.utils.ExtensionUtils.parseLessCode(less);
		cssPromise.then(function(css) {
			adobebrackets.utils.ExtensionUtils.addEmbeddedStyleSheet(css);
		});
	});
};
haxeextension.HaxePreferences = function() { };
haxeextension.HaxePreferences.__name__ = true;
haxeextension.HaxePreferences.get_useCompilationServer = function() {
	return haxeextension.HaxePreferences.get_inst().get("use-compilation-server");
};
haxeextension.HaxePreferences.getDisplayFile = function(filePath) {
	var displayFiles = haxeextension.HaxePreferences.get_inst().get("display-file-selection");
	var val = Reflect.field(displayFiles,filePath);
	if(val != null) return haxe.ds.Option.Some(val); else return haxe.ds.Option.None;
};
haxeextension.HaxePreferences.setDisplayFile = function(filePath,displayFile) {
	var displayFiles = haxeextension.HaxePreferences.get_inst().get("display-file-selection");
	if(displayFile != null) displayFiles[filePath] = displayFile; else Reflect.deleteField(displayFile,filePath);
	haxeextension.HaxePreferences.get_inst().set("display-file-selection",displayFiles);
	return haxeextension.HaxePreferences.get_inst().save();
};
haxeextension.HaxePreferences.get_inst = function() {
	if(haxeextension.HaxePreferences.inst == null) {
		haxeextension.HaxePreferences.inst = adobebrackets.preferences.PreferencesManager.getExtensionPrefs("haxe");
		haxeextension.HaxePreferences.setupDefaults(haxeextension.HaxePreferences.inst);
	}
	return haxeextension.HaxePreferences.inst;
};
haxeextension.HaxePreferences.setupDefaults = function(inst) {
	haxeextension.HaxePreferences.get_inst().definePreference("use-compilation-server","boolean",true);
	haxeextension.HaxePreferences.get_inst().definePreference("build-file-selection","object",{ });
	haxeextension.HaxePreferences.get_inst().definePreference("display-file-selection","object",{ });
	haxeextension.HaxePreferences.get_inst().definePreference("build-options","object",{ });
};
haxeextension.codehint = {};
haxeextension.codehint.HaxeHint = function(domain) {
	this.insertHintOnTab = true;
	this.domain = domain;
};
haxeextension.codehint.HaxeHint.__name__ = true;
haxeextension.codehint.HaxeHint.__interfaces__ = [adobebrackets.editor.CodeHintProvider];
haxeextension.codehint.HaxeHint.prototype = {
	hasHints: function(editor,implicitChar) {
		this.editor = editor;
		if(implicitChar == null) return false;
		if(this.isTriggerCharacter(implicitChar)) return true;
		return false;
	}
	,isTriggerCharacter: function(ch) {
		return ch != null && HxOverrides.indexOf([".","("],ch,0) > -1;
	}
	,shouldCompletionClose: function(ch) {
		if(this.openingPos != null) {
			var cursor = this.editor.getCursorPos();
			var earlierLine = cursor.line < this.openingPos.line;
			var earlierPosOnLine = cursor.line == this.openingPos.line && cursor.ch < this.openingPos.ch;
			if(earlierLine || earlierPosOnLine) return true;
		}
		if(ch == null) return false;
		var _g = this.openingChar;
		switch(_g) {
		case ".":
			return HxOverrides.indexOf([" ",";","\n"],ch,0) > -1;
		case "(":
			return HxOverrides.indexOf([")",";","\n"],ch,0) > -1;
		default:
			return false;
		}
	}
	,getHints: function(implicitChar) {
		if(adobebrackets.editor.CodeHintManager.isOpen() && !this.isTriggerCharacter(implicitChar)) return this.continueHintSession(implicitChar); else return this.startHintSession(implicitChar);
	}
	,startHintSession: function(implicitChar) {
		var _g = this;
		this.openingChar = implicitChar;
		this.openingPos = this.editor.getCursorPos();
		this.hintsPromise = $.Deferred();
		this.argHints = null;
		var start = { line : 0, ch : 0};
		var cursorPos = this.editor.document.getRange(start,this.openingPos).length;
		var hintsOutputPromise = this.runHaxeToGetHints(cursorPos);
		hintsOutputPromise.then(function(stderr) {
			var hintsData = { hints : [], match : null, selectInitial : true, handleWideResults : false};
			switch(implicitChar) {
			case ".":
				var hints = [];
				var list = dtx.Tools.parse(stderr);
				var $it0 = dtx.collection.Traversing.find(list,"i").iterator();
				while( $it0.hasNext() ) {
					var item = $it0.next();
					hints.push(_g.buildHintFromCompletionItem(item));
				}
				if(hints.length == 0) {
					_g.editor.displayErrorMessageAtCursor(stderr);
					_g.hintsPromise.reject(stderr);
				} else {
					hintsData.hints = hints;
					_g.hintsPromise.resolve(hintsData);
				}
				break;
			case "(":
				var typeString = dtx.collection.ElementManipulation.text(dtx.Tools.parse(stderr));
				if(typeString.indexOf("(") == -1) {
					var typeParts = typeString.split("->");
					typeParts.pop();
					typeParts.map(function(p) {
						return StringTools.trim(p);
					});
					typeString = typeParts.join(", ");
				}
				hintsData.hints = [typeString];
				_g.hintsPromise.resolve(hintsData);
				break;
			}
		});
		return this.hintsPromise;
	}
	,continueHintSession: function(implicitChar) {
		var _g1 = this;
		if(this.shouldCompletionClose(implicitChar)) return null;
		var _g = this.openingChar;
		switch(_g) {
		case ".":
			var filteredHintsPromise = $.Deferred();
			this.hintsPromise.fail($bind(filteredHintsPromise,filteredHintsPromise.reject));
			this.hintsPromise.then(function(hintsData) {
				if(hintsData != null) {
					var extraText = _g1.getExtraText();
					var newHints = { hints : _g1.filterHints(hintsData.hints,extraText), match : null, selectInitial : true, handleWideResults : false};
					hintsData.match = extraText;
					hintsData.selectInitial == true;
					filteredHintsPromise.resolve(newHints);
				} else filteredHintsPromise.resolve(null);
			});
			return filteredHintsPromise;
		default:
			return this.hintsPromise;
		}
	}
	,getExtraText: function() {
		var cursor = this.editor.getCursorPos();
		return this.editor.document.getRange(this.openingPos,cursor);
	}
	,runHaxeToGetHints: function(pos) {
		var promise = $.Deferred();
		var pair = this.getArgsAndCwdForFile(this.editor.document.file);
		var args = pair.a;
		var cwd = pair.b;
		var req = { cwd : cwd, args : args, currentFile : this.editor.document.file.fullPath, currentContent : this.editor.document.getText(false), pos : pos};
		this.domain.exec("getCompletionHint",req).then(function(result) {
			var processResult = result;
			if(processResult.stderr != null) promise.resolve(processResult.stderr); else promise.reject("Stderr was null: exit code " + processResult.exitCode);
		}).fail(function(err) {
			js.Lib.alert(err);
		});
		return promise;
	}
	,getArgsAndCwdForFile: function(currentFile) {
		var cwd;
		var args = [];
		if(haxeextension.HaxePreferences.get_useCompilationServer()) {
			args.push("--connect");
			args.push("6000");
		}
		{
			var _g = haxeextension.HaxePreferences.getDisplayFile(currentFile.fullPath);
			switch(_g[1]) {
			case 0:
				var hxmlFile = _g[2];
				args.push(hxmlFile);
				cwd = haxe.io.Path.directory(hxmlFile);
				break;
			case 1:
				var className = haxe.io.Path.withoutExtension(currentFile.name);
				args.push("-main");
				args.push(className);
				cwd = currentFile.parentPath;
				break;
			}
		}
		return { a : args, b : cwd};
	}
	,buildHintFromCompletionItem: function(item) {
		var hint = dtx.single.ElementManipulation.attr(item,"n");
		var type = StringTools.trim(dtx.collection.ElementManipulation.innerHTML(dtx.single.Traversing.find(item,"t")));
		var typeSpan;
		if(type != "") typeSpan = "<span class=\"hint-type\">(" + type + ")</span>"; else typeSpan = "";
		var doc = this.cleanDoc(dtx.collection.ElementManipulation.innerHTML(dtx.single.Traversing.find(item,"d")));
		return "<span title=\"" + doc + "\" class=\"haxe-hint\"><span class=\"hint-code\">" + hint + "</span> " + typeSpan + "</span>";
	}
	,cleanDoc: function(doc) {
		console.log(doc);
		var origLines = StringTools.trim(doc).split("\n");
		var lines = [];
		var _g = 0;
		while(_g < origLines.length) {
			var l = origLines[_g];
			++_g;
			l = StringTools.trim(l);
			if(l == "") l = "\n\n";
			lines.push(l);
		}
		return StringTools.htmlEscape(lines.join(""),true);
	}
	,getCodeFromHint: function(hint,extraText) {
		var code = dtx.collection.ElementManipulation.text(dtx.collection.Traversing.find(dtx.Tools.parse(hint),".hint-code"));
		var extraText1 = this.getExtraText();
		if(StringTools.startsWith(code,extraText1)) code = HxOverrides.substr(code,extraText1.length,null);
		return code;
	}
	,filterHints: function(hints,letters) {
		return hints.filter(function(hintText) {
			var hint = dtx.Tools.parse(hintText);
			return StringTools.startsWith(dtx.collection.ElementManipulation.text(hint),letters);
		});
	}
	,insertHint: function(hint) {
		if(this.openingChar == ".") {
			var offset = 0;
			var code = this.getCodeFromHint(hint,this.getExtraText());
			var currentDoc = adobebrackets.document.DocumentManager.getCurrentDocument();
			var pos = this.editor.getCursorPos();
			var start = { line : pos.line, ch : pos.ch - offset};
			currentDoc.replaceRange(code,start,pos);
		}
		return false;
	}
};
haxeextension.commands = {};
haxeextension.commands.BuildCurrentFile = function() { };
haxeextension.commands.BuildCurrentFile.__name__ = true;
haxeextension.commands.BuildCurrentFile.command = function() {
	js.Lib.alert("Build current file!");
	var useCompileServer = haxeextension.HaxePreferences.get_useCompilationServer();
	return null;
};
haxeextension.commands.BuildCurrentFile.registerCommand = function() {
	var cmd = adobebrackets.command.CommandManager.register("Build current file","jasononeil.haxeextension.buildcurrent",haxeextension.commands.BuildCurrentFile.command);
	adobebrackets.command.Menus.getMenu("file-menu").addMenuItem(cmd,"Alt-Enter",adobebrackets.command.Menus.LAST);
};
haxeextension.commands.SelectBuild = function() { };
haxeextension.commands.SelectBuild.__name__ = true;
haxeextension.commands.SelectBuild.command = function() {
	var projectBase = adobebrackets.project.ProjectManager.getBaseUrl();
	var hxmlFilter = function(f) {
		return haxe.io.Path.extension(f.name) == "hxml";
	};
	var hxmlFiles = adobebrackets.project.ProjectManager.getAllFiles(hxmlFilter,false);
	hxmlFiles.then(function(files) {
		var d = $.Deferred();
		adobebrackets.filesystem.FileSystem.showOpenDialog(false,false,"Select completion hxml file",projectBase,["*.hxml"],function(error,files1) {
			if(error != null) throw error;
			var completionFile = files1[0];
			var filePath = adobebrackets.document.DocumentManager.getCurrentDocument().file.fullPath;
			haxeextension.HaxePreferences.setDisplayFile(filePath,completionFile);
		});
	});
	return null;
};
haxeextension.commands.SelectBuild.registerCommand = function() {
	var cmd = adobebrackets.command.CommandManager.register("Build options","jasononeil.haxeextension.selectbuild",haxeextension.commands.SelectBuild.command);
	adobebrackets.command.Menus.getMenu("file-menu").addMenuItem(cmd,"Ctrl-Alt-Enter",adobebrackets.command.Menus.LAST);
};
var js = {};
js.Boot = function() { };
js.Boot.__name__ = true;
js.Boot.__string_rec = function(o,s) {
	if(o == null) return "null";
	if(s.length >= 5) return "<...>";
	var t = typeof(o);
	if(t == "function" && (o.__name__ || o.__ename__)) t = "object";
	switch(t) {
	case "object":
		if(o instanceof Array) {
			if(o.__enum__) {
				if(o.length == 2) return o[0];
				var str = o[0] + "(";
				s += "\t";
				var _g1 = 2;
				var _g = o.length;
				while(_g1 < _g) {
					var i = _g1++;
					if(i != 2) str += "," + js.Boot.__string_rec(o[i],s); else str += js.Boot.__string_rec(o[i],s);
				}
				return str + ")";
			}
			var l = o.length;
			var i1;
			var str1 = "[";
			s += "\t";
			var _g2 = 0;
			while(_g2 < l) {
				var i2 = _g2++;
				str1 += (i2 > 0?",":"") + js.Boot.__string_rec(o[i2],s);
			}
			str1 += "]";
			return str1;
		}
		var tostr;
		try {
			tostr = o.toString;
		} catch( e ) {
			return "???";
		}
		if(tostr != null && tostr != Object.toString) {
			var s2 = o.toString();
			if(s2 != "[object Object]") return s2;
		}
		var k = null;
		var str2 = "{\n";
		s += "\t";
		var hasp = o.hasOwnProperty != null;
		for( var k in o ) {
		if(hasp && !o.hasOwnProperty(k)) {
			continue;
		}
		if(k == "prototype" || k == "__class__" || k == "__super__" || k == "__interfaces__" || k == "__properties__") {
			continue;
		}
		if(str2.length != 2) str2 += ", \n";
		str2 += s + k + " : " + js.Boot.__string_rec(o[k],s);
		}
		s = s.substring(1);
		str2 += "\n" + s + "}";
		return str2;
	case "function":
		return "<function>";
	case "string":
		return o;
	default:
		return String(o);
	}
};
js.Lib = function() { };
js.Lib.__name__ = true;
js.Lib.alert = function(v) {
	alert(js.Boot.__string_rec(v,""));
};
var tink = {};
tink.core = {};
tink.core.Error = function() { };
tink.core.Error.__name__ = true;
tink.core.Error.prototype = {
	printPos: function() {
		return this.pos.className + "." + this.pos.methodName + ":" + this.pos.lineNumber;
	}
	,toString: function() {
		var ret = "Error: " + this.message;
		if(this.pos != null) ret += " " + this.printPos();
		return ret;
	}
	,throwSelf: function() {
		throw this;
	}
};
function $iterator(o) { if( o instanceof Array ) return function() { return HxOverrides.iter(o); }; return typeof(o.iterator) == 'function' ? $bind(o,o.iterator) : o.iterator; }
var $_, $fid = 0;
function $bind(o,m) { if( m == null ) return null; if( m.__id__ == null ) m.__id__ = $fid++; var f; if( o.hx__closures__ == null ) o.hx__closures__ = {}; else f = o.hx__closures__[m.__id__]; if( f == null ) { f = function(){ return f.method.apply(f.scope, arguments); }; f.scope = o; f.method = m; o.hx__closures__[m.__id__] = f; } return f; }
if(Array.prototype.indexOf) HxOverrides.indexOf = function(a,o,i) {
	return Array.prototype.indexOf.call(a,o,i);
};
String.__name__ = true;
Array.__name__ = true;
if(Array.prototype.map == null) Array.prototype.map = function(f) {
	var a = [];
	var _g1 = 0;
	var _g = this.length;
	while(_g1 < _g) {
		var i = _g1++;
		a[i] = f(this[i]);
	}
	return a;
};
if(Array.prototype.filter == null) Array.prototype.filter = function(f1) {
	var a1 = [];
	var _g11 = 0;
	var _g2 = this.length;
	while(_g11 < _g2) {
		var i1 = _g11++;
		var e = this[i1];
		if(f1(e)) a1.push(e);
	}
	return a1;
};
var adobebrackets = adobebrackets || { };
adobebrackets.command = adobebrackets.command || { };
adobebrackets.command.CommandManager = brackets.getModule("command/CommandManager");
var adobebrackets = adobebrackets || { };
adobebrackets.command = adobebrackets.command || { };
adobebrackets.command.KeyBindingManager = brackets.getModule("command/KeyBindingManager");
var adobebrackets = adobebrackets || { };
adobebrackets.command = adobebrackets.command || { };
adobebrackets.command.Menus = brackets.getModule("command/Menus");
var adobebrackets = adobebrackets || { };
adobebrackets.command = adobebrackets.command || { };
adobebrackets.command.ContextMenu = brackets.getModule("command/Menus").ContextMenu;
var adobebrackets = adobebrackets || { };
adobebrackets.command = adobebrackets.command || { };
adobebrackets.command.MenuSection = brackets.getModule("command/Menus").MenuSection;
var adobebrackets = adobebrackets || { };
adobebrackets.document = adobebrackets.document || { };
adobebrackets.document.Document = brackets.getModule("document/Document");
var adobebrackets = adobebrackets || { };
adobebrackets.document = adobebrackets.document || { };
adobebrackets.document.DocumentManager = brackets.getModule("document/DocumentManager");
var adobebrackets = adobebrackets || { };
adobebrackets.editor = adobebrackets.editor || { };
adobebrackets.editor.CodeHintManager = brackets.getModule("editor/CodeHintManager");
var adobebrackets = adobebrackets || { };
adobebrackets.editor = adobebrackets.editor || { };
adobebrackets.editor.Editor = brackets.getModule("editor/Editor");
var adobebrackets = adobebrackets || { };
adobebrackets.editor = adobebrackets.editor || { };
adobebrackets.editor.InlineWidget = brackets.getModule("editor/InlineWidget");
var adobebrackets = adobebrackets || { };
adobebrackets.filesystem = adobebrackets.filesystem || { };
adobebrackets.filesystem.FileSystemEntry = brackets.getModule("filesystem/FileSystemEntry");
var adobebrackets = adobebrackets || { };
adobebrackets.filesystem = adobebrackets.filesystem || { };
adobebrackets.filesystem.Directory = brackets.getModule("filesystem/Directory");
var adobebrackets = adobebrackets || { };
adobebrackets.filesystem = adobebrackets.filesystem || { };
adobebrackets.filesystem.File = brackets.getModule("filesystem/File");
var adobebrackets = adobebrackets || { };
adobebrackets.filesystem = adobebrackets.filesystem || { };
adobebrackets.filesystem.FileSystem = brackets.getModule("filesystem/FileSystem");
var adobebrackets = adobebrackets || { };
adobebrackets.filesystem = adobebrackets.filesystem || { };
adobebrackets.filesystem.FileSystemStats = brackets.getModule("filesystem/FileSystemStats");
var adobebrackets = adobebrackets || { };
adobebrackets.language = adobebrackets.language || { };
adobebrackets.language.LanguageManager = brackets.getModule("language/LanguageManager");
var adobebrackets = adobebrackets || { };
adobebrackets.preferences = adobebrackets.preferences || { };
adobebrackets.preferences.PreferencesManager = brackets.getModule("preferences/PreferencesManager");
var adobebrackets = adobebrackets || { };
adobebrackets.project = adobebrackets.project || { };
adobebrackets.project.ProjectManager = brackets.getModule("project/ProjectManager");
var adobebrackets = adobebrackets || { };
adobebrackets.utils = adobebrackets.utils || { };
adobebrackets.utils.AppInit = brackets.getModule("utils/AppInit");
var adobebrackets = adobebrackets || { };
adobebrackets.utils = adobebrackets.utils || { };
adobebrackets.utils.ExtensionUtils = brackets.getModule("utils/ExtensionUtils");
var adobebrackets = adobebrackets || { };
adobebrackets.utils = adobebrackets.utils || { };
adobebrackets.utils.NodeConnection = brackets.getModule("utils/NodeConnection");
var adobebrackets = adobebrackets || { };
adobebrackets.utils = adobebrackets.utils || { };
adobebrackets.utils.NodeDomain = brackets.getModule("utils/NodeDomain");
var adobebrackets = adobebrackets || { };
adobebrackets.widgets = adobebrackets.widgets || { };
adobebrackets.widgets.Dialogs = brackets.getModule("widgets/Dialogs");
dtx.DOMType.DOCUMENT_NODE = 9;
dtx.DOMType.ELEMENT_NODE = 1;
dtx.DOMType.TEXT_NODE = 3;
dtx.DOMType.COMMENT_NODE = 8;
dtx.Tools.firstTag = new EReg("<([a-z]+)[ />]","");
dtx.single.ElementManipulation.selfClosingElms = ["area","base","br","col","command","embed","hr","img","input","keygen","link","meta","param","source","track","wbr"];
haxeextension.HaxeExtension.main();
})();
