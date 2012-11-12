package com.drinkzage.windows;


import nme.events.MouseEvent;
import com.drinkzage.windows.TabConst;

/**
 * @author Robert Flesch
 */
class NonAlcoholicDrinkWindow extends ItemFinalWindow {
	
	private static var _instance:NonAlcoholicDrinkWindow = null;
	
	public static function instance():NonAlcoholicDrinkWindow
	{ 
		if ( null == _instance )
			_instance = new NonAlcoholicDrinkWindow();
			
		return _instance;
	}

	//override public function populate( item:Item ):Void
	//{
		//_window.prepareNewWindow();
		//_item = item;
		//itemDraw();
		//countDraw();
		//_window.tabsDraw( _tabs, TabDefault.Back, tabHandler );
	//}
//
	public function new () 
	{
		super();
		_tabs.push( "BACK" );
	}
	
	override public function tabHandler( me:MouseEvent ):Void
	{
		if ( me.stageY >= Globals.g_app.tabHeight() + Globals.g_app.logoHeight() )
			return;
			
		backHandler();	
	}
	
	override public function backHandler():Void
	{
		super.backHandler();
		var blw: NonAlcoholicDrinks = NonAlcoholicDrinks.instance();
		blw.populate();
	}
	
}
