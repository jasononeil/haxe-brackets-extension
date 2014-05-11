package haxeextension.compilemacros;

import haxe.ds.Option;
import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.Type;
import haxe.Serializer;
import haxeextension.model.Typedefs;
using haxe.macro.TypeTools;
using StringTools;

class ListTypesAndFields {

	/**
		Print a JSON list of all the Types included in the current compilation (classes, enums, typedefs and abstracts).

		This includes both their name and the position of the type.

		This is intended to enable "jump to type" support in an IDE.

		@return This functions prints a serialized `Array<haxeextension.compilemacros.TypeDetails>` to stdout using `Sys.print`.
		        If the response is not a valid Haxe serialization, assume it is an error message from the compiler.
	**/
	public static function listTypes() {
		Context.onGenerate( function( types:Array<Type> ) {
			var detailsArr:Array<TypeDetails> = [];
			for ( t in types ) {
				switch getTypeNameAndPos( t ) {
					case Some( typeDetails ):
						detailsArr.push( typeDetails );
					default:
				}
			}
			Sys.print( Serializer.run(detailsArr) );
		});
	}

	/**
		For a given filename, list all of the field declarations for types defined inside that file.

		This includes their name, position, type, documentation, and the name of the parent type they belong to.

		This is intended to enable "jump to field" or "jump to definition" support in an IDE.

		@return This functions prints a serialized `Array<haxeextension.compilemacros.FieldDetails>` to stdout using `Sys.print`.
		        If the response is not a valid Haxe serialization, assume it is an error message from the compiler.
	**/
	public static function listFieldsForModule( filename:String ) {
		Context.onGenerate( function( types:Array<Type> ) {
			var fields:Array<FieldDetails> = [];
			for ( t in types ) {
				switch getTypeNameAndPos( t ) {
					case Some( typeDetails ):
						if ( typeDetails.pos.file==filename ) {
							for ( fieldDetails in  getFieldsForType(t) ) {
								fields.push( fieldDetails );
							}
						}
					default:
				}
			}
			Sys.print( Serializer.run(fields) );
		});
	}

	/**
		For a given `Type`, extract the fully qualified name and the position details.
	**/
	static function getTypeNameAndPos( type:Type ):Option<TypeDetails> {
		return switch type {
			case TEnum( t, params ):
				Some( { name: t.toString(), pos: Context.getPosInfos(t.get().pos) } );
			case TInst( t, params ):
				Some( { name: t.toString(), pos: Context.getPosInfos(t.get().pos) } );
			case TType( t, params ):
				Some( { name: t.toString(), pos: Context.getPosInfos(t.get().pos) } );
			case TAbstract( t, params ):
				Some( { name: t.toString(), pos: Context.getPosInfos(t.get().pos) } );
			default:
				None;
		}
	}

	/**
		Get fields for a given type.
	**/
	static function getFieldsForType( type:Type, ?originalTypeName:String ):Array<FieldDetails> {
		var fields:Array<FieldDetails> = [];
		if ( originalTypeName==null )
			originalTypeName = type.toString();

		function addField( v:{ name:String, pos:Position, type:Type, doc:Null<String> } ) {
			fields.push({
				name: v.name,
				pos: Context.getPosInfos( v.pos ),
				fieldTypeName: v.type.toString(),
				doc: v.doc,
				parentTypeName: originalTypeName
			});
		}

		switch type {
			case TMono( t ):
				var monoType = t.get();
				if ( monoType!=null ) {
					for ( field in getFieldsForType(monoType, originalTypeName) ) {
						fields.push( field );
					}
				}
			case TEnum( t, params ):
				var enumType = t.get();
				for ( name in enumType.names ) {
					addField( enumType.constructs.get(name) );
				}
			case TInst( t, params ):
				var classType = t.get();
				for ( field in classType.fields.get() ) {
					addField( field );
				}
			case TType( t, params ):
				for ( field in getFieldsForType(t.get().type, originalTypeName) ) {
					fields.push( field );
				}
			case TFun( args, ret ):
				// No fields to add.
			case TAnonymous( a ):
				var anonType = a.get();
				for ( field in anonType.fields ) {
					addField( field );
				}
			case TDynamic( t ):
				// Can hold any field, it's dynamic.  So don't add anything.
			case TLazy( f ):
				for ( field in getFieldsForType(f(), originalTypeName) ) {
					fields.push( field );
				}
			case TAbstract( t, params ):
				var abstractType = t.get();
				if ( abstractType.impl!=null ) {
					// TODO: Figure out why this always returns an empty array.  It does not appear to be DCE related.
					for ( field in abstractType.impl.get().fields.get() ) {
						addField( field );
					}
				}
		}
		return fields;
	}
}
