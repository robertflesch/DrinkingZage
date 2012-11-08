package com.drinkzage.windows;

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
		
		_tabs.push( "Back" );
		
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
		NotDoneYetWindow.instance().populate(null);
	}
	
	override public function createList():Void
	{
		_items.push ( new Item( "Like" ) );
		_items.push ( new Item( "Love" ) );
		_items.push ( new Item( "Lets go to my place" ) );
		_items.push ( new Item( "Can I get you a drink" ) );
		_items.push ( new Item( "20 most original lines" ) );
		_items.push ( new Item( "20 lines to make them laugh" ) );
		_items.push ( new Item( "20 lines to shock them" ) );
	}
}


