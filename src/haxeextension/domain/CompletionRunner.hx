package haxeextension.domain;

import haxeextension.model.Typedefs;
import sys.io.File;
import nodejs.Tmp;
using haxe.io.Path;

class CompletionRunner {

	/**
		Run something like `haxe {build} --display /tmp/tmp-dir/CurrentFile.hx@73` to get display hints.

		@param req The details of the current build, working directory, cursor position etc.
		@param completeFn A callback for once the process is complete: `function (error:String,result:ProcessResult):Void {}`
	**/
	public static function getCompletionHint( req:CompletionRequest, completeFn:String->ProcessResult->Void ) {

		Tmp.dir( {unsafeCleanup: true}, function (err, dirPath) {
			if ( err!=null )
				throw err;

			var completionArgs = [];

			// Save the local changes to this file
			var filename = req.currentFile.withoutDirectory();

			HaxeRunner.getClassPaths( req.cwd, req.args, function(err:String, cps:Array<String>) {
				if ( err!=null )
					completeFn( err, null );

				var tmpFile:String = null;
				try {
					var pathRelativeToClassPath = HaxeRunner.pathRelativeToClassPaths( cps, req.currentFile );
					tmpFile = dirPath + pathRelativeToClassPath;
					FsUtil.saveContentInSubDir( tmpFile, req.currentContent );
				}
				catch ( e:Dynamic ) {
					completeFn( 'Failed to save tmp file $tmpFile for completion: $e', null );
				}

				// Use our temp directory as a classpath, so we can save the local changes there, and the compiler can use that instead of the real (and old) version of the file.
				// Saving the changes to the file and reverting them does not work because brackets detects the file change and asks annoying questions.
				for ( a in req.args )
					completionArgs.push( a );
				completionArgs.push( "-cp" );
				completionArgs.push( dirPath );

				// Add the display arguments for the Haxe compiler
				completionArgs.push( '--display' );
				completionArgs.push( '$tmpFile@${req.pos}' );

				// A completeFn that deletes the temp directory, because otherwise we'll have thousands laying around if Brackets has been running for a while.
				function customCompleteFn( err:String, result:ProcessResult ):Void {
					// Attempt to remove tmp folder.  Not the end of the world if we fail.
					try {
						FsUtil.rmdir( dirPath );
						completeFn( err, result );
					}
					catch ( e:Dynamic ) {
						completeFn( 'Failed to remove tmp completion folder $dirPath: $e', null );
					}
				}

				// A custom callback function to restore the file once the compiler completion has run.
				HaxeRunner.runHaxe( req.cwd, completionArgs, customCompleteFn );
			});

		});

	}

}
