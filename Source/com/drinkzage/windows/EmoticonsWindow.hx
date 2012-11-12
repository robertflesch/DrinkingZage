package com.drinkzage.windows;

import nme.Vector;
import nme.events.MouseEvent;

import com.drinkzage.windows.Item;

/**
 * @author Robert Flesch
 */
class EmoticonsWindow extends ITabListWindow
{
	private static var _instance:EmoticonsWindow = null;
	
	public static function instance():EmoticonsWindow
	{ 
		if ( null == _instance )
			_instance = new EmoticonsWindow();
			
		return _instance;
	}
	
	public function new () 
	{
		super();
		
		_tabs.push( "BACK" );
		
		createList();
	}
	
	override private function tabHandler( me:MouseEvent ):Void
	{
		if ( me.stageY >= Globals.g_app.tabHeight() + Globals.g_app.logoHeight() )
			return;
			
		backHandler();
	}
			
	override public function selectionHandler():Void
	{
		removeListeners();
		var blw: EmoteWindow = EmoteWindow.instance();
		blw.populate( _item );
	}
	
	
	override public function createList():Void
	{
		var allItems:Vector<Item> = _window.getAllItems();
		var count:Int = allItems.length;
		for ( i in 0 ... count )
		{
			if ( allItems[i].category() == EmoteWindow )
				_items.push( allItems[i] );
		}
	}
}


