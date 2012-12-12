package com.drinkzage.windows;

import nme.Vector;
import com.drinkzage.windows.Item;

/**
 * @author Robert Flesch
 */
class ShotListWindow extends IListWindow
{
	private static var _instance:ShotListWindow = null;
	
	public static function instance():ShotListWindow
	{ 
		if ( null == _instance )
			_instance = new ShotListWindow();
			
		return _instance;
	}

	private function new () 
	{
		super();
		
		_tabs.push( "BACK" );
		
		createList();
	}
	
	override public function selectionHandler():Void
	{
		_em.removeAllEvents();
		var blw: ShotWindow = ShotWindow.instance();
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
			if ( allItems[i].category() == ShotWindow )
				_items.push( allItems[i] );
		}
	}
}
