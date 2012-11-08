package com.drinkzage.windows;

import com.drinkzage.Globals;
import nme.events.MouseEvent;
import com.drinkzage.windows.TabConst;


/**
 * @author Robert Flesch
 */
class ShotWindow extends ItemFinalWindow {
	
	private static var _instance:ShotWindow = null;
	
	public static function instance():ShotWindow
	{ 
		if ( null == _instance )
			_instance = new ShotWindow();
			
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
		_tabs.push( "Back" );
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
		var blw: ShotListWindow = ShotListWindow.instance();
		blw.populate();
	}
}
