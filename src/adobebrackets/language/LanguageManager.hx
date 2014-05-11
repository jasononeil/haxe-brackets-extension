package adobebrackets.language;

import adobebrackets.filesystem.File;
import jQuery.Promise;

extern class LanguageManager {

	public static function getLanguage( id:String ):Language;
	public static function getLanguageForExtension( ext:String ):Null<Language>;
	public static function getLanguageForPath( path:String ):Null<Language>;
	public static function defineLanguage( id:String, definition:LanguageDefinition ):Promise;

	private static function __init__():Void untyped {
		var adobebrackets = adobebrackets || {};
		adobebrackets.language = adobebrackets.language || {};
		adobebrackets.language.LanguageManager = brackets.getModule("language/LanguageManager");
	}
}

typedef LanguageDefinition = {
	var name:String;
	@:optional var fileExtensions:Array<String>;
	@:optional var fileNames:Array<String>;
	@:optional var blockComment:Array<String>;
	@:optional var lineComment:Array<String>;
	@:optional var mode:String;
}
