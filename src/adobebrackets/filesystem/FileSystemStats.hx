package adobebrackets.filesystem;

extern class FileSystemStats {

	public function new( options:StatOptions );

	public var isFile(default,null):Bool;
	public var isDirectory(default,null):Bool;
	public var mtime(default,null):Date;
	public var size(default,null):Int;
	public var realPath(default,null):String;

	private static function __init__():Void untyped {
		var adobebrackets = adobebrackets || {};
		adobebrackets.filesystem = adobebrackets.filesystem || {};
		adobebrackets.filesystem.FileSystemStats = brackets.getModule("filesystem/FileSystemStats");
	}
}

typedef StatOptions = {
	var isFile:Bool;
	var mtime:Date;
	var size:Int;
	@:optional var realPath:String;
	@:optional var hash:{};
}
