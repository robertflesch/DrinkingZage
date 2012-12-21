package com.drinkzage.windows;
import com.drinkzage.Globals;

/**
 * @author Robert Flesch
 */
class Item
{
	private var _category( category, null ):Dynamic;
	public function category():Dynamic { return _category; }
	
	private var _visible( isVisible, setVisible ):Bool;
	public function isVisible():Bool { return _visible; }
	public function setVisible( val:Bool ):Bool { return (_visible = val); }
	
	private var _name( name, null ):String;
	public function name():String { return _name; }

	private var _fav( fav, setFav ):Bool = false;
	public function fav():Bool { return _fav; }
	public function setFav( val:Bool ):Bool { return _fav = val; }
		
	public function categoryName():String 
	{ 
		var t:String = Std.string( _category );
		var sp:Int = t.indexOf( " " ) + 1;
		t = t.substr( sp, (t.length - sp - 1) );
		return t; 
	}
	
	public function isFavorite():Bool
	{
		return Globals.g_itemLibrary.isDrinkFavorite( this );
	}
	
	public function new( name:String, category:Dynamic ):Void
	{
		_visible = true;
		_category = category;
		_name = name;
		_fav = isFavorite();
	}
}