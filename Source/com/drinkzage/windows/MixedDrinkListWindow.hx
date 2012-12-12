package com.drinkzage.windows;

import nme.Vector;
import nme.events.MouseEvent;

import com.drinkzage.windows.Item;
import com.drinkzage.windows.IListWindow;

/**
 * @author Robert Flesch
 */
class MixedDrinkListWindow extends IListWindow
{
	private static var _instance:MixedDrinkListWindow = null;
	
	public static function instance():MixedDrinkListWindow
	{ 
		if ( null == _instance )
			_instance = new MixedDrinkListWindow();
			
		return _instance;
	}

	private function new () 
	{
		super();
		
		createList();

		_tabs.push( "BACK" );
	}
	
	override public function selectionHandler():Void
	{
		_em.removeAllEvents();
		var blw: MixedDrinkWindow = MixedDrinkWindow.instance();
		blw.setBackHandler( this );
		blw.setItem( _item );
		blw.populate();
	}
	
	override public function createList():Void
	{
		var allItems:Vector<Item> = _window.allItems();
		var count:Int = allItems.length;
		for ( i in 0 ... count )
		{
			if ( allItems[i].category() == MixedDrinkWindow )
				_items.push( allItems[i] );
		}
	}
}
