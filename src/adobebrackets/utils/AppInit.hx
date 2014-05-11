package adobebrackets.utils;

extern class AppInit {
	static public function appReady( f:Void->Void ):Void;
	static public function htmlReady( f:Void->Void ):Void;

	private static function __init__():Void untyped {
		var adobebrackets = adobebrackets || {};
		adobebrackets.utils = adobebrackets.utils || {};
		adobebrackets.utils.AppInit = brackets.getModule("utils/AppInit");
	}
}
