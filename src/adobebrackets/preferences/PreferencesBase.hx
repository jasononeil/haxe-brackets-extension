package adobebrackets.preferences;

import jQuery.Promise;

//
// All constructors here I have exposed as private in these externs...
// They should only be accessed via the PreferencesManager class.
//

typedef Storage = {
	function load():Promise;
	function save( newData:{} ):Promise;
	function fileChanged( filePath:String ):Void;
}

extern class MemoryStorage {
	// public function new( data:{} );
	public function load():Promise;
	public function save( newData:{} ):Promise;
	public function fileChanged( filePath:String ):Void;
}

extern class FileStorage {
	// public function new( path:String, createIfNew:Bool );
	public function load():Promise;
	public function save( newData:{} ):Promise;
	public function fileChanged( filePath:String ):Void;
}

extern class Scope {
	// public function new( storage:Storage );
	public function load():Promise;
	public function save( newData:{} ):Promise;
	public function set( id:String, value:Dynamic, ?context:{}, ?location:LocationInfo ):Bool;
	public function get( id:String, ?context:{} ):Dynamic;
	public function getPreferenceLocation( id:String, ?context:{} ):Null<LocationInfo>;
	public function getKeys( ?context:{} ):Array<String>;
	public function addLayer( layer:Either<ProjectLayer,PathLayer> ):Void;
	public function fileChanged( filePath:String ):Void;
	public function defaultFilenameChanged( filename:String, oldFilename:String ):Array<String>;
}

extern class ProjectLayer {
	public var key:String;
	// public function new();
	public function get( data:{}, id:String ):Null<Dynamic>;
	public function getPreferenceLocation( data:{}, id:String ):String;
	public function set( data:{}, id:String, value:Dynamic, context:{}, ?layerID:String ):Bool;
	public function getKeys( data:{} ):Array<String>;
	public function setProjectPath( projectPath:String ):Void;
}

extern class PathLayer {
	public var key:String;
	// public function new();
	public function get( data:{}, id:String ):Null<Dynamic>;
	public function getPreferenceLocation( data:{}, id:String ):String;
	public function set( data:{}, id:String, value:Dynamic, context:{}, ?layerID:String ):Bool;
	public function getKeys( data:{} ):Array<String>;
	public function setPrefFilePath( prefFilePath:String ):Void;
	public function defaultFilenameChanged( data:{}, filename:String, oldFilename:String ):Array<String>;
}

extern class Preference {
	// public function new( properties:Dynamic );
	public function on( event:String, handler:Void->Void ):Void;
	public function off( event:String, ?handler:Void->Void ):Void;
}

extern class PrefixedPreferencesSystem {
	public var base:PreferencesSystem;
	public var prefix:String;

	// public function new( base:PreferenceSystem, prefix:String );
	public function definePreference( id:String, type:String, initial:Dynamic, ?options:{} ):Preference;
	public function getPreference( id:String ):Preference;
	public function get( id:String, ?context:{} ):Dynamic;
	public function getPreferenceLocation( id:String, ?context:{} ):LocationInfoWithScope;
	public function set( id:String, value:Dynamic, ?options:{ ?location:{}, ?context:{} }, ?doNotSave:Bool ):{ valid:Bool, stored:Bool };
	public function on( event:String, ?preferenceID:String, handler:Void->Void ):Void;
	public function off( event:String, ?preferenceID:String, handler:Void->Void ):Void;
	public function save():Promise;
}

extern class PreferencesSystem {
	// public function new( ?contextNormalizer:{}->Void );
	public function definePreference( id:String, type:String, initial:Dynamic, ?options:{} ):Preference;
	public function getPreference( id:String ):Preference;
	public function addToScopeOrder( id:String, addBefore:String ):Void;
	public function removeFromScopeOrder( id:String ):Void;
	public function addScope( id:String, scope:Either<Scope,Storage>, options:{ before:String } ):Promise;
	public function removeScope( id:String ):Void;
	public function get( id:String, ?context:Either<{},String> ):Dynamic;
	public function getPreferenceLocation( id:String, ?context:{} ):LocationInfoWithScope;
	public function set( id:String, value:Dynamic, ?options:{ ?location:{}, ?context:{} }, ?doNotSave:Bool ):{ valid:Bool, stored:Bool };
	public function save():Promise;
	public function setDefaultFilename( filename:String ):Void;
	public function buildContext( context:{} ):{};
	public function on( event:String, ?preferenceID:String, handler:Void->Void ):Void;
	public function off( event:String, ?preferenceID:String, handler:Void->Void ):Void;
	public function pauseChangeEvents():Void;
	public function resumeChangeEvents():Void;
	public function fileChanged( filePath:String ):Void;
	public function getPrefixedSystem( prefix:String ):PrefixedPreferencesSystem;
}

typedef LocationInfo = {
	@:optional var layer:String;
	@:optional var layerID:{};
};

typedef LocationInfoWithScope = {
	> LocationInfo,
	var scope:String;
};
