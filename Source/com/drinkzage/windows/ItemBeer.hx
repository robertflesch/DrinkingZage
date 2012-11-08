package com.drinkzage.windows;

import nme.text.TextField;
import nme.text.TextFormat;
import nme.text.TextFormatAlign;
import com.drinkzage.windows.BeerColor;
import com.drinkzage.windows.BeerCategory;
import com.drinkzage.windows.Item;

/**
 * @author Robert Flesch
 */
class ItemBeer extends Item
{
	public var _label:String;
	public var _color:ContainerColor;
	public var _category:BeerCategory;
	public var _bcolor:BeerColor;
	
	public var category( getCategory, null ):BeerCategory;
	
	public function getCategory():BeerCategory { return _category; }
	
	public function new( name:String, label_image:String, category:String, color:ContainerColor, bcolor:BeerColor ):Void
	{
		super( name );
		
		_label = label_image;
		_category = Type.createEnum( BeerCategory, category );
		_color = color;
		_bcolor = bcolor;
		
	}
}