package adobebrackets.filesystem;

import adobebrackets.filesystem.FileSystem;
import adobebrackets.filesystem.FileSystemStats;

extern class Directory extends FileSystemEntry {

	public function new( fullPath:String, fileSystem:FileSystem );
	public function getContents( cb:String->Array<FileSystemEntry>->Array<FileSystemStats>->Dynamic<String> ):Void;
	public function create( cb:String->FileSystemStats->Void ):Void;

	private static function __init__():Void untyped {
		var adobebrackets = adobebrackets || {};
		adobebrackets.filesystem = adobebrackets.filesystem || {};
		adobebrackets.filesystem.Directory = brackets.getModule("filesystem/Directory");
	}
}
