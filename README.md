# Haxe Brackets Extension

[Adobe Brackets][brackets] is an open source code editor with a lot of cool features.

[Haxe][] is a programming language and toolkit for writing code that compiles to JavaScript, C++, Java, PHP, Neko, C#, Python and more.

This extension gives Brackets a few extra features for interacting with Haxe code, including:

* Compiler based code hints / auto completion.  Press Ctrl-Alt-Enter 
* Syntax Highlighting (very basic highlighting for ".hx" files)
* Hopefully more features soon (see Roadmap below)


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

[haxe]: http://haxe.org
[brackets]: http://brackets.io
[node]: http://nodejs.org/download