package adobebrackets.command;

import jQuery.Promise;
import jQuery.haxe.Either;

extern class Command {
	@:overload( function(name:String, id:String, commandFn:Dynamic->Dynamic->Dynamic->Dynamic->Dynamic->Dynamic->Either<Promise,Dynamic>):Void {} )
	@:overload( function(name:String, id:String, commandFn:Dynamic->Dynamic->Dynamic->Dynamic->Dynamic->Either<Promise,Dynamic>):Void {} )
	@:overload( function(name:String, id:String, commandFn:Dynamic->Dynamic->Dynamic->Dynamic->Either<Promise,Dynamic>):Void {} )
	@:overload( function(name:String, id:String, commandFn:Dynamic->Dynamic->Dynamic->Either<Promise,Dynamic>):Void {} )
	@:overload( function(name:String, id:String, commandFn:Dynamic->Dynamic->Either<Promise,Dynamic>):Void {} )
	@:overload( function(name:String, id:String, commandFn:Dynamic->Either<Promise,Dynamic>):Void {} )
	public function new( name:String, id:String, commandFn:Void->Either<Promise,Dynamic> ):Void;

	@:overload( function(arg1:Dynamic, arg2:Dynamic, arg3:Dynamic, arg4:Dynamic, arg5:Dynamic, arg6:Dynamic):Promise {} )
	@:overload( function(arg1:Dynamic, arg2:Dynamic, arg3:Dynamic, arg4:Dynamic, arg5:Dynamic):Promise {} )
	@:overload( function(arg1:Dynamic, arg2:Dynamic, arg3:Dynamic, arg4:Dynamic):Promise {} )
	@:overload( function(arg1:Dynamic, arg2:Dynamic, arg3:Dynamic):Promise {} )
	@:overload( function(arg1:Dynamic, arg2:Dynamic):Promise {} )
	@:overload( function(arg1:Dynamic):Promise {} )
	public function execute():Promise;

	public function getID():String;
	public function getEnabled():Bool;
	public function setEnabled(enabled:Bool):Void;
	public function getChecked():Bool;
	public function setChecked(checked:Bool):Void;
	public function getName():String;
	public function setName(name:String):Void;
}
