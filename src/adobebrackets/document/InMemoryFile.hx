package adobebrackets.document;

import adobebrackets.filesystem.File;
import adobebrackets.filesystem.FileSystem;

extern class DocumentManager extends File {

	public function new( fullPath:String, fileSystem:FileSystem );
	public function read( options:{}, cb:?String->String->FileSystemStats ):Void;
	public function write( data:String, options:{}, cb:String->FileSystemStats->Void ):Void;
	public function exists( cb:String->Bool->Void );
	public function stat( cb:String->FileSystemStats->Void );
	public function unlink( cb:String->Void );
	public function rename( newName:String, cb:String->Void );
	public function moveToTrash( cb:String->Void );

	private static function __init__():Void untyped {
		var adobebrackets = adobebrackets || {};
		adobebrackets.document = adobebrackets.document || {};
		adobebrackets.document.InMemoryFile = brackets.getModule("document/InMemoryFile");
	}
}
