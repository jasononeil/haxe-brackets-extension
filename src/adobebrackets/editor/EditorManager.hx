package adobebrackets.editor;

import adobebrackets.document.Document.Pos;
import adobebrackets.editor.Editor;
import adobebrackets.editor.InlineWidget;
import jQuery.haxe.Either;
import jQuery.JQuery;
import js.html.DivElement;
import js.html.Element;

extern class EditorManager {
	public static function closeInlineWidget( hostEditor:Editor, inlineWidget:InlineWidget ):Promise;
	public static function registerInlineEditProvider( provider:Editor->Pos->Either<Promise,String>, priority:Int ):Void;
	public static function registerInlineDocsProvider( provider:Editor->Pos->Either<Promise,String>, priority:Int ):Void;
	public static function registerJumpToDefProvider( provider:Editor->Pos->Null<Promise> ):Void;
	public static function getInlineEditors( hostEditor:Editor ):Array<Editor>;
	public static function getCurrentFullEditor():Editor;
	public static function createInlineEditorForDocument( doc:Document, ?range:{ startLine:Int, endLine:Int }, inlineContent:DivElement ):{ content:Element, editor:Editor };
	public static function focusEditor():Void;
	public static function resizeEditor():Void;
	public static function getCurrentlyViewedPath():String;
	public static function showingCustomViewerForPath( fullPath:String ):Bool;
	public static function registerCustomViewer( langID:Int, provider:CustomViewProvider ):Void;
	public static function getCustomViewerForPath( fullPath:String ):Null<CustomViewProvider>;
	public static function notifyPathDeleted( fullPath:String ):Void;
	public static function setEditorHolder( holder:JQuery ):Void;
	public static function getFocusedInlineWidget():Null<InlineWidget>;
	public static function getFocusedEditor():Null<Editor>;
	public static function getActiveEditor():Null<Editor>;
}

typedef CustomViewProvider = {
	function render( fullPath:String, editorHolder:JQuery );
	function onRemove();
}
