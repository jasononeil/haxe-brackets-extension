package adobebrackets.language;

import adobebrackets.filesystem.File;
import jQuery.Promise;

extern class Language {

	public function new();

	public function getId():String;
	public function getName():String;
	public function getMode():String;
	public function getFileExtensions():Array<String>;
	public function getFileNames():Array<String>;
	public function addFileExtension( ext:String ):Void;
	public function removeFileExtension( ext:String ):Void;
	public function addFileName( name:String ):Void;
	public function removeFileName( name:String ):Void;
	public function hasLineCommentSyntax():Bool;
	public function getLineCommentPrefixes():Array<String>;
	public function setLineCommentSyntax( prefix:String ):Bool;
	public function hasBlockCommentSyntax():Bool;
	public function getBlockCommentSyntax():String;
	public function setBlockCommentSyntax( prefix:String, suffix:String ):Bool;
	public function getLanguageForMode( mode:String ):Language;
	public function isFallbackLanguage():Bool;
	public function isBinary():Bool;
}
