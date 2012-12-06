package com.drinkzage.windows;

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
	
	public function new( name:String, category:Dynamic ):Void
	{
		_visible = true;
		_category = category;
		_name = name;
	}
}