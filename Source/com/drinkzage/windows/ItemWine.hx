package com.drinkzage.windows;

import com.drinkzage.windows.Item;
import com.drinkzage.windows.WineCategory;

/**
 * @author Robert Flesch
 */
class ItemWine extends Item
{
	private var _wineCategory( getWineCategory, null ):WineCategory;
	public function getWineCategory():WineCategory { return _wineCategory; }
	
	public function new( name:String, category:Dynamic, wineCategory:String ):Void
	{
		super( name, category );
		
		_wineCategory = Type.createEnum( WineCategory, wineCategory );
	}
}