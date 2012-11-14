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
	public var _beerCategory:BeerCategory;
	public var _bcolor:BeerColor;
	
	public var beerCategory( getBeerCategory, null ):BeerCategory;
	
	public function getBeerCategory():BeerCategory { return _category; }
	
	public function new( name:String, category:Dynamic, label_image:String, beerCategory:String, color:String, bcolor:String ):Void
	{
		super( name, category );
		
		_label = label_image;
		_beerCategory = Type.createEnum( BeerCategory, beerCategory );
		_color = Type.createEnum( ContainerColor, color );
		_bcolor = Type.createEnum( BeerColor, bcolor );
	}
}