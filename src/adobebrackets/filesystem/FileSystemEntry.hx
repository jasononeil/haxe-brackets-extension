package adobebrackets.filesystem;

import adobebrackets.filesystem.FileSystem;
import haxeextension.model.Typedefs;

extern class FileSystemEntry {

	public var fullPath(default,null):String;
	public var name(default,null):String;
	public var parentPath(default,null):String;
	public var id(default,null):Int;
	public var isFile(default,null):Bool;
	public var isDirectory(default,null):Bool;
	public function toString():String;
	public function exists( cb:String->Bool->Void ):Void;
	public function stat( cb:String->FileSystemStats->Void ):Void;
	public function rename( newName:String, cb:String->Void ):Void;
	public function unlink( cb:String->Void ):Void;
	public function moveToTrash( cb:String->Void ):Void;
	public function visit( cb:FileSystemEntry->{ maxDepth:Int, maxEntries:Int }->(String->Void)->Void ):Void;

	private static function __init__():Void untyped {
		var adobebrackets = adobebrackets || {};
		adobebrackets.filesystem = adobebrackets.filesystem || {};
		adobebrackets.filesystem.FileSystemEntry = brackets.getModule("filesystem/FileSystemEntry");
	}
}
