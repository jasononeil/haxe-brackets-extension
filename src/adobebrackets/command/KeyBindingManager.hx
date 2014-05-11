package adobebrackets.command;

import adobebrackets.command.Command;
import js.html.KeyboardEvent;
import jQuery.haxe.Either;

extern class KeyBindingManager {
	public static function getKeyMap():Dynamic<{ commandID:String, key:String, displayKey:String }>;
	public static function setEnabled( val:String ):Bool;
	public static function addBinding( cmd:Either<String,Command>, ?keyBindings:Either<KeyBinding,Array<PlatformKeyBinding>>, ?platform:KeyBindingPlatform ):Either<KeyBinding,Array<KeyBinding>>;
	public static function removeBinding( key:String, ?platform:KeyBindingPlatform ):Void;
	public static function formatKeyDescriptor( key:String ):String;
	public static function getKeyBindings( cmd:Either<String,Command> ):Array<KeyBinding>;
	public static function addGlobalKeydownHook( hook:KeyboardEvent->Bool ):Void;
	public static function removeGlobalKeydownHook( hook:KeyboardEvent->Bool ):Void;
	public static var useWindowsCompatibleBindings:Bool;

	private static function __init__():Void untyped {
		var adobebrackets = adobebrackets || {};
		adobebrackets.command = adobebrackets.command || {};
		adobebrackets.command.KeyBindingManager = brackets.getModule("command/KeyBindingManager");
	}
}

typedef KeyBinding = {
	var key:String;
	@:optional var displayKey:String;
}

typedef PlatformKeyBinding = {
	> KeyBinding,
	@:optional var platform:KeyBindingPlatform;
}

@:enum abstract KeyBindingPlatform( Null<String> ) {
	var Win = "win";
	var Mac = "mac";
	var Linux = "linux";
	var All = null;
}
