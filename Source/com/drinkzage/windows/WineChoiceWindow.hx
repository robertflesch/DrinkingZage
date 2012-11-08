package com.drinkzage.windows;

import nme.events.MouseEvent;
import com.drinkzage.windows.Item;

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
		
		_tabs.push( "Back" );
		
		createList();
	}
	
	override public function createList():Void
	{
		_items.push ( new Item( "Red" ) );
		_items.push ( new Item( "White" ) );
		_items.push ( new Item( "Rose" ) );
		_items.push ( new Item( "Sparkling" ) );
	}
}


