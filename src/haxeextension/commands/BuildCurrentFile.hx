package haxeextension.commands;

import adobebrackets.command.CommandManager;
import adobebrackets.command.Menus;
import haxeextension.HaxePreferences;

class BuildCurrentFile {
	public static function command() {
		js.Lib.alert( 'Build current file!' );

		var useCompileServer = HaxePreferences.useCompilationServer;
		// var newValue = js.Browser.window.confirm( 'Would you like to use the compilation server?  Existing value $useCompileServer' );
		// HaxePreferences.useCompilationServer = newValue;

		return null;
	}

	public static function registerCommand() {
		var cmd = CommandManager.register( 'Build current file', 'jasononeil.haxeextension.buildcurrent', command );
		Menus.getMenu( AppMenuBar.FILE_MENU ).addMenuItem( cmd, 'Alt-Enter', Menus.LAST );
	}
}
