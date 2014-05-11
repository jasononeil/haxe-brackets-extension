package adobebrackets.filesystem;

import adobebrackets.filesystem.FileSystem;
import adobebrackets.filesystem.FileSystemEntry;

extern class FileSystem {

	public static function init( impl:FileSystemImpl ):Void;
	public static function close():Void;
	public static function isAbsolutePath( fullPath:String ):Bool;
	public static function getFileForPath( fullPath:String ):File;
	public static function getDirectoryForPath( fullPath:String ):Directory;
	public static function resolve( path:String, cb:String->FileSystemEntry->FileSystemStats->Void ):Void;
	public static function showOpenDialog( allowMultipleSelection:Bool, chooseDirectories:Bool, title:String, initialPath:String, ?fileTypes:Array<String>, callback:String->Array<String>->Void ):Void;
	public static function showSaveDialog( title:String, initialPath:String, proposedNewFilename:String, cb:String->String->Void ):Void;
	public static function watch( entry:FileSystemEntry, filter:String->Bool, ?watchFinishedCB:String->Void ):Void;
	public static function unwatch( entry:FileSystemEntry, cb:String->Void ):Void;
	public static function on( event:String, handler:String->Void ):Void;
	public static function off( event:String, handler:String->Void ):Void;

	private static function __init__():Void untyped {
		var adobebrackets = adobebrackets || {};
		adobebrackets.filesystem = adobebrackets.filesystem || {};
		adobebrackets.filesystem.FileSystem = brackets.getModule("filesystem/FileSystem");
	}
}

typedef FileSystemImpl = Dynamic;
