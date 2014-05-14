(function ($hx_exports) { "use strict";
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
var Reflect = function() { };
Reflect.__name__ = true;
Reflect.compare = function(a,b) {
	if(a == b) return 0; else if(a > b) return 1; else return -1;
};
var Std = function() { };
Std.__name__ = true;
Std.string = function(s) {
	return js.Boot.__string_rec(s,"");
};
Std.parseInt = function(x) {
	var v = parseInt(x,10);
	if(v == 0 && (HxOverrides.cca(x,1) == 120 || HxOverrides.cca(x,1) == 88)) v = parseInt(x);
	if(isNaN(v)) return null;
	return v;
};
var StringTools = function() { };
StringTools.__name__ = true;
StringTools.startsWith = function(s,start) {
	return s.length >= start.length && HxOverrides.substr(s,0,start.length) == start;
};
StringTools.endsWith = function(s,end) {
	var elen = end.length;
	var slen = s.length;
	return slen >= elen && HxOverrides.substr(s,slen - elen,elen) == end;
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
var haxe = {};
haxe.io = {};
haxe.io.Eof = function() { };
haxe.io.Eof.__name__ = true;
haxe.io.Eof.prototype = {
	toString: function() {
		return "Eof";
	}
};
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
haxe.io.Path.withoutDirectory = function(path) {
	var s = new haxe.io.Path(path);
	s.dir = null;
	return s.toString();
};
haxe.io.Path.directory = function(path) {
	var s = new haxe.io.Path(path);
	if(s.dir == null) return "";
	return s.dir;
};
haxe.io.Path.addTrailingSlash = function(path) {
	if(path.length == 0) return "/";
	var c1 = path.lastIndexOf("/");
	var c2 = path.lastIndexOf("\\");
	if(c1 < c2) {
		if(c2 != path.length - 1) return path + "\\"; else return path;
	} else if(c1 != path.length - 1) return path + "/"; else return path;
};
haxe.io.Path.removeTrailingSlashes = function(path) {
	try {
		while(true) {
			var _g = HxOverrides.cca(path,path.length - 1);
			switch(_g) {
			case 47:case 92:
				path = HxOverrides.substr(path,0,-1);
				break;
			default:
				throw "__break__";
			}
		}
	} catch( e ) { if( e != "__break__" ) throw e; }
	return path;
};
haxe.io.Path.prototype = {
	toString: function() {
		return (this.dir == null?"":this.dir + (this.backslash?"\\":"/")) + this.file + (this.ext == null?"":"." + this.ext);
	}
};
var haxeextension = {};
haxeextension.domain = {};
haxeextension.domain.CompletionRunner = function() { };
haxeextension.domain.CompletionRunner.__name__ = true;
haxeextension.domain.CompletionRunner.getCompletionHint = function(req,completeFn) {
	nodejs.Tmp.dir({ unsafeCleanup : false},function(err,dirPath) {
		if(err != null) throw err;
		var completionArgs = [];
		var filename = haxe.io.Path.withoutDirectory(req.currentFile);
		haxeextension.domain.HaxeRunner.getClassPaths(req.cwd,req.args,function(err1,cps) {
			if(err1 != null) completeFn(err1,null);
			var tmpFile = null;
			try {
				var pathRelativeToClassPath = haxeextension.domain.HaxeRunner.pathRelativeToClassPaths(cps,req.currentFile);
				tmpFile = dirPath + pathRelativeToClassPath;
				haxeextension.domain.FsUtil.saveContentInSubDir(tmpFile,req.currentContent);
			} catch( e ) {
				completeFn("Failed to save tmp file " + tmpFile + " for completion: " + Std.string(e),null);
			}
			var _g = 0;
			var _g1 = req.args;
			while(_g < _g1.length) {
				var a = _g1[_g];
				++_g;
				completionArgs.push(a);
			}
			completionArgs.push("-cp");
			completionArgs.push(dirPath);
			completionArgs.push("--display");
			completionArgs.push("" + tmpFile + "@" + req.pos);
			var customCompleteFn = function(err2,result) {
				try {
					haxeextension.domain.FsUtil.rmdir(dirPath);
					completeFn(err2,result);
				} catch( e1 ) {
					completeFn("Failed to remove tmp completion folder " + dirPath + ": " + Std.string(e1),null);
				}
			};
			haxeextension.domain.HaxeRunner.runHaxe(req.cwd,completionArgs,customCompleteFn);
		});
	});
};
haxeextension.domain.FsUtil = function() { };
haxeextension.domain.FsUtil.__name__ = true;
haxeextension.domain.FsUtil.rmdir = function(dirPath) {
	if(js.Node.require("fs").existsSync(dirPath)) {
		var _g = 0;
		var _g1 = js.Node.require("fs").readdirSync(dirPath);
		while(_g < _g1.length) {
			var file = _g1[_g];
			++_g;
			var filePath = haxe.io.Path.addTrailingSlash(dirPath) + file;
			if(sys.FileSystem.isDirectory(filePath)) haxeextension.domain.FsUtil.rmdir(filePath); else js.Node.require("fs").unlinkSync(filePath);
		}
		js.Node.require("fs").rmdirSync(dirPath);
	}
};
haxeextension.domain.FsUtil.mkdir = function(dirPath) {
	if(!js.Node.require("fs").existsSync(dirPath)) {
		var parentDir = haxe.io.Path.directory(haxe.io.Path.removeTrailingSlashes(dirPath));
		haxeextension.domain.FsUtil.mkdir(parentDir);
		js.Node.require("fs").mkdirSync(dirPath);
	}
};
haxeextension.domain.FsUtil.saveContentInSubDir = function(filename,content) {
	var dir = haxe.io.Path.directory(filename);
	haxeextension.domain.FsUtil.mkdir(dir);
	sys.io.File.saveContent(filename,content);
};
haxeextension.domain.HaxeDomain = function() { };
haxeextension.domain.HaxeDomain.__name__ = true;
haxeextension.domain.HaxeDomain.cmdGetMemory = function(total) {
	if(total) return js.Node.require("os").totalmem(); else return js.Node.require("os").freemem();
};
haxeextension.domain.HaxeDomain.init = $hx_exports.init = function(domainManager) {
	if(!domainManager.hasDomain("haxe")) {
		domainManager.registerDomain("haxe",{ major : 0, minor : 1});
		domainManager.registerCommand("haxe","getMemory",haxeextension.domain.HaxeDomain.cmdGetMemory,false);
		domainManager.registerCommand("haxe","getCompletionHint",haxeextension.domain.CompletionRunner.getCompletionHint,true);
		domainManager.registerCommand("haxe","getAllTypesInBuild",haxeextension.domain.MacroRunner.getAllTypesInBuild,true);
		domainManager.registerCommand("haxe","getAllFieldsInModule",haxeextension.domain.MacroRunner.getAllFieldsInModule,true);
	}
};
haxeextension.domain.HaxeRunner = function() { };
haxeextension.domain.HaxeRunner.__name__ = true;
haxeextension.domain.HaxeRunner.runHaxe = function(cwd,args,completeFn) {
	haxeextension.domain.HaxeRunner.run(cwd,"haxe",args,function(err,result) {
		if(err != null) completeFn(err,result);
		if(result.stderr.indexOf("Couldn't connect on 127.0.0.1:6000") > -1) haxeextension.domain.HaxeRunner.startCompilationServer(6000,function(err1) {
			if(err1 != null) {
				completeFn(err1,null);
				return;
			}
			haxeextension.domain.HaxeRunner.runHaxe(cwd,args,completeFn);
		}); else completeFn(err,result);
	});
};
haxeextension.domain.HaxeRunner.runHaxelib = function(cwd,args,completeFn) {
	haxeextension.domain.HaxeRunner.run(cwd,"haxelib",args,completeFn);
};
haxeextension.domain.HaxeRunner.run = function(cwd,executable,args,completeFn) {
	var processData = { exitCode : -1, stdout : null, stderr : null};
	var childProcess = js.Node.require("child_process").spawn(executable,args,{ cwd : cwd});
	childProcess.on("error",function(err) {
		completeFn("Error on child process: " + Std.string(err),null);
	});
	childProcess.stdout.on("data",function(data) {
		if(processData.stdout == null) processData.stdout = "";
		processData.stdout += data;
	});
	childProcess.stderr.on("data",function(data1) {
		if(processData.stderr == null) processData.stderr = "";
		processData.stderr += data1;
	});
	childProcess.on("close",function(code,signal) {
		if(signal != null || code == null) completeFn("Process exited with signal " + signal + ".",null); else if(code != null) {
			processData.exitCode = code;
			completeFn(null,processData);
		}
	});
};
haxeextension.domain.HaxeRunner.getClassPaths = function(cwd,inArgs,cb) {
	var allArgs = [];
	var cps = [];
	var libs = [];
	try {
		allArgs = haxeextension.domain.HaxeRunner.loadArgsRecursively(cwd,inArgs);
	} catch( e ) {
		cb("In getClassPaths, failed to load args recursively: " + Std.string(e),null);
	}
	while(allArgs.length > 0) {
		var arg = StringTools.trim(allArgs.shift());
		switch(arg) {
		case "-cp":
			var cp = StringTools.trim(allArgs.shift());
			if(StringTools.startsWith(cp,cwd) == false) cp = haxe.io.Path.addTrailingSlash(cwd) + cp;
			cps.push(cp);
			break;
		case "-lib":
			var lib = StringTools.trim(allArgs.shift());
			libs.push(lib);
			break;
		}
	}
	if(libs.length > 0) {
		var haxelibArgs = ["path"].concat(libs);
		haxeextension.domain.HaxeRunner.runHaxelib(cwd,haxelibArgs,function(err,result) {
			if(err != null) cb(err,null);
			try {
				var lines = result.stdout.split("\n");
				var _g = 0;
				while(_g < lines.length) {
					var l = lines[_g];
					++_g;
					l = StringTools.trim(l);
					if(l != "" && StringTools.startsWith(l,"-") == false) cps.push(l);
				}
				cb(null,cps);
			} catch( e1 ) {
				cb("In getClassPaths, failed to process output of \"haxelib " + haxelibArgs.join(" ") + "\": " + Std.string(e1),null);
			}
		});
	} else cb(null,cps);
};
haxeextension.domain.HaxeRunner.loadArgsRecursively = function(cwd,inArgs,outArgs) {
	if(outArgs == null) outArgs = [];
	var _g = 0;
	while(_g < inArgs.length) {
		var arg = inArgs[_g];
		++_g;
		arg = StringTools.trim(arg);
		if(StringTools.endsWith(arg,".hxml")) {
			if(StringTools.startsWith(arg,cwd)) arg = HxOverrides.substr(arg,cwd.length,null);
			var relativeDir = haxe.io.Path.directory(arg);
			var lines = sys.io.File.getContent(haxe.io.Path.addTrailingSlash(cwd) + arg).split("\n");
			var _g1 = 0;
			while(_g1 < lines.length) {
				var l = lines[_g1];
				++_g1;
				l = StringTools.trim(l);
				if(StringTools.startsWith(l,"#")) continue;
				if(StringTools.startsWith(l,"-cp") && relativeDir != "") {
					var cp = StringTools.trim(HxOverrides.substr(l,3,null));
					outArgs.push("-cp");
					outArgs.push("" + relativeDir + "/" + cp);
				} else {
					var spaceIndex = l.indexOf(" ");
					if(StringTools.startsWith(l,"-") && spaceIndex > -1) {
						outArgs.push(HxOverrides.substr(l,0,spaceIndex));
						outArgs.push(StringTools.trim(HxOverrides.substr(l,spaceIndex + 1,null)));
					} else if(StringTools.endsWith(l,".hxml")) haxeextension.domain.HaxeRunner.loadArgsRecursively(haxe.io.Path.addTrailingSlash(cwd) + relativeDir,[l],outArgs); else if(l != "") outArgs.push(l);
				}
			}
		} else outArgs.push(arg);
	}
	return outArgs;
};
haxeextension.domain.HaxeRunner.pathRelativeToClassPaths = function(classPaths,filePath) {
	var relativePaths = [];
	var _g = 0;
	while(_g < classPaths.length) {
		var cp = classPaths[_g];
		++_g;
		if(StringTools.startsWith(filePath,cp)) relativePaths.push(HxOverrides.substr(filePath,cp.length,null));
	}
	if(relativePaths.length > 0) {
		relativePaths.sort(function(cp1,cp2) {
			return Reflect.compare(cp1.length,cp2.length);
		});
		return relativePaths[0];
	} else return filePath;
};
haxeextension.domain.HaxeRunner.startCompilationServer = function(port,cb) {
	var called = false;
	var wrappedCb = function(err) {
		if(!called) cb(err);
		called = true;
	};
	haxeextension.domain.HaxeRunner.compilationServerProcess = js.Node.require("child_process").spawn("haxe",["--wait","" + port]);
	haxeextension.domain.HaxeRunner.compilationServerProcess.on("error",wrappedCb);
	js.Node.setTimeout(wrappedCb,50);
};
haxeextension.domain.MacroRunner = function() { };
haxeextension.domain.MacroRunner.__name__ = true;
haxeextension.domain.MacroRunner.getAllTypesInBuild = function(req,completeFn) {
	nodejs.Tmp.dir({ unsafeCleanup : true},function(err,dirPath) {
		if(err != null) throw err;
		var completionArgs = [];
		var filename = haxe.io.Path.withoutDirectory(req.currentFile);
		var pathRelativeToClassPath = filename;
		var tmpFile = haxe.io.Path.addTrailingSlash(dirPath) + pathRelativeToClassPath;
		sys.io.File.saveContent(tmpFile,req.currentContent);
		completionArgs.push("-cp");
		completionArgs.push(dirPath);
		var _g = 0;
		var _g1 = req.args;
		while(_g < _g1.length) {
			var a = _g1[_g];
			++_g;
			completionArgs.push(a);
		}
		completionArgs.push("--display");
		completionArgs.push("" + tmpFile + "@" + req.pos);
		var customCompleteFn = function(err1,result) {
			haxeextension.domain.FsUtil.rmdir(dirPath);
			completeFn(err1,result);
		};
		haxeextension.domain.HaxeRunner.runHaxe(req.cwd,completionArgs,customCompleteFn);
	});
};
haxeextension.domain.MacroRunner.getAllFieldsInModule = function(req,completeFn) {
	throw "not ready";
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
js.Node = function() { };
js.Node.__name__ = true;
var sys = {};
sys.FileSystem = function() { };
sys.FileSystem.__name__ = true;
sys.FileSystem.isDirectory = function(path) {
	if(js.Node.require("fs").statSync(path).isSymbolicLink()) return false; else return js.Node.require("fs").statSync(path).isDirectory();
};
sys.io = {};
sys.io.File = function() { };
sys.io.File.__name__ = true;
sys.io.File.getContent = function(path) {
	return js.Node.require("fs").readFileSync(path,sys.io.File.UTF8_ENCODING);
};
sys.io.File.saveContent = function(path,content) {
	js.Node.require("fs").writeFileSync(path,content);
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
js.Node.setTimeout = setTimeout;
js.Node.clearTimeout = clearTimeout;
js.Node.setInterval = setInterval;
js.Node.clearInterval = clearInterval;
js.Node.global = global;
js.Node.process = process;
js.Node.require = require;
js.Node.console = console;
js.Node.module = module;
js.Node.stringify = JSON.stringify;
js.Node.parse = JSON.parse;
var version = HxOverrides.substr(js.Node.process.version,1,null).split(".").map(Std.parseInt);
if(version[0] > 0 || version[1] >= 9) {
	js.Node.setImmediate = setImmediate;
	js.Node.clearImmediate = clearImmediate;
}
var nodejs = nodejs || { };
nodejs.Tmp = require("tmp");
sys.io.File.UTF8_ENCODING = { encoding : "utf8"};
})(typeof window != "undefined" ? window : exports);
