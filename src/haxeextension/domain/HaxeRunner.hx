package haxeextension.domain;

import haxeextension.model.Typedefs;
import js.Node;
import js.Node.NodeChildProcess;
import sys.io.File;
import sys.FileSystem;
using StringTools;
using haxe.io.Path;

/**
	Run the Haxe process with the specified arguments, and return the output (which includes stderr, stdout and the exitCode).

	Requests from `CompletionRunner` and `MacroRunner` can also be forwarded to this method.
**/
class HaxeRunner {

	/**
		@param cwd The absolute path to the working directory the Haxe process should be started in.
		@param args An array of arguments to supply to the Haxe compiler.
		@param completeFn A callback for once the process is complete: `function (error:String,result:ProcessResult):Void {}`
	**/
	public static function runHaxe( cwd:String, args:Array<String>, completeFn:String->ProcessResult->Void ) {
		run( cwd, "haxe", args, function(err,result) {
			if ( err!=null )
				completeFn( err,result );

			if ( result.stderr.indexOf("Couldn't connect on 127.0.0.1:6000")>-1 ) {
				startCompilationServer( 6000, function (err:String) {
					if ( err!=null ) {
						completeFn( err, null );
						return;
					}

					// Try running it again now that the server is up.
					runHaxe( cwd, args, completeFn );
				});
			}
			else {
				completeFn( err, result );
			}
		});
	}

	/**
		@param cwd The absolute path to the working directory the Haxelib process should be started in.
		@param args An array of arguments to supply to Haxelib.
		@param completeFn A callback for once the process is complete: `function (error:String,result:ProcessResult):Void {}`
	**/
	public static function runHaxelib( cwd:String, args:Array<String>, completeFn:String->ProcessResult->Void ) {
		run( cwd, "haxelib", args, completeFn );
	}

	/**
		@param cwd The absolute path to the working directory the process should be started in.
		@param executable The name of the executable to run.
		@param args An array of arguments to supply to the Haxe compiler.
		@param completeFn A callback for once the process is complete: `function (error:String,result:ProcessResult):Void {}`
	**/
	public static function run( cwd:String, executable:String, args:Array<String>, completeFn:String->ProcessResult->Void ) {

		var processData:ProcessResult = {
			exitCode: -1,
			stdout: null,
			stderr: null
		};

		var childProcess = Node.child_process.spawn( executable, args, { cwd: cwd } );

		childProcess.on( "error", function( err:Dynamic ) {
			completeFn( 'Error on child process: $err', null );
		});
		childProcess.stdout.on('data', function (data) {
			if ( processData.stdout==null )
				processData.stdout = "";
			processData.stdout += data;
		});
		childProcess.stderr.on('data', function (data) {
			if ( processData.stderr==null )
				processData.stderr = "";
			processData.stderr += data;
		});
		childProcess.on( "close", function( code:Int, signal:String ) {
			if ( signal!=null || code==null ) {
				completeFn( 'Process exited with signal $signal.', null );
			}
			else if ( code!=null ) {
				processData.exitCode = code;
				completeFn( null, processData );
			}
		});
	}

	/**
		Given a collection of arguments to pass to the Haxe compiler, collect all the class paths that will be used.

		This involves looking for `["-cp",classPath]` patterns, and also `["-lib",'$libName:$libVersion']` patterns.

		All libraries will have class paths resolved using `haxelib path lib1 lib2:version` etc.

		@param cwd The absolute path to the working directory the hxml file is located in, or that "haxe" should be called from.
		@param args The arguments to be parsed to the Haxe compiler.
		@param cb A callback function `function (err:String, classPaths:Array<String>):Void {}`, with the class paths being absolute.
	**/
	public static function getClassPaths( cwd:String, inArgs:Array<String>, cb:String->Array<String>->Void ):Void {

		var allArgs = [];
		var cps = [];
		var libs = [];
		try {
			// Read any "*.hxml" arguments, and add each relevant line to the "allArgs" array
			allArgs = loadArgsRecursively( cwd, inArgs );
		}
		catch ( e:Dynamic ) {
			cb( 'In getClassPaths, failed to load args recursively: $e', null );
		}

		while ( allArgs.length>0 ) {
			var arg = allArgs.shift().trim();
			switch arg {
				case "-cp":
					var cp = allArgs.shift().trim();
					if ( cp.startsWith(cwd)==false ) {
						cp = cwd.addTrailingSlash()+cp;
					}
					cps.push( cp );
				case "-lib":
					var lib = allArgs.shift().trim();
					libs.push( lib );
			}
		}

		if ( libs.length>0 ) {
			var haxelibArgs = ["path"].concat( libs );
			runHaxelib( cwd, haxelibArgs, function(err:String, result:ProcessResult) {
				if ( err!=null )
					cb( err, null );

				try {
					var lines = result.stdout.split("\n");
					for ( l in lines ) {
						l = l.trim();
						if ( l!="" && l.startsWith("-")==false ) {
							cps.push( l );
						}
					}
					cb( null, cps );
				}
				catch ( e:Dynamic ) {
					cb( 'In getClassPaths, failed to process output of "haxelib ${haxelibArgs.join(" ")}": $e', null );
				}
			});
		}
		else {
			cb( null, cps );
		}
	}

