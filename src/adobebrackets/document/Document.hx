package adobebrackets.document;

import adobebrackets.filesystem.File;
import adobebrackets.language.Language;

extern class Document {

	public function new( file:File, initialTimestamp:Date, rawText:String );

	public var file:File;
	public var language:Language;
	public var isDirty:Bool;
	public var isSaving:Bool;
	public var diskTimestamp:Date;
	public var keepChangesTime:Float;
	public function addRef():Void;
	public function releaseRef():Void;
	public function getText( useOriginalLineEndings:Bool ):String;
	public static function normalizeText():String;
	public function setText( text:String ):Void;
	public function refreshText( text:String, newTimestamp:Date ):Void;
	public function replaceRange( text:String, start:Pos, ?end:Pos, ?origin:String ):Void;
	public function getRange( start:Pos, end:Pos ):String;
	public function getLine( lineNum:Int ):String;
	public function batchOperation( operation:Void->Void ):Void;
	public function notifySaved():Void;
	public function adjustPosForChange( pos:Pos, textLines:Array<String>, start:Pos, end:Pos ):Pos;
	public function doMultipleEdits( edits:ManyEditDescriptions, ?origin:String ):Array<{ start:Pos, end:Pos, primary:Bool, reversed:Bool }>;
	public function toString():String;
	public function getLanguage():Language;
	public function isUntitled():Bool;

	private static function __init__():Void untyped {
		var adobebrackets = adobebrackets || {};
		adobebrackets.document = adobebrackets.document || {};
		adobebrackets.document.Document = brackets.getModule("document/Document");
	}
}

typedef Pos = {
	var line:Int;
	var ch:Int;
}

typedef EditDescription = {
	/** Text to insert / replace **/
	var text:String;

	/** Position to insert, or start position of selection to replace **/
	var start:Pos;

	/** End position of selection to replace (if not specified, text is inserted). **/
	@:optional var end:Pos;
}

typedef ManyEditDescriptions = Array<{
	var edit: EditDescription;
	@:optional var selection:{
		var start:Pos;
		var end:Pos;
		var primary:Bool;
		var reversed: Bool;
		var isBeforeEdit: Bool;
 	};
}>;
