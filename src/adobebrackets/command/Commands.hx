package adobebrackets.command;

@:enum
abstract Commands( String ) {
	/**
	 * List of constants for global command IDs.
	 */

	// FILE
	var FILE_NEW_UNTITLED = "file.newDoc";
	var FILE_NEW = "file.newFile";
	var FILE_NEW_FOLDER = "file.newFolder";
	var FILE_OPEN = "file.open";
	var FILE_OPEN_FOLDER = "file.openFolder";
	var FILE_SAVE = "file.save";
	var FILE_SAVE_ALL = "file.saveAll";
	var FILE_SAVE_AS = "file.saveAs";
	var FILE_CLOSE = "file.close";
	var FILE_CLOSE_ALL = "file.close_all";
	var FILE_CLOSE_LIST = "file.close_list";
	var FILE_ADD_TO_WORKING_SET = "file.addToWorkingSet";
	var FILE_OPEN_DROPPED_FILES = "file.openDroppedFiles";
	var FILE_LIVE_FILE_PREVIEW = "file.liveFilePreview";
	var FILE_LIVE_HIGHLIGHT = "file.previewHighlight";
	var FILE_PROJECT_SETTINGS = "file.projectSettings";
	var FILE_RENAME = "file.rename";
	var FILE_DELETE = "file.delete";
	var FILE_EXTENSION_MANAGER = "file.extensionManager";
	var FILE_REFRESH = "file.refresh";
	var FILE_OPEN_PREFERENCES = "file.openPreferences";

	// File shell callbacks - string must MATCH string in native code (appshell/command_callbacks.h)
	var FILE_CLOSE_WINDOW = "file.close_window";
	var FILE_QUIT = "file.quit";

	// EDIT
	// File shell callbacks - string must MATCH string in native code (appshell/command_callbacks.h)
	var EDIT_UNDO = "edit.undo";
	var EDIT_REDO = "edit.redo";
	var EDIT_CUT = "edit.cut";
	var EDIT_COPY = "edit.copy";
	var EDIT_PASTE = "edit.paste";
	var EDIT_SELECT_ALL = "edit.selectAll";

	var EDIT_SELECT_LINE = "edit.selectLine";
	var EDIT_SPLIT_SEL_INTO_LINES = "edit.splitSelIntoLines";
	var EDIT_ADD_CUR_TO_NEXT_LINE = "edit.addCursorToNextLine";
	var EDIT_ADD_CUR_TO_PREV_LINE = "edit.addCursorToPrevLine";
	var EDIT_FIND = "edit.find";
	var EDIT_FIND_IN_FILES = "edit.findInFiles";
	var EDIT_FIND_IN_SUBTREE = "edit.findInSubtree";
	var EDIT_FIND_NEXT = "edit.findNext";
	var EDIT_FIND_PREVIOUS = "edit.findPrevious";
	var EDIT_FIND_ALL_AND_SELECT = "edit.findAllAndSelect";
	var EDIT_ADD_NEXT_MATCH = "edit.addNextMatch";
	var EDIT_SKIP_CURRENT_MATCH = "edit.skipCurrentMatch";
	var EDIT_REPLACE = "edit.replace";
	var EDIT_INDENT = "edit.indent";
	var EDIT_UNINDENT = "edit.unindent";
	var EDIT_DUPLICATE = "edit.duplicate";
	var EDIT_DELETE_LINES = "edit.deletelines";
	var EDIT_LINE_COMMENT = "edit.lineComment";
	var EDIT_BLOCK_COMMENT = "edit.blockComment";
	var EDIT_LINE_UP = "edit.lineUp";
	var EDIT_LINE_DOWN = "edit.lineDown";
	var EDIT_OPEN_LINE_ABOVE = "edit.openLineAbove";
	var EDIT_OPEN_LINE_BELOW = "edit.openLineBelow";
	var TOGGLE_CLOSE_BRACKETS = "edit.autoCloseBrackets";
	var SHOW_CODE_HINTS = "edit.showCodeHints";

	// VIEW
	var VIEW_HIDE_SIDEBAR = "view.hideSidebar";
	var VIEW_INCREASE_FONT_SIZE = "view.increaseFontSize";
	var VIEW_DECREASE_FONT_SIZE = "view.decreaseFontSize";
	var VIEW_RESTORE_FONT_SIZE = "view.restoreFontSize";
	var VIEW_SCROLL_LINE_UP = "view.scrollLineUp";
	var VIEW_SCROLL_LINE_DOWN = "view.scrollLineDown";
	var VIEW_TOGGLE_INSPECTION = "view.toggleCodeInspection";
	var TOGGLE_LINE_NUMBERS = "view.toggleLineNumbers";
	var TOGGLE_ACTIVE_LINE = "view.toggleActiveLine";
	var TOGGLE_WORD_WRAP = "view.toggleWordWrap";
	var SORT_WORKINGSET_BY_ADDED = "view.sortWorkingSetByAdded";
	var SORT_WORKINGSET_BY_NAME = "view.sortWorkingSetByName";
	var SORT_WORKINGSET_BY_TYPE = "view.sortWorkingSetByType";
	var SORT_WORKINGSET_AUTO = "view.sortWorkingSetAuto";

	// NAVIGATE
	var NAVIGATE_NEXT_DOC = "navigate.nextDoc";
	var NAVIGATE_PREV_DOC = "navigate.prevDoc";
	var NAVIGATE_SHOW_IN_FILE_TREE = "navigate.showInFileTree";
	var NAVIGATE_SHOW_IN_OS = "navigate.showInOS";
	var NAVIGATE_QUICK_OPEN = "navigate.quickOpen";
	var NAVIGATE_JUMPTO_DEFINITION = "navigate.jumptoDefinition";
	var NAVIGATE_GOTO_DEFINITION = "navigate.gotoDefinition";
	var NAVIGATE_GOTO_LINE = "navigate.gotoLine";
	var NAVIGATE_GOTO_FIRST_PROBLEM = "navigate.gotoFirstProblem";
	var TOGGLE_QUICK_EDIT = "navigate.toggleQuickEdit";
	var TOGGLE_QUICK_DOCS = "navigate.toggleQuickDocs";
	var QUICK_EDIT_NEXT_MATCH = "navigate.nextMatch";
	var QUICK_EDIT_PREV_MATCH = "navigate.previousMatch";
	var CSS_QUICK_EDIT_NEW_RULE = "navigate.newRule";

	// HELP
	var HELP_CHECK_FOR_UPDATE = "help.checkForUpdate";
	var HELP_HOW_TO_USE_BRACKETS = "help.howToUseBrackets";
	var HELP_SUPPORT = "help.support";
	var HELP_SUGGEST = "help.suggest";
	var HELP_RELEASE_NOTES = "help.releaseNotes";
	var HELP_GET_INVOLVED = "help.getInvolved";
	var HELP_SHOW_EXT_FOLDER = "help.showExtensionsFolder";
	var HELP_TWITTER = "help.twitter";

	// File shell callbacks - string must MATCH string in native code (appshell/command_callbacks.h)
	var HELP_ABOUT = "help.about";

	// APP
	var APP_RELOAD = "app.reload";
	var APP_RELOAD_WITHOUT_EXTS = "app.reload_without_exts";

	// File shell callbacks - string must MATCH string in native code (appshell/command_callbacks.h)
	var APP_ABORT_QUIT = "app.abort_quit";
	var APP_BEFORE_MENUPOPUP = "app.before_menupopup";
}
