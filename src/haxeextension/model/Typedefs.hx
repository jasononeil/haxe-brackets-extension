package haxeextension.model;

/** A typedef representation of `haxe.macro.Position`. **/
typedef PosDetails = { file:String, min:Int, max:Int };

/** The fully qualified name and position of a type. **/
typedef TypeDetails = { name:String, pos:PosDetails };

/** The name of a field, it's position, type name, documentation and name of the type this field belongs to. **/
typedef FieldDetails = { name:String, pos:PosDetails, fieldTypeName:String, doc:Null<String>, parentTypeName:String };

/**
	An object giving data about the result of a process - it's final stdout, stderr and exitCode values.

	Useful for transferring this data between the NodeContext and the main extension.
**/
typedef ProcessResult = {
	var stderr:Null<String>;
	var stdout:Null<String>;
	var exitCode:Int;
}

/**
	A request for code-hint / completion to send to the compiler.
**/
typedef CompletionRequest = {
	var cwd:String;
	var args:Array<String>;
	var currentFile:String;
	var currentContent:String;
	var pos:Int;
}
