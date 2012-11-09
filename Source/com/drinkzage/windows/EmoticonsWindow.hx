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
		itemAdd ( new Item( "Like" ) );
		itemAdd ( new Item( "Love" ) );
		itemAdd ( new Item( "Lets go to my place" ) );
		itemAdd ( new Item( "Can I get you a drink" ) );
		itemAdd ( new Item( "20 most original lines" ) );
		itemAdd ( new Item( "20 lines to make them laugh" ) );
		itemAdd ( new Item( "20 lines to shock them" ) );
	}
}


