package adobebrackets.editor;

import adobebrackets.document.Document;
import adobebrackets.language.Language;
import jQuery.haxe.Either;
import jQuery.JQuery;
import jQuery.Promise;
import js.html.DivElement;

extern class Editor {

	function new( doc:Document, makeMasterEditor:Bool, container:JQuery, ?range:{ startLine:Int, endLine:Int } );
	public function selectAllNoScroll():Void;
	public function isTextSubset():Bool;
	public function getCursorPos( ?expandTabs:Bool, ?which:String ):Pos;
	public function getColOffset( pos:Pos ):Int;
	public function getCharIndexForColumn( lineNum:Int, column:Int ):Int;
	public function setCursorPos( line:Int, ch:Int, center:Bool, expandTabs:Bool ):Void;
	public function setSize( width:Int, height:Int ):Void;
	public function centerOnCursor( centerOptions:Int ):Void;
	public function indexFromPos( coords:{line:Int, ch:Int} ):Int;
	public function posWithinRange( pos:Pos, start:Pos, end:Pos ):Bool;
	public function hasSelection():Bool;
	public function getSelection():{ start:Pos, end:Pos, reversed:Bool };
	public function getSelections():Array<{ start:Pos, end:Pos, reversed:Bool, primary:Bool }>;
	public function convertToLineSelections( selections:Dynamic, options:Dynamic ):Array<Dynamic>; // TODO: type this properly (I used dynamic for now...)
	public function getSelectedText( allSelections:Bool ):String;
	public function setSelection( start:Pos, ?end:Pos, ?center:Bool, ?centerOptions:Int, ?origin:String ):Void;
	public function setSelections( selections:Array<{start:Pos, ?end:Pos}>, ?center:Bool, ?centerOptions:Int, ?origin:String ):Void;
	public function toggleOverwrite( ?state:Bool ):Void;
	public function selectWordAt( pos:Pos ):Void;
	public function lineCount():Int;
	public function isLineVisible( line:Int ):Bool;
	public function getFirstVisibleLine():Int;
	public function getLastVisibleLine():Int;
	public function totalHeight():Int;
	public function getScrollerElement():DivElement;
	public function getRootElement():DivElement;
	public function getLineSpaceElement():DivElement;
	public function getScrollPos():{ x:Int, y:Int };
	public function setScrollPos( x:Int, y:Int ):Void;
	public function getTextHeight():Int;
	public function addInlineWidget( pos:Pos, inlineWidget:InlineWidget, ?scrollLineIntoView:Bool ):Promise;
	public function removeAllInlineWidgets():Promise;
	public function removeInlineWidget( num:Int ):Promise;
	public function removeAllInlineWidgetsForLine( line:Int ):Promise;
	public function getInlineWidgets():Array<{ id:Int, data:{} }>;
	public function displayErrorMessageAtCursor( errorMsg:String ):Void;
	public function getVirtualScrollAreaTop():Int;
	public function setInlineWidgetHeight( inlineWidget:InlineWidget, height:Int, ?ensureVisible:Bool ):Void;
	public function focus():Void;
	public function refresh( ?handleResize:Bool ):Void;
	public function refreshAll( ?handleResize:Bool ):Void;
	public function undo():Void;
	public function redo():Void;
	public function setVisible( ?show:Bool, ?refresh:Bool ):Void;
	public function isFullyVisible():Bool;
	public function getModeForRange( start:Pos, end:Pos ):Either<String,{ name:String }>;
	public function getModeForSelection():Either<String,{ name:String }>;
	public function getLanguageForSelection():Language;
	public function getModeForDocument():Either<String,{ name:String }>;

	public var document:Document;

	public static function setUseTabChar( value:Bool, ?fullPath:String ):Bool;
	public static function getUseTabChar( ?fullPath:String ):Bool;
	public static function setTabSize( value:Int, ?fullPath:String ):Bool;
	public static function getTabSize( ?fullPath:String ):Int;
	public static function getSpaceUnits( ?fullPath:String ):Int;
	public static function setCloseBrackets( value:Bool, ?fullPath:String ):Bool;
	public static function getCloseBrackets( ?fullPath:String ):Bool;
	public static function setShowLineNumbers( value:Bool, ?fullPath:String ):Bool;
	public static function getShowLineNumbers( ?fullPath:String ):Bool;
	public static function setShowActiveLine( value:Bool, ?fullPath:String ):Bool;
	public static function getShowActiveLine( ?fullPath:String ):Bool;
	public static function setWordWrap( value:Bool, ?fullPath:String ):Bool;
	public static function getWordWrap( ?fullPath:String ):Bool;

	private static function __init__():Void untyped {
		var adobebrackets = adobebrackets || {};
		adobebrackets.editor = adobebrackets.editor || {};
		adobebrackets.editor.Editor = brackets.getModule("editor/Editor");
	}
}
