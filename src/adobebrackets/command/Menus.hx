package adobebrackets.command;

import adobebrackets.command.KeyBindingManager.PlatformKeyBinding;
import js.html.MouseEvent;
import jQuery.haxe.Either;

extern class Menus {
	static public var BEFORE:String;
	static public var AFTER:String;
	static public var LAST:String;
	static public var FIRST:String;
	static public var FIRST_IN_SECTION:String;
	static public var LAST_IN_SECTION:String;
	static public var DIVIDER:String;

	static public function getMenu( id:Either<AppMenuBar,String> ):Menu;
	static public function getAllMenus():Dynamic<Menu>;
	static public function getMenuItem( id:String ):MenuItem;
	static public function getContextMenu( id:String ):ContextMenu;
	static public function addMenu( name:String, id:String, ?position:String, ?relativeID:Either<AppMenuBar,String> ):Null<Menu>;
	static public function removeMenu( id:String ):Void;
	static public function registerContextMenu( id:ContextMenuId ):ContextMenu;
	static public function closeAll():Void;

	private static function __init__():Void untyped {
		var adobebrackets = adobebrackets || {};
		adobebrackets.command = adobebrackets.command || {};
		adobebrackets.command.Menus = brackets.getModule("command/Menus");
	}
}

extern class Menu {
	public function removeMenuItem( cmd:Either<String,Command> ):Void;
	public function removeMenuDivider( menuItemID:String ):Void;
	public function addMenuItem( cmd:Either<String,Command>, ?keyBindings:Either<String,PlatformKeyBinding>, ?position:String, ?relativeCmdIDOrSection:Either<String,MenuSection> ):MenuItem;
	public function addMenuDivider( position:String, relativeIDForMenuItemSubMenuOrSection:Either<String,MenuSection> ):MenuItem;

}

extern class MenuItem {
	public function getCommand():Command;
	public function getParentMenu():Menu;
}

extern class ContextMenu extends Menu {
	public function new( id:String );
	public function open( mouseOrLocation:Either<MouseEvent,{ pageX:Int, pageY:Int }> ):Void;
	public function close():Void;
	public function isOpen():Bool;
	public static function assignContextMenuToSelector( selector:String, cmenu:ContextMenu ):Void;

	private static function __init__():Void untyped {
		var adobebrackets = adobebrackets || {};
		adobebrackets.command = adobebrackets.command || {};
		adobebrackets.command.ContextMenu = brackets.getModule("command/Menus").ContextMenu;
	}
}

@:enum abstract AppMenuBar( String ) {
	var FILE_MENU = "file-menu";
	var EDIT_MENU = "edit-menu";
	var VIEW_MENU = "view-menu";
	var NAVIGATE_MENU = "navigate-menu";
	var HELP_MENU = "help-menu";
}

@:enum abstract ContextMenuId( String ) {
	var EDITOR_MENU = "editor-context-menu";
	var INLINE_EDITOR_MENU = "inline-editor-context-menu";
	var PROJECT_MENU = "project-context-menu";
	var WORKING_SET_MENU = "working-set-context-menu";
	var WORKING_SET_SETTINGS_MENU = "working-set-settings-context-menu";
}

extern class MenuSection {
	// Menu Section
	public static var FILE_OPEN_CLOSE_COMMANDS:{sectionMarker:String};
	public static var FILE_SAVE_COMMANDS:{sectionMarker:String};
	public static var FILE_LIVE:{sectionMarker:String};
	public static var FILE_EXTENSION_MANAGER:{sectionMarker:String};

	public static var EDIT_UNDO_REDO_COMMANDS:{sectionMarker:String};
	public static var EDIT_TEXT_COMMANDS:{sectionMarker:String};
	public static var EDIT_SELECTION_COMMANDS:{sectionMarker:String};
	public static var EDIT_FIND_COMMANDS:{sectionMarker:String};
	public static var EDIT_REPLACE_COMMANDS:{sectionMarker:String};
	public static var EDIT_MODIFY_SELECTION:{sectionMarker:String};
	public static var EDIT_COMMENT_SELECTION:{sectionMarker:String};
	public static var EDIT_CODE_HINTS_COMMANDS:{sectionMarker:String};
	public static var EDIT_TOGGLE_OPTIONS:{sectionMarker:String};

	public static var VIEW_HIDESHOW_COMMANDS:{sectionMarker:String};
	public static var VIEW_FONTSIZE_COMMANDS:{sectionMarker:String};
	public static var VIEW_TOGGLE_OPTIONS:{sectionMarker:String};

	public static var NAVIGATE_GOTO_COMMANDS:{sectionMarker:String};
	public static var NAVIGATE_DOCUMENTS_COMMANDS:{sectionMarker:String};
	public static var NAVIGATE_OS_COMMANDS:{sectionMarker:String};
	public static var NAVIGATE_QUICK_EDIT_COMMANDS:{sectionMarker:String};
	public static var NAVIGATE_QUICK_DOCS_COMMANDS:{sectionMarker:String};

	private static function __init__():Void untyped {
		var adobebrackets = adobebrackets || {};
		adobebrackets.command = adobebrackets.command || {};
		adobebrackets.command.MenuSection = brackets.getModule("command/Menus").MenuSection;
	}
}
