package adobebrackets.editor;

import adobebrackets.editor.Editor;
import jQuery.JQuery;
import jQuery.Promise;

extern class InlineWidget {
	public var id:Int;
	public var hostEditor:Editor;
	public var htmlContent:String;
	@:native("$htmlContent") public var JQHtmlContent:JQuery;
	public var height:Int;


	public function new();
	public function close():Promise;
	public function hasFocus():Bool;
	public function onClosed():Void;
	public function onAdded():Void;
	public function load( ed:Editor ):Void;
	public function onParentShown():Void;
	public function refresh():Void;

	private static function __init__():Void untyped {
		var adobebrackets = adobebrackets || {};
		adobebrackets.editor = adobebrackets.editor || {};
		adobebrackets.editor.InlineWidget = brackets.getModule("editor/InlineWidget");
	}
}
