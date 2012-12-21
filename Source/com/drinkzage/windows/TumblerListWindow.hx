package com.drinkzage.windows;

import nme.Vector;


/**
 * @author Robert Flesch
 */
class TumblerListWindow extends IListWindow
{
	
	private static var _instance:TumblerListWindow = null;
	
	public static function instance():TumblerListWindow
	{ 
		if ( null == _instance )
			_instance = new TumblerListWindow();
			
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
		var blw: TumblerWindow = TumblerWindow.instance();
		blw.setBackHandler( this );
		blw.setItem( _item );
		blw.populate();
	}
	
	override public function createList():Void
	{
		trace( "TumblerListWindow.createList - start" );
		var allItems:Vector<Item> = Globals.g_itemLibrary.allItems();
		var count:Int = allItems.length;
		for ( i in 0 ... count )
		{
			if ( allItems[i].category() == TumblerWindow )
				_items.push( allItems[i] );
		}
		trace( "TumblerListWindow.createList - end" );
	}
}
