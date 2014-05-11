package haxeextension.codehint;

import adobebrackets.document.Document;
import adobebrackets.document.DocumentManager;
import adobebrackets.editor.CodeHintManager;
import adobebrackets.editor.Editor;
import adobebrackets.filesystem.File;
import adobebrackets.utils.ExtensionUtils;
import adobebrackets.utils.NodeDomain;
import haxeextension.HaxePreferences;
import haxeextension.model.Typedefs;
import jQuery.Deferred;
import jQuery.JQuery;
using Detox;
using StringTools;
using haxe.io.Path;
using tink.CoreApi;

@:keep
class HaxeHint implements CodeHintProvider {

	public var insertHintOnTab = true;
	var editor:Editor;
	var domain:NodeDomain;

	// Private vars used to filter an existing code hint.
	var hintsPromise:Deferred;
	var openingChar:String;
	var openingPos:Pos;
	var argHints:String;

	public function new( domain:NodeDomain ) {
		this.domain = domain;
	}

	public function hasHints( editor:Editor, implicitChar:String ) {
		this.editor = editor;

		// I'm not going to bother supporting this yet: we would have to figure out the last relevant trigger character.
		if ( implicitChar==null )
			return false;

		// If it is a "." (import completion, field access completion) or a "(" (function argument completion) then we have hints.
		if ( isTriggerCharacter(implicitChar) )
			return true;

		return false;
	}

	function isTriggerCharacter( ch:String ) {
		return ch!=null && [".","("].indexOf( ch )>-1;
	}

	function shouldCompletionClose( ch:String ) {
		// Has the cursor moved back before the original completion point?
		if ( openingPos!=null ) {
			var cursor = editor.getCursorPos();
			var earlierLine = cursor.line<openingPos.line;
			var earlierPosOnLine = cursor.line==openingPos.line && cursor.ch<openingPos.ch;
			if ( earlierLine || earlierPosOnLine )
				return true;
		}

		// Is it cursor navigation, without moving beyond the original position?
		// Let this occur.
		if ( ch==null )
			return false;

		return switch openingChar {
			case ".":
				[" ",";","\n"].indexOf( ch )>-1;
			case "(":
				[")",";","\n"].indexOf( ch )>-1;
			default:
				false;
		}
	}

	public function getHints( implicitChar:String ) {
		return
			if ( CodeHintManager.isOpen() && !isTriggerCharacter(implicitChar) )
				continueHintSession( implicitChar );
			else
				startHintSession( implicitChar );
	}

	function startHintSession( implicitChar:String ) {
		this.openingChar = implicitChar;
		this.openingPos = this.editor.getCursorPos();
		this.hintsPromise = JQuery._static.Deferred();
		this.argHints = null;

		var start:Pos = { line:0, ch:0 };
		var cursorPos = editor.document.getRange( start, openingPos ).length;

		var hintsOutputPromise = runHaxeToGetHints( cursorPos );
		hintsOutputPromise.then( function(stderr:String) {

			var hintsData:HintsInfo = {
				hints: [],
				match: null,
				selectInitial: true,
				handleWideResults: false
			};

			switch implicitChar {
				case ".":
					var hints = [];
					var list = stderr.parse();
					for ( item in list.find("i") ) {
						hints.push( buildHintFromCompletionItem(item) );
					}

					if ( hints.length==0 ) {
						editor.displayErrorMessageAtCursor( stderr );
						hintsPromise.reject( stderr );
					}
					else {
						hintsData.hints = hints;
						hintsPromise.resolve( hintsData );
					}

				case "(":
					var typeString = stderr.parse().text();

					// Until I can deal with something this complex:
					// fn1 : (Int -> (Int -> Void) -> Void) -> fn2 : (String -> String -> Int) -> opt : Array<Bool> -> (Array<Int> -> Void)
					// I'm going to have to not transform any type info where one of the arguments is a callback.
					// Ideally I would prefer "fn1:Int->(Int->Void)->Void, fn2:(String->String->Int), opt:Array<Bool>".  leave the end type off.

					if ( typeString.indexOf("(")==-1 ) {
						// Only transform if none of the arguments use brackets, hopefully meaning none have callbacks as arguments.
						var typeParts = typeString.split( "->" );
						typeParts.pop();
						typeParts.map( function(p) return p.trim() );
						typeString = typeParts.join(", ");
					}

					hintsData.hints = [ typeString ];
					hintsPromise.resolve( hintsData );
			}
		});

		return hintsPromise;
	}

