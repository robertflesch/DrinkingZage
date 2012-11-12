package com.drinkzage.windows;

import nme.text.TextField;
import nme.text.TextFormat;
import nme.text.TextFormatAlign;
import com.drinkzage.Globals;
import com.drinkzage.windows.BeerColor;
import com.drinkzage.windows.BeerCategory;

/**
 * @author Robert Flesch
 */
class Item
{
	public var _name:String;
	public var _textField:TextField;
	private var _category( category, null ):Dynamic;
	public function category():Dynamic { return _category; }
	
	private var _visible( isVisible, setVisible ):Bool;
	public function isVisible():Bool { return _visible; }
	public function setVisible( val:Bool ):Bool { return (_visible = val); }
	
	public function new( name:String, category:Dynamic ):Void
	{
		_visible = true;
		_category = category;
		
		_name = name;
		
		_textField = new TextField();
		_textField.height = Globals.g_app.componentHeight();
		_textField.text = name;
		_textField.background = true;
		_textField.backgroundColor = 0x000000;
		_textField.border = true;
		_textField.borderColor = 0xffffff;
		_textField.selectable = false;
		
		var ts = new TextFormat("_sans");
		ts.size = 36;                // set the font size
		ts.align = TextFormatAlign.CENTER;
		ts.color = 0xFF0000;           // set the color
		_textField.setTextFormat(ts);
	}
}