package adobebrackets.utils;

import js.html.*;
import jQuery.Deferred;
import jQuery.Promise;

extern class ExtensionUtils {

	static public function addEmbeddedStyleSheet( css:String ):StyleElement;
	static public function addLinkedStyleSheet( url:String, ?d:Deferred ):LinkElement;
	static public function isAbsolutePathOrUrl( pathOrUrl:String ):Bool;
	static public function parseLessCode( lessCode:String, ?baseUrl:String ):Promise;
	static public function getModulePath( module:String, ?path:String ):String;
	static public function getModuleUrl( module:String, ?path:String ):String;
	static public function loadFile( module:String, ?path:String ):Promise;
	static public function loadStyleSheet( module:String, ?path:String ):Promise;

	private static function __init__():Void untyped {
		var adobebrackets = adobebrackets || {};
		adobebrackets.utils = adobebrackets.utils || {};
		adobebrackets.utils.ExtensionUtils = brackets.getModule("utils/ExtensionUtils");
	}
}
