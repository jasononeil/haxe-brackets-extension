package adobebrackets.command;

import jQuery.Promise;
import jQuery.haxe.Either;

extern class CommandManager {
	public static function get( id:String ):Null<Command>;
	public static function getAll():Array<String>;

	@:overload( function( name:String, id:String, commandFn:Dynamic->Dynamic->Dynamic->Dynamic->Dynamic->Dynamic->Either<Promise,Dynamic> ):Command {} )
	@:overload( function( name:String, id:String, commandFn:Dynamic->Dynamic->Dynamic->Dynamic->Dynamic->Either<Promise,Dynamic> ):Command {} )
	@:overload( function( name:String, id:String, commandFn:Dynamic->Dynamic->Dynamic->Dynamic->Either<Promise,Dynamic> ):Command {} )
	@:overload( function( name:String, id:String, commandFn:Dynamic->Dynamic->Dynamic->Either<Promise,Dynamic> ):Command {} )
	@:overload( function( name:String, id:String, commandFn:Dynamic->Dynamic->Either<Promise,Dynamic> ):Command {} )
	@:overload( function( name:String, id:String, commandFn:Dynamic->Either<Promise,Dynamic> ):Command {} )
	public static function register( name:String, id:String, commandFn:Void->Either<Promise,Dynamic> ):Null<Command>;

	@:overload( function( id:String, commandFn:Dynamic->Dynamic->Dynamic->Dynamic->Dynamic->Dynamic->Either<Promise,Dynamic> ):Command {} )
	@:overload( function( id:String, commandFn:Dynamic->Dynamic->Dynamic->Dynamic->Dynamic->Either<Promise,Dynamic> ):Command {} )
	@:overload( function( id:String, commandFn:Dynamic->Dynamic->Dynamic->Dynamic->Either<Promise,Dynamic> ):Command {} )
	@:overload( function( id:String, commandFn:Dynamic->Dynamic->Dynamic->Either<Promise,Dynamic> ):Command {} )
	@:overload( function( id:String, commandFn:Dynamic->Dynamic->Either<Promise,Dynamic> ):Command {} )
	@:overload( function( id:String, commandFn:Dynamic->Either<Promise,Dynamic> ):Command {} )
	public static function registerInternal( id:String, commandFn:Void->Either<Promise,Dynamic> ):Null<Command>;

	@:overload( function(id:String, arg1:Dynamic, arg2:Dynamic, arg3:Dynamic, arg4:Dynamic, arg5:Dynamic, arg6:Dynamic):Promise {} )
	@:overload( function(id:String, arg1:Dynamic, arg2:Dynamic, arg3:Dynamic, arg4:Dynamic, arg5:Dynamic):Promise {} )
	@:overload( function(id:String, arg1:Dynamic, arg2:Dynamic, arg3:Dynamic, arg4:Dynamic):Promise {} )
	@:overload( function(id:String, arg1:Dynamic, arg2:Dynamic, arg3:Dynamic):Promise {} )
	@:overload( function(id:String, arg1:Dynamic, arg2:Dynamic):Promise {} )
	@:overload( function(id:String, arg1:Dynamic):Promise {} )
	public static function execute( id:String ):Promise;

	private static function __init__():Void untyped {
		var adobebrackets = adobebrackets || {};
		adobebrackets.command = adobebrackets.command || {};
		adobebrackets.command.CommandManager = brackets.getModule("command/CommandManager");
	}
}
