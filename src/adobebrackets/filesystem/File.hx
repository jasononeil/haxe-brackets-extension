package adobebrackets.filesystem;

import adobebrackets.filesystem.FileSystem;

extern class File extends FileSystemEntry {

	public function new( fullPath:String, fileSystem:FileSystem );
	public function read( options:{}, cb:?String->String->FileSystemStats ):Void;
	public function write( data:String, options:{}, cb:String->FileSystemStats->Void ):Void;
	override public function exists( cb:String->Bool->Void ):Void;
	override public function stat( cb:String->FileSystemStats->Void ):Void;
	override public function unlink( cb:String->Void ):Void;
	override public function rename( newName:String, cb:String->Void ):Void;
	override public function moveToTrash( cb:String->Void ):Void;

	private static function __init__():Void untyped {
		var adobebrackets = adobebrackets || {};
		adobebrackets.filesystem = adobebrackets.filesystem || {};
		adobebrackets.filesystem.File = brackets.getModule("filesystem/File");
	}
}
