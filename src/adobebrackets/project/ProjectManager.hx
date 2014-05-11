package adobebrackets.project;

import adobebrackets.filesystem.Directory;
import adobebrackets.filesystem.File;
import adobebrackets.filesystem.FileSystemEntry;
import jQuery.haxe.Either;
import jQuery.Promise;

extern class ProjectManager {
	public static function getProjectRoot():Directory;
	public static function getBaseUrl():String;
	public static function setBaseUrl( projectBaseUrl:String ):Void;
	public static function isWithinProject( absPathOrEntry:Either<String,FileSystemEntry> ):Bool;
	public static function makeProjectRelativeIfPossible( absPath:String ):String;
	public static function shouldShow( entry:FileSystemEntry ):Bool;
	public static function isBinaryFile( fileName:String ):Bool;
	public static function openProject( ?path:String ):Promise;
	public static function getSelectedItem():Null<Either<File,Directory>>;
	public static function getInitialProjectPath():String;
	public static function isWelcomeProjectPath( path:String ):Bool;
	public static function updateWelcomeProjectPath( path:String ):String;
	public static function createNewItem( baseDir:Either<String,Directory>, initialName:String, skipRename:Bool, isFolder:Bool ):Promise;
	public static function renameItemInline( oldName:String, newName:String, isFolder:Bool ):Promise;
	public static function deleteItem( entry:Either<File,Directory> ):Promise;
	public static function forceFinishRename():Void;
	public static function showInTree( entry:Either<File,Directory> ):Promise;
	public static function refreshFileTree():Promise;
	public static function getAllFiles( ?filter:File->Bool, ?includeWorkingSet:Bool ):Promise;
	public static function getLanguageFilter( languageId:String ):File->Bool;

	private static function __init__():Void untyped {
		var adobebrackets = adobebrackets || {};
		adobebrackets.project = adobebrackets.project || {};
		adobebrackets.project.ProjectManager = brackets.getModule("project/ProjectManager");
	}
}
