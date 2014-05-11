package adobebrackets.document;

import jQuery.Promise;
import adobebrackets.filesystem.File;

extern class DocumentManager {
	public static function getCurrentDocument():Document;
	public static function getWorkingSet():Array<File>;
	public static function findInWorkingSet( fullPath:String, list:Array<File> ):Int;
	public static function findInWorkingSetAddedOrder( fullPath:String ):Int;
	public static function getAllOpenDocuments():Array<Document>;
	public static function addToWorkingSet( file:File, ?index:Int, ?forceRedraw:Bool ):Void;
	public static function addListToWorkingSet( fileList:Array<File> ):Void;
	public static function removeFromWorkingSet( file:File, suppressRedraw:Bool ):Void;
	public static function swapWorkingSetIndexes( index1:Int, index2:Int ):Void;
	public static function sortWorkingSet( compareFn:File->File->Int ):Void;
	public static function beginDocumentNavigation():Void;
	public static function finalizeDocumentNavigation():Void;
	public static function getNextPrevFile( prevOrNext:Int ):Void;
	public static function setCurrentDocument( doc:Document ):Void;
	public static function closeFullEditor( file:File, ?skipAutoSelect:Bool ):Void;
	public static function closeAll():Void;
	public static function removeListFromWorkingSet( list:Array<File>, clearCurrentDocument:Bool ):Void;
	public static function getOpenDocumentForPath( fullPath:String ):Null<Document>;
	public static function getDocumentForPath( fullPath:String ):Promise;
	public static function getDocumentText( file:File ):String;
	public static function createUntitledDocument( counter:Int, fileExt:String ):Document;
	public static function notifyFileDeleted( file:File, ?skipAutoSelect:Bool ):Void;
	public static function notifyPathNameChanged( oldName:String, newName:String, isFolder:Bool ):Void;
	public static function notifyPathDeleted( path:String ):Void;

	private static function __init__():Void untyped {
		var adobebrackets = adobebrackets || {};
		adobebrackets.document = adobebrackets.document || {};
		adobebrackets.document.DocumentManager = brackets.getModule("document/DocumentManager");
	}
}
