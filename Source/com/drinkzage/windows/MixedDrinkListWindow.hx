package com.drinkzage.windows;

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

		_tabs.push( "Back" );
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
		_items.push ( new Item( "Margarita" ) );
		_items.push ( new Item( "Sex on the beach" ) );
		_items.push ( new Item( "Rum and Coke" ) );
		_items.push ( new Item( "Vodka and Cranberry" ) );
		_items.push ( new Item( "Vodka and Tonic" ) );
		_items.push ( new Item( "Salty Dog" ) );
		_items.push ( new Item( "Long Island Ice Tea" ) );
		_items.push ( new Item( "Screw Driver" ) );
		_items.push ( new Item( "Rum and Pineapple" ) );
		_items.push ( new Item( "Gin and Tonic" ) );
		_items.push ( new Item( "Tequila Sunrise" ) );
	}
}
