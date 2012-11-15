package com.drinkzage.windows;


import nme.events.MouseEvent;
import com.drinkzage.windows.TabConst;

/**
 * @author Robert Flesch
 */
class WineWindow extends ItemFinalWindow {
	
	private static var _instance:WineWindow = null;
	
	public static function instance():WineWindow
	{ 
		if ( null == _instance )
			_instance = new WineWindow();
			
		return _instance;
	}

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
}
