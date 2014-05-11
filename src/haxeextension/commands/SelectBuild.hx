package haxeextension.commands;

import adobebrackets.command.CommandManager;
import adobebrackets.command.Menus;
import adobebrackets.document.DocumentManager;
import adobebrackets.filesystem.FileSystem;
import adobebrackets.preferences.PreferencesManager;
import adobebrackets.filesystem.File;
import adobebrackets.project.ProjectManager;
import adobebrackets.widgets.Dialogs;
import adobebrackets.widgets.DefaultDialog;
import haxeextension.HaxePreferences;
using haxe.io.Path;

class SelectBuild {
	public static function command() {
		var projectBase = ProjectManager.getBaseUrl();
		var hxmlFilter = function ( f:File ) {
			return f.name.extension()=="hxml";
		}
		var hxmlFiles = ProjectManager.getAllFiles( hxmlFilter, false );
		hxmlFiles.then( function( files:Array<File> ) {

			var d = jQuery.JQuery._static.Deferred();

			// var select = new jQuery.JQuery( "select" ).attr( 'title', 'Code Hint Hxml' );
			// for ( f in files ) {
			// 	var fullPath = f.fullPath;
			// 	var relative = ProjectManager.makeProjectRelativeIfPossible( f.fullPath );
			// 	var option = new jQuery.JQuery( '<option value="$fullPath">$relative</option>' );
			// 	select.append( option );
			// }

			// var filenames = files.map( function(f) return ProjectManager.makeProjectRelativeIfPossible(f.fullPath) );
			// var filenamesStr = filenames.join(", <br />");
			// var dialog = Dialogs.showModalDialog( DIALOG_ID_SAVE_CLOSE, "Build config", select.html() );
			// dialog.done( function( btnID:DialogButtonID ) {
			// 	if ( btnID==DIALOG_BTN_OK ) {
			// 		js.Lib.alert( 'save' );
			// 		js.Lib.debug();
			// 	}
			// 	else js.Lib.alert( 'no save' );
			// });

			FileSystem.showOpenDialog( false, false, "Select completion hxml file", projectBase, ["*.hxml"], function( error, files ) {
				if ( error!=null )
					throw error;

				var completionFile = files[0];
				var filePath = DocumentManager.getCurrentDocument().file.fullPath;
				HaxePreferences.setDisplayFile( filePath, completionFile );
			});
		});
		return null;
	}

	public static function registerCommand() {
		var cmd = CommandManager.register( 'Build options', 'jasononeil.haxeextension.selectbuild', command );
		Menus.getMenu( AppMenuBar.FILE_MENU ).addMenuItem( cmd, 'Ctrl-Alt-Enter', Menus.LAST );
	}
}
