package haxeextension.domain;

import haxeextension.model.Typedefs;
import js.Node;

/**
	The Haxe commands to run from the NodeDomain.

	This class exposes the various commands, and each of them is then executed asynchronously, even if the command itself is synchronous.
**/
@:keep
class HaxeDomain {

	/**
		Only leaving this in here as an example of a "sync" method.

		I don't know that I have need to measure total memory usage at this time...
	**/
	static function cmdGetMemory( total:Bool ) {
		return
			if ( total ) Node.os.totalmem()
			else Node.os.freemem();
	}

	/**
		The `init()` method that is exposed to the editor, allowing this domain to register it's various commands with the DomainManager.

		@param domainManager - to be supplied by the editor when it loads this domain.  Sorry I don't have type info for this at this point in time.
	**/
	@:expose("init")
	static function init( domainManager:Dynamic ) {
		if (!domainManager.hasDomain("haxe")) {
			domainManager.registerDomain("haxe", {major: 0, minor: 1});
			domainManager.registerCommand(
				"haxe", // domain name
				"getMemory", // command name
				cmdGetMemory, // command handler function
				false // this command is synchronous in Node
			);
			domainManager.registerCommand(
				"haxe", // domain name
				"getCompletionHint", // command name
				CompletionRunner.getCompletionHint, // command handler function
				true // this command is asynchronous in Node
			);
			domainManager.registerCommand(
				"haxe", // domain name
				"getAllTypesInBuild", // command name
				MacroRunner.getAllTypesInBuild, // command handler function
				true // this command is asynchronous in Node
			);
			domainManager.registerCommand(
				"haxe", // domain name
				"getAllFieldsInModule", // command name
				MacroRunner.getAllFieldsInModule, // command handler function
				true // this command is asynchronous in Node
			);
		}
	}
}
