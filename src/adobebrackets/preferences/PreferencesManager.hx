package adobebrackets.preferences;

import jQuery.haxe.Either;
import jQuery.Promise;
import adobebrackets.preferences.PreferencesBase;

extern class PreferencesManager {
	public static var CURRENT_FILE:{};
	public static var CURRENT_PROJECT:{};
	public static var SETTINGS_FILENAME:String;

	public static var FileStorage:Class<FileStorage>;

	public static var stateManager:PreferencesSystem;
	public static var ready:Promise;

	public static function getUserPrefFile():String;
	public static function get( id:String, ?context:Either<{},String> ):Dynamic;
	public static function set( id:String, value:Dynamic, ?options:{ ?location:{}, ?context:{} }, ?doNotSave:Bool ):{ valid:Bool, stored:Bool };
	public static function save():Promise;
	public static function on( eventName:String, ?preferenceID:String, handler:Void->Void ):Void;
	public static function off( eventName:String, ?preferenceID:String, handler:Void->Void ):Void;
	public static function getPreference( id:String ):Preference;
	public static function getExtensionPrefs( prefix:String ):PrefixedPreferencesSystem;
	public static function setValueAndSave( id:String, value:Dynamic, ?options:{ ?location:{}, ?context:Either<{},String> } ):Bool;
	public static function getViewState( id:String, ?context:{} ):Dynamic;
	public static function setViewState( id:String, value:Dynamic, ?options:{ ?location:{}, ?context:{} }, ?doNotSave:Bool ):Void;
	public static function addScope( id:String, scope:Either<Scope,Storage>, options:{ before:String } ):Promise;
	public static function definePreference( id:String, dataType:String, initial:Dynamic, ?options:{} ):{};
	public static function fileChanged( filePath:String ):Void;
	public static function convertPreferences( clientID:Either<String,{}>, rules:{}, ?isViewState:Bool, ?prefCheckCallback:String->Void ):Void;

	private static function __init__():Void untyped {
		var adobebrackets = adobebrackets || {};
		adobebrackets.preferences = adobebrackets.preferences || {};
		adobebrackets.preferences.PreferencesManager = brackets.getModule("preferences/PreferencesManager");
	}
}
