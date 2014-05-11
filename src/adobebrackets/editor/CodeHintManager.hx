package adobebrackets.editor;

import jQuery.Deferred;
import jQuery.haxe.Either;

extern class CodeHintManager {
	public static function registerHintProvider( provider:CodeHintProvider, languageIDs:Array<String>, ?priority:Int ):Void;
	public static function hasValidExclusion( exclusion:String, textAfterCursor:String ):Bool;
	public static function isOpen():Bool;
	public static function activeEditorChangeHandler( event:Dynamic, current:Dynamic, previous:Dynamic ):Void;

	private static function __init__():Void untyped {
		var adobebrackets = adobebrackets || {};
		adobebrackets.editor = adobebrackets.editor || {};
		adobebrackets.editor.CodeHintManager = brackets.getModule("editor/CodeHintManager");
	}
}

interface CodeHintProvider {
	public function hasHints( editor:Editor, implicitChar:String ):Bool;
	public function getHints( implicitChar:String ):Either<HintsInfo,Deferred>;
	public function insertHint( hint:String ):Bool;
	var insertHintOnTab:Bool;
}

typedef HintsInfo = {
	var hints:Array<String>; /* Or Array<JQuery> */
	var match:String;
	var selectInitial:Bool;
	var handleWideResults:Bool;
}; // Can also be a jQuery deferred
