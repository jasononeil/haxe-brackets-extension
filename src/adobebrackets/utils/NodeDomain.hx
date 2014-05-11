package adobebrackets.utils;

import jQuery.Promise;

extern class NodeDomain {
	public var connection:NodeConnection;
	public var ready:Bool;
	public var promise:Promise;

	public function new( domainName:String, domainPath:String );

	@:overload( function( cmd:String, arg1:Dynamic, arg2:Dynamic, arg3:Dynamic, arg4:Dynamic, arg5:Dynamic ):Promise {} )
	@:overload( function( cmd:String, arg1:Dynamic, arg2:Dynamic, arg3:Dynamic, arg4:Dynamic ):Promise {} )
	@:overload( function( cmd:String, arg1:Dynamic, arg2:Dynamic, arg3:Dynamic ):Promise {} )
	@:overload( function( cmd:String, arg1:Dynamic, arg2:Dynamic ):Promise {} )
	@:overload( function( cmd:String, arg1:Dynamic ):Promise {} )
	public function exec( cmdName:String ):Promise;

	private static function __init__():Void untyped {
		var adobebrackets = adobebrackets || {};
		adobebrackets.utils = adobebrackets.utils || {};
		adobebrackets.utils.NodeDomain = brackets.getModule("utils/NodeDomain");
	}
}
