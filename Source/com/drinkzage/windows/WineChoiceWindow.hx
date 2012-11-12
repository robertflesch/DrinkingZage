package com.drinkzage.windows;

import com.drinkzage.DrinkingZage;
import nme.events.MouseEvent;
import com.drinkzage.windows.Item;
import nme.Vector;

/**
 * @author Robert Flesch
 */
class WineChoiceWindow extends ITabListWindow
{
	private static var _instance:WineChoiceWindow = null;
	
	public static function instance():WineChoiceWindow
	{ 
		if ( null == _instance )
			_instance = new WineChoiceWindow();
			
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
		removeListeners();
		var blw: WineWindow = WineWindow.instance();
		blw.populate( _item );
	}
	
	override public function createList():Void
	{
		var allItems:Vector<Item> = _window.getAllItems();
		var count:Int = allItems.length;
		for ( i in 0 ... count )
		{
			if ( allItems[i].category() == WineWindow )
				_items.push( allItems[i] );
		}
	}
}


