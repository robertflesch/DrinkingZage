package com.drinkzage.windows;


import nme.events.MouseEvent;

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

	public function new () 
	{
		super();
		_tabs.push( "BACK" );
	}
}
