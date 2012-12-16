package com.drinkzage.windows;

import nme.events.MouseEvent;

/**
 * @author Robert Flesch
 */
class WineChoice extends ChoiceWindow
{
	private static var _instance:WineChoice = null;
	public static function instance():WineChoice
	{ 
		if ( null == _instance )
			_instance = new WineChoice();
		
		return _instance;
	}
	
	private function new () 
	{
		super();
		
		_tabs.push( "BACK" );

		_choiceButtons.push( new ChoiceButton( "Red", "wineRed.png" ) );
		_choiceButtons.push( new ChoiceButton( "White", "wineWhite.png" ) );
	}
	
	override private function choiceClickHandler( me:MouseEvent ):Void
	{
		var index:Int = me.target.name;
		trace( "WineChoice.choiceClickHandler: " + index );
		var window:WineListWindow = WineListWindow.instance();
		switch ( index )
		{
			case 0: // Red
				window.setType( WineCategory.Red );
			case 1: // White
				window.setType( WineCategory.White );
		}
		
		if ( null != window )
		{
			_em.removeAllEvents();
			window.setBackHandler( this );
			window.populate();
		}
	}
	
}
