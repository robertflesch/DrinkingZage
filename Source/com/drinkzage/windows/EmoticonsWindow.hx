﻿package com.drinkzage.windows;

import nme.Vector;
import com.drinkzage.windows.Item;

/**
 * @author Robert Flesch
 */
class EmoticonsWindow extends IListWindow
{
	private static var _instance:EmoticonsWindow = null;
	
	public static function instance():EmoticonsWindow
	{ 
		if ( null == _instance )
			_instance = new EmoticonsWindow();
			
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
		var blw: EmoteWindow = EmoteWindow.instance();
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
			if ( allItems[i].category() == EmoteWindow )
				_items.push( allItems[i] );
		}
	}
}


