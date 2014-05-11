package adobebrackets.widgets;

import jQuery.haxe.Either;
import jQuery.JQuery;
import jQuery.Promise;

extern class Dialogs {
	public static inline var zIndex = 1050;
	public static function setDialogMaxSize():Void;
	public static function showModalDialogUsingTemplate( template:Either<String,JQuery>, ?autoDismiss:Bool ):Dialog;
	public static function showModalDialog( dlgClass:DefaultDialog, ?title:String, ?message:String, ?buttons:Array<{ className:DialogButtonClass, id:String, text:String }>, ?autoDismiss:Bool ):Dialog;
	public static function cancelModalDialogIfOpen( dlgClass:DefaultDialog, ?buttonId:DialogButtonID ):Void;

	private static function __init__():Void untyped {
		var adobebrackets = adobebrackets || {};
		adobebrackets.widgets = adobebrackets.widgets || {};
		adobebrackets.widgets.Dialogs = brackets.getModule("widgets/Dialogs");
	}
}

extern class Dialog {
	public function getElement():JQuery;
	public function getPromise():Promise;
	public function close():Void;
	public function done( cb:DialogButtonID->Void ):Void;
}

@:enum abstract DialogButtonID( String ) {
	var DIALOG_BTN_CANCEL = "cancel";
	var DIALOG_BTN_OK = "ok";
	var DIALOG_BTN_DONTSAVE = "dontsave";
	var DIALOG_BTN_SAVE_AS = "save_as";
	var DIALOG_CANCELED = "_canceled";
	var DIALOG_BTN_DOWNLOAD = "download";
}

@:enum abstract DialogButtonClass( String ) {
	var DIALOG_BTN_CLASS_PRIMARY = "primary";
	var DIALOG_BTN_CLASS_NORMAL = "";
	var DIALOG_BTN_CLASS_LEFT = "left";
}
