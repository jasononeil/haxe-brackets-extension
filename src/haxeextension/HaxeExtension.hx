package haxeextension;

import adobebrackets.command.CommandManager;
import adobebrackets.document.DocumentManager;
import adobebrackets.language.LanguageManager;
import adobebrackets.editor.CodeHintManager;
import adobebrackets.utils.AppInit;
import adobebrackets.utils.ExtensionUtils;
import adobebrackets.utils.NodeDomain;
import haxeextension.codehint.HaxeHint;
import haxeextension.commands.*;

class HaxeExtension {
	static function main() {
		untyped define( HaxeExtension.load );
	}

	static function load( require, exports, module ) {

		LanguageManager.defineLanguage( "haxe", {"name":"Haxe","mode":"haxe","fileExtensions":["hx"],"lineComment":["//"],"blockComment":["/*","*/"]} );
		LanguageManager.defineLanguage( "hxml", {"name":"Hxml (Haxe Build File)","mode":"haxe","fileExtensions":["hxml"],"lineComment":["#"]} );

		var haxeDomain = new NodeDomain( "haxe", ExtensionUtils.getModulePath(module, "node/HaxeDomain") );

		AppInit.appReady(function() {
			CodeHintManager.registerHintProvider( new HaxeHint(haxeDomain), ["hx"], 0 );
			BuildCurrentFile.registerCommand();
			SelectBuild.registerCommand();
		});

		AppInit.htmlReady(function() {
			var less = CompileTime.readFile( 'haxe-extension.less' );
			var cssPromise = ExtensionUtils.parseLessCode( less );
			cssPromise.then(function( css ) {
				ExtensionUtils.addEmbeddedStyleSheet( css );
			});
		});
	}
}
