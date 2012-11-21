﻿package com.drinkzage.windows;


import nme.events.MouseEvent;
import com.drinkzage.windows.TabConst;

/**
 * @author Robert Flesch
 */
class MixedDrinkWindow extends ItemFinalWindow {
	
	private static var _instance:MixedDrinkWindow = null;
	
	public static function instance():MixedDrinkWindow
	{ 
		if ( null == _instance )
			_instance = new MixedDrinkWindow();
			
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
}
