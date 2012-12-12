package com.drinkzage.windows;

import com.drinkzage.DrinkingZage;
import nme.events.MouseEvent;
import com.drinkzage.windows.Item;
import nme.Vector;
import com.drinkzage.windows.IListWindow;

/**
 * @author Robert Flesch
 */
class WineListWindow extends IListWindow
{
	private static var _instance:WineListWindow = null;
	
	public static function instance():WineListWindow
	{ 
		if ( null == _instance )
			_instance = new WineListWindow();
			
		return _instance;
	}
	
	public function new () 
	{
		super();
		
		_tabs.push( "BACK" );
		
		createList();
	}
	
	override public function selectionHandler():Void
	{
		_em.removeAllEvents();
		var blw: WineWindow = WineWindow.instance();
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
			if ( allItems[i].category() == WineWindow )
				_items.push( allItems[i] );
		}
	}
}


