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

	public function new () 
	{
		super();
		_tabs.push( "BACK" );
	}
}
