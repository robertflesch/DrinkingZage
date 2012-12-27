package com.drinkzage.windows;

import nme.Vector;
import com.drinkzage.windows.Item;

/**
 * @author Robert Flesch
 */
class EmoticonsPictureListWindow extends IListWindow
{
	private static var _instance:EmoticonsPictureListWindow = null;
	
	public static function instance():EmoticonsPictureListWindow
	{ 
		if ( null == _instance )
			_instance = new EmoticonsPictureListWindow();
			
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
		var blw: EmotePictureWindow = EmotePictureWindow.instance();
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
			if ( allItems[i].category() == EmotePictureWindow )
				_items.push( allItems[i] );
		}
	}
}


