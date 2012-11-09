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
		itemAdd ( new Item( "Margarita" ) );
		itemAdd ( new Item( "Sex on the beach" ) );
		itemAdd ( new Item( "Rum and Coke" ) );
		itemAdd ( new Item( "Vodka and Cranberry" ) );
		itemAdd ( new Item( "Vodka and Tonic" ) );
		itemAdd ( new Item( "Salty Dog" ) );
		itemAdd ( new Item( "Long Island Ice Tea" ) );
		itemAdd ( new Item( "Screw Driver" ) );
		itemAdd ( new Item( "Rum and Pineapple" ) );
		itemAdd ( new Item( "Gin and Tonic" ) );
		itemAdd ( new Item( "Tequila Sunrise" ) );
	}
}
