package nodejs;

extern class Tmp {

	public static function file( ?options:TmpOptions, cb:String->String->Int->Void ):Void;
	public static function dir( ?options:TmpOptions, cb:String->String->Void ):Void;
	public static function tmpName( ?options:TmpOptions, cb:String->String->Void ):Void;

	public static function setGracefulCleanup():Void;

	private static function __init__():Void untyped {
		var nodejs = nodejs || {};
		nodejs.Tmp = require( 'tmp' );
	}
}

typedef TmpOptions = {
    /** The file mode to create with, it fallbacks to 0600 on file creation and 0700 on directory creation **/
    @:optional var mode:Int;

    /** The optional prefix, fallbacks to tmp- if not provided **/
    @:optional var prefix:String;

    /** The optional postfix, fallbacks to .tmp on file creation **/
    @:optional var postfix:String;

    /** Mkstemps like filename template, no default **/
    @:optional var template:String;

    /** The optional temporary directory, fallbacks to system default (guesses from environment) **/
    @:optional var dir:String;

    /** How many times should the function try to get a unique filename before giving up, default 3 **/
    @:optional var tries:Int;

    /** Signals that the temporary file or directory should not be deleted on exit, default is false, means delete **/
    @:optional var keep:Bool;

    /** Recursively removes the created temporary directory, even when it's not empty. default is false **/
    @:optional var unsafeCleanup:Bool;
}
