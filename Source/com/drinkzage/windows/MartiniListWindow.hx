package com.drinkzage.windows;

import nme.Vector;


/**
 * @author Robert Flesch
 */
class MartiniListWindow extends IListWindow
{
	
	private static var _instance:MartiniListWindow = null;
	
	public static function instance():MartiniListWindow
	{ 
		if ( null == _instance )
			_instance = new MartiniListWindow();
			
		return _instance;
	}

	private function new () {
		super();
		
		_tabs.push( "BACK" );
		
		createList();
	}
	
	override public function selectionHandler():Void
	{
		_em.removeAllEvents();
		var blw: MartiniWindow = MartiniWindow.instance();
		blw.setBackHandler( this );
		blw.setItem( _item );
		blw.populate();
	}
	
	override public function createList():Void
	{
		var allItems:Vector<Item> = Globals.g_itemLibrary.allItems();
		var count:Int = allItems.length;
		for ( i in 0 ... count )
		{
			if ( allItems[i].category() == MartiniWindow )
				_items.push( allItems[i] );
		}
	}
}
