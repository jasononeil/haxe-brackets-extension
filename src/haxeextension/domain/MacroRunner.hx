package haxeextension.domain;

import haxeextension.model.Typedefs;
import sys.io.File;
import nodejs.Tmp;
using haxe.io.Path;

class MacroRunner {

	/**
		Run something like:

		```
		haxe {build} --macro haxeextension.compilemacros.ListTypesAndFields.listTypes()
		haxe {build} --macro haxeextension.compilemacros.ListTypesAndFields.listFieldsForModule( "/usr/lib/haxe/std/List.hx" )
		```

		to get a list of all types in the current build, including their name and position, so we can have a "go to type declaration" feature.

		This requires your project to be in a compilable state.

		@param req The details of the current build, working directory, cursor position etc.
		@param completeFn A callback for once the process is complete: `function (error:String,result:ProcessResult):Void {}`
	**/
	public static function getAllTypesInBuild( req:CompletionRequest, completeFn:String->ProcessResult->Void ) {

		Tmp.dir( {unsafeCleanup: true}, function (err, dirPath) {
			if ( err!=null )
				throw err;

			var completionArgs = [];

			// Save the local changes to this file
			var filename = req.currentFile.withoutDirectory();
			var pathRelativeToClassPath = filename; // TODO: support finding it relative to class paths.
			var tmpFile = dirPath.addTrailingSlash() + pathRelativeToClassPath;
			File.saveContent( tmpFile, req.currentContent );

			// Use our temp directory as a classpath, so we can save the local changes there, and the compiler can use that instead of the real (and old) version of the file.
			// Saving the changes to the file and reverting them does not work because brackets detects the file change and asks annoying questions.
			completionArgs.push( "-cp" );
			completionArgs.push( dirPath );
			for ( a in req.args )
				completionArgs.push( a );

			// Add the display arguments for the Haxe compiler
			completionArgs.push( '--display' );
			completionArgs.push( '$tmpFile@${req.pos}' );

			// A completeFn that deletes the temp directory, because otherwise we'll have thousands laying around if Brackets has been running for a while.
			function customCompleteFn( err:String, result:ProcessResult ):Void {
				FsUtil.rmdir( dirPath );
				completeFn( err, result );
			}

			// A custom callback function to restore the file once the compiler completion has run.
			HaxeRunner.runHaxe( req.cwd, completionArgs, customCompleteFn );
		});
	}

	public static function getAllFieldsInModule( req:CompletionRequest, completeFn:String->ProcessResult->Void ) {
		throw "not ready";
	}

}