	function continueHintSession( implicitChar:String ) {
		if ( shouldCompletionClose(implicitChar) )
			return null;

		switch this.openingChar {
			case ".":
				// Wrap the promise with a new one, either
				var filteredHintsPromise = JQuery._static.Deferred();
				hintsPromise.fail( filteredHintsPromise.reject );
				hintsPromise.then( function(hintsData:HintsInfo) {
					if ( hintsData!=null ) {
						var extraText = getExtraText();
						var newHints = {
							hints: filterHints( hintsData.hints, extraText ),
							match: null,
							selectInitial: true,
							handleWideResults: false
						}
						hintsData.match = extraText;
						hintsData.selectInitial == true;
						filteredHintsPromise.resolve( newHints );
					}
					else filteredHintsPromise.resolve( null );
				});
				return filteredHintsPromise;
			default:
				return hintsPromise;
		}


	}


	function getExtraText() {
		var cursor = this.editor.getCursorPos();
		return editor.document.getRange( openingPos, cursor );
	}

	function runHaxeToGetHints( pos:Int ):Deferred {
		var promise = JQuery._static.Deferred();

		var pair = getArgsAndCwdForFile( editor.document.file );
		var args = pair.a;
		var cwd = pair.b;

		var req:CompletionRequest = {
			cwd: cwd,
			args: args,
			currentFile: editor.document.file.fullPath,
			currentContent: editor.document.getText( false ),
			pos: pos
		}

		domain.exec( "getCompletionHint", req ).then( function(result) {

			var processResult:ProcessResult = result;
			if ( processResult.stderr!=null ) {
				promise.resolve( processResult.stderr );
			}
			else {
				promise.reject( 'Stderr was null: exit code ${processResult.exitCode}' );
			}
		} ).fail( function(err) js.Lib.alert(err) );

		return promise;
	}

	function getArgsAndCwdForFile( currentFile:File ):Pair<Array<String>,String> {
		var cwd:String;
		var args:Array<String> = [];

		if ( HaxePreferences.useCompilationServer ) {
			args.push( "--connect" );
			args.push( "6000" );
		}

		switch HaxePreferences.getDisplayFile( currentFile.fullPath ) {
			case Some( hxmlFile ):
				args.push( hxmlFile );
				cwd = hxmlFile.directory();
			case None:
				var className = currentFile.name.withoutExtension();
				args.push( "-main" );
				args.push( className );
				cwd = currentFile.parentPath;
		}
		return new Pair( args, cwd );
	}

	function buildHintFromCompletionItem( item:DOMNode ) {
		var hint = item.attr( 'n' );
		var type = item.find( 't' ).innerHTML().trim();
		var typeSpan = ( type!="" ) ? '<span class="hint-type">($type)</span>' : "";
		var doc = cleanDoc( item.find('d').innerHTML() );
		return '<span title="$doc" class="haxe-hint"><span class="hint-code">$hint</span> $typeSpan</span>';
	}

	function cleanDoc( doc:String ) {
		trace( doc );
		var origLines = doc.trim().split( "\n" );
		var lines = [];
		for ( l in origLines ) {
			l = l.trim();
			if ( l=="" )
				l = "\n\n"; // Blank line: new paragraph.
			lines.push( l );
		}
		return lines.join( '' ).htmlEscape( true );
	}

	function getCodeFromHint( hint:String, extraText:String ) {
		var code = hint.parse().find( '.hint-code' ).text();
		var extraText = getExtraText();
		if ( code.startsWith(extraText) ) {
			code = code.substr( extraText.length );
		}
		return code;
	}

	function filterHints( hints:Array<String>, letters:String ):Array<String> {
		return hints.filter( function( hintText ) {
			var hint = hintText.parse();
			return hint.text().startsWith( letters );
		});
	}

	public function insertHint( hint:String ) {

		if ( this.openingChar=="." ) {
			// Get offset to hash
			// var offset = this.info.offset - 1; // Not using CSS, so info is null.
			var offset = 0;

			// Get the text from hint
			var code = getCodeFromHint( hint, getExtraText() );

			// Document objects represent file contents
			var currentDoc:Document = DocumentManager.getCurrentDocument();

			// Get the position of our cursor in the document
			var pos:Pos = this.editor.getCursorPos();

			// Where the range starts that should be replaced
			var start:Pos = { line: pos.line , ch: pos.ch - offset };

			// Add some text in our document
			currentDoc.replaceRange(code, start, pos);
		}


		return false;
	};
}
