# Haxe Brackets Extension

[Adobe Brackets][brackets] is an open source code editor with a lot of cool features.

[Haxe][] is a programming language and toolkit for writing code that compiles to JavaScript, C++, Java, PHP, Neko, C#, Python and more.

This extension gives Brackets a few extra features for interacting with Haxe code, including:

* Compiler based code hints / auto completion.  Press Ctrl-Alt-Enter 
* Syntax Highlighting (very basic highlighting for ".hx" files)
* Hopefully more features soon (see Roadmap below)

## Current Status

This extension is in extremely early stages of development.

I am using it with some success on Ubuntu 12.04 with Brackets sprint 38.  I have not tested it on either Mac or Windows, there will likely be various issues.

I am sharing this now as a few people have asked to see my progress so far, and are possibly interested in contributing.

## Installation

Currently this extension has not been submitted to the brackets extension repository or made available as a zip file, so you will need to clone this git repository and compile your code, as described below in the "Setting up the development environment" section.

First you will need to install [brackets][] and NodeJS.

## Features and Usage

#### Syntax highlighting for ".hx" files.

This is automatic.

#### Code hinting

When editing a Haxe file, pressing "." or "(" will attempt to launch compiler based auto-completion.

By default it will attempt to use completion on that specific file.  You can press "Ctrl-Alt-Enter" to choose a HXML file to use.

The Haxe completion server is used for code hints.  You can turn it off by setting:

	"haxe.use-compilation-server": true,

in your preferences JSON file (`Debug -> Open Preferences File`).

## Roadmap

These features I would like to implement soon:

* Select multiple compilation targets for any file
* Shortcut key to compile files
* Error panel for compile errors, clicking jumps to error location
* Compile on save
* Quick-Open to jump to any type definition in the current build
* Quick-Open to jump to any field declaration in the current module
* Basic hxml highlighting and completion

Any help here appreciated.

## Contributing

* Please add any bug reports to Github.
* Pull requests are more than welcome.  
  If you provide a few helpful pull requests (or ask nicely) I can grant commit access to this repository.

#### Setting up the development environment

These steps are needed to install the extension by cloning this repo:

* Make sure you have both [brackets][] and [Node JS][node] installed.
* In brackets, open a terminal up and navigate to your extension folder.  
  (If you're not sure where it is, use `Help -> Show Extension Folder` to find it.)
* Go into the "user" directory.
* Clone this repo:  
  `git clone https://github.com/jasononeil/haxe-brackets-extension.git`
* Move into the extension directory: `cd haxe-brackets-extension`
* Install node modules: `cd node; npm install tmp; cd ..`  
  (TODO: set this up the proper NodeJS way...)

Then if you want to actually modify the contents:

* Install haxelibs:  
  `haxelib install all`
* Compile the plugin:  
  `haxe build.hxml`
* Reload brackets: `F5`, or  
  `Debug -> Reload With Extensions`
  
A quick outline of the code base:

* `adobebrackets`: A package containing externs for Adobe Brackets.  
  These are manually generated from the documentation.  
  We may try to automate this in future.  If there's interest in maintaining these in a separate haxelib we can look into it.
* `nodejs`: A package containing externs for various NodeJS libs.  These should probably be moved to a 3rd party lib at some point.
* `haxeextension`: The package for our extension's code
	* `codehint`: Classes to help with getting code hints from the compiler.
	* `commands`: Each command that is registered with the extension.
	* `compilemacros`: Macros that are added to the build to generate helpful info, like type declaration positions etc.
	* `domain`: The "domain" is Bracket's way of having code run in a separate thread that has access to the NodeJS APIs.  We use a domain for calling the Haxe compiler, writing to the file system etc.
	* `model`: Various typedefs used for shifting data around parts of the extension.

---

[haxe]: http://haxe.org
[brackets]: http://brackets.io
[node]: http://nodejs.org/download