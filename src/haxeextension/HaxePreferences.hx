package haxeextension;

import adobebrackets.preferences.PreferencesBase;
import adobebrackets.preferences.PreferencesManager;
import haxe.ds.Option;
import jQuery.Promise;

class HaxePreferences {

	/**
		Globally whether to allow the use of the compilation server.

		If set to false, it will never work.
		If set to true, it will be used if the individual build setting has it enabled, or if no build setting is found (default).
		If the build setting explicitly disables the cache, it will not be used even if this is true.
	**/
	public static var useCompilationServer(get,set):Bool;
	static function get_useCompilationServer() { return get("use-compilation-server"); }
	static function set_useCompilationServer(v) { set("use-compilation-server",v); return v; }

	/**
	**/
	public static function getBuildFiles( filePath:String ):Option<Array<String>> {
		return throw "not implemented";
	}

	/**
	**/
	public static function setBuildFiles( filePath:String, ?array:Array<String> ):Promise {
		var val = (array!=null) ? Some(array) : None;
		// set( "build-file-selection" )
		return throw "not implemented";
	}

	/**
		@param filePath The absolute path to the file we are checking.
		@return An option, containing the absolute path to the display file if it was set.
	**/
	public static function getDisplayFile( filePath:String ):Option<String> {
		var displayFiles = get( "display-file-selection" );
		var val = Reflect.field( displayFiles, filePath );
		return val!=null ? Some( val ) : None;
	}

	/**
		@param filePath The absolute path to the file we are setting.
		@param displayFile The absolute path to the hxml file to use for code hints.  (Leave null/empty if you wish to remove the setting).
		@return A promise for when the setting has been saved.
	**/
	public static function setDisplayFile( filePath:String, ?displayFile:String ):Promise {
		var displayFiles = get( "display-file-selection" );

		if ( displayFile!=null )
			Reflect.setField( displayFiles, filePath, displayFile )
		else
			Reflect.deleteField( displayFile, filePath );

		return set( "display-file-selection", displayFiles );
	}

	/**
	**/
	public static function getBuildOptions( filePath:String ):Option<BuildOptions> {
		return throw "not implemented";
	}

	static var inst(get,null):PrefixedPreferencesSystem;

	static function get_inst() {
		if ( inst==null ) {
			inst = PreferencesManager.getExtensionPrefs( "haxe" );
			setupDefaults( inst );
		}
		return inst;
	}

	static inline function get( id:String ) {
		return inst.get( id );
	}

	static inline function set( id:String, value:Dynamic ) {
		inst.set( id, value );
		return inst.save();
	}

	static inline function definePreference( id:String, type:String, ?initial:Dynamic ):Preference {
		return inst.definePreference( id, type, initial );
	}

	static function setupDefaults( inst:PrefixedPreferencesSystem ) {
		definePreference( "use-compilation-server", "boolean", true );
		definePreference( "build-file-selection", "object", {} );
		definePreference( "display-file-selection", "object", {} );
		definePreference( "build-options", "object", {} );
	}
}

/** Example: `{ "MyFile.hx": ["test.hxml","myfile.hxml"] }` **/
typedef BuildFileSelectionsPref = Dynamic<Array<String>>;

/** Example: `{ "MyFile.hx": "test.hxml" }` **/
typedef DisplayFileSelectionPref = Dynamic<String>;

/** Example: `{ "test.hxml": { runCommand: "http://localhost/", runType: InBrowser } }` **/
typedef BuildOptionsPref = Dynamic<BuildOptions>;

typedef BuildOptions = {
	@:optional var extraArgs:String;
	@:optional var run:String;
	@:optional var runType:BuildRunType;
	@:optional var useCompilationServer:Bool;
	@:optional var buildOnSave:Bool;
};

@:enum abstract BuildRunType( String ) {
	var Execute = "execute";
	var InBrowser = "in-browser";
	var InTerminal = "in-terminal";
}
