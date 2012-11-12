package com.drinkzage.windows;

import nme.Vector;
import nme.events.MouseEvent;

import com.drinkzage.windows.Item;

/**
 * @author Robert Flesch
 */
class MixedDrinkListWindow extends ITabListWindow
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
	
	override private function tabHandler( me:MouseEvent ):Void
	{
		if ( me.stageY >= Globals.g_app.tabHeight() + Globals.g_app.logoHeight() )
			return;
		
		backHandler();
	}
	
	override private function backHandler():Void
	{
		super.backHandler();
		var blw: LiquorChoice = LiquorChoice.instance();
		blw.populate();
	}
	
	override public function selectionHandler():Void
	{
		removeListeners();
		var blw: MixedDrinkWindow = MixedDrinkWindow.instance();
		blw.populate( _item );
	}
	
	override public function createList():Void
	{
		var allItems:Vector<Item> = _window.getAllItems();
		var count:Int = allItems.length;
		for ( i in 0 ... count )
		{
			if ( allItems[i].category() == MixedDrinkWindow )
				_items.push( allItems[i] );
		}
	}
}
