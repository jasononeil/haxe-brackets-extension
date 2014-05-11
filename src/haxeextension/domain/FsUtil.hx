package haxeextension.domain;

import sys.FileSystem;
import sys.io.File;
using haxe.io.Path;

class FsUtil {

	/**
		Recursively remove a directory and all of it's contents.

		This operates synchronously, so please only use it within a NodeDomain where it runs in a separate thread.

		@param The absolute path of the directory to remove.
		@throws File system errors.
	**/
	public static function rmdir( dirPath:String ) {
		if ( FileSystem.exists(dirPath) ) {
			for ( file in FileSystem.readDirectory(dirPath) ) {
				var filePath = dirPath.addTrailingSlash()+file;
				if ( FileSystem.isDirectory(filePath) )
					rmdir( filePath );
				else
					FileSystem.deleteFile( filePath );
			}
			FileSystem.deleteDirectory( dirPath );
		}
	}

	/**
		Create a directory at the given path, recursively creating directories as required.

		This operates synchronously, so please only use it within a NodeDomain where it runs in a separate thread.

		@param The absolute path of the directory to create.
		@throws File system errors.
	**/
	public static function mkdir( dirPath:String ) {
		if ( !FileSystem.exists(dirPath) ) {
			var parentDir = dirPath.removeTrailingSlashes().directory();
			mkdir( parentDir );
			FileSystem.createDirectory( dirPath );
		}
	}

	/**
		Similar to `sys.io.File.saveContent`, except this will create any subdirectories required.

		@param filename The absolute path of the file we are trying to save.
		@param content The content to save to the file.
		@throws File system errors.
	**/
	public static function saveContentInSubDir( filename:String, content:String ) {
		var dir = filename.directory();
		mkdir( dir );
		File.saveContent( filename, content );
	}
}