	/**
		Given an array of args, load in not just these args, but any args in listed hxml files.
	**/
	public static function loadArgsRecursively( cwd:String, inArgs:Array<String>, ?outArgs:Array<String> ) {
		if ( outArgs==null )
			outArgs = [];

		for ( arg in inArgs ) {
			arg = arg.trim();
			if ( arg.endsWith(".hxml") ) {
				if ( arg.startsWith(cwd) )
					arg = arg.substr( cwd.length );

				var relativeDir = arg.directory();
				var lines = File.getContent( cwd.addTrailingSlash()+arg ).split( "\n" );
				for ( l in lines ) {
					l = l.trim();
					if ( l.startsWith("#") )
						continue;

					if ( l.startsWith("-cp") && relativeDir!="" ) {
						// If it's a cp, make sure it's relative to the hxml
						var cp = l.substr( 3 ).trim();
						outArgs.push( '-cp' );
						outArgs.push( '$relativeDir/$cp' );
					}
					else {
						var spaceIndex = l.indexOf( " " );
						if ( l.startsWith("-") && spaceIndex>-1 ) {
							// If this line is an argument pair (eg "-lib mylib"), split it and add both args.
							outArgs.push( l.substr(0, spaceIndex) );
							outArgs.push( l.substr(spaceIndex+1).trim() );
						}
						else if ( l.endsWith(".hxml") ) {
							// If the line is a link to yet another hxml, recurse into that.
							loadArgsRecursively( cwd.addTrailingSlash()+relativeDir, [l], outArgs );
						}
						else if ( l!="" ) {
							// Otherwise add the whole line. (eg "my.pack.ClassToCompile").
							outArgs.push( l );
						}
					}
				}
			}
			else outArgs.push( arg );
		}

		return outArgs;
	}

	/**
		Given a set of class paths, find the shortest filename 'relative' to one of the class paths.

		@param classPaths The classpaths to search for.
		@param filePath The absolute path to the given file.
		@return The shortest relative path for that file name, or the original filePath if no relative path was found.
	**/
	public static function pathRelativeToClassPaths( classPaths:Array<String>, filePath:String ) {
		var relativePaths = [];
		for ( cp in classPaths ) {
			if ( filePath.startsWith(cp) ) {
				relativePaths.push( filePath.substr(cp.length) );
			}
		}
		if ( relativePaths.length>0 ) {
			// Sort the array so we know which path is shortest.
			relativePaths.sort( function (cp1,cp2) return Reflect.compare(cp1.length, cp2.length) );
			return relativePaths[0];
		}
		else {
			return filePath;
		}
	}

	static var compilationServerProcess:Null<NodeChildProcess>;

	/**
		Start the compilation server.

		Calls `haxe --wait $port`.

		The `cb` callback is called either when an error occurs, or 50ms after the process has started.
	**/
	public static function startCompilationServer( port:Int, cb:String->Void ) {
		var called = false;
		var wrappedCb = function ( ?err:String ) {
			if ( !called )
				cb(err);
			called = true;
		};

		compilationServerProcess = Node.child_process.spawn( "haxe", ["--wait",'$port'] );
		compilationServerProcess.on( "error", wrappedCb );
		Node.setTimeout( wrappedCb, 50 );
	}
}
