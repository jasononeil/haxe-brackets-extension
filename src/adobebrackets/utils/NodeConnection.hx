package adobebrackets.utils;

import jQuery.Promise;

extern class NodeConnection {

	public var domains:Dynamic<NodeDomain>;

	public function new();
	public function connect( autoReconnect:Bool ):Promise;
	public function connected():Bool;
	public function disconnect():Void;
	public function loadDomains( domains:Array<String>, autoReconnect:Bool ):Promise;

	private static function __init__():Void untyped {
		var adobebrackets = adobebrackets || {};
		adobebrackets.utils = adobebrackets.utils || {};
		adobebrackets.utils.NodeConnection = brackets.getModule("utils/NodeConnection");
	}
}
