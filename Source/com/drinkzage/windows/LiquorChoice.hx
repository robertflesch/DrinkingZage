package com.drinkzage.windows;

import nme.display.Sprite;

import nme.events.MouseEvent;

import com.drinkzage.windows.IListWindow;

/**
 * @author Robert Flesch
 */
class LiquorChoice extends ChoiceWindow
{
	private static var _instance:LiquorChoice = null;
	public static function instance():LiquorChoice
	{ 
		if ( null == _instance )
			_instance = new LiquorChoice();
		
		return _instance;
	}
	
	public function new () 
	{
		super();
		
		_tabs.push( "BACK" );

		_choiceButtons.push( new ChoiceButton( "Shot", "shot.png" ) );
		_choiceButtons.push( new ChoiceButton( "Tumbler", "tumbler.png" ) );
		_choiceButtons.push( new ChoiceButton( "Martini", "martini.png" ) );
	}
	
	override private function choiceClickHandler( me:MouseEvent ):Void
	{
		var index:Int = me.target.name;
		trace( "LiquorChoice.choiceClickHandler: " + index );
		var window:IListWindow = null;
		switch ( index )
		{
			case 0: // Shots
				window = ShotListWindow.instance();
			case 1: // Tumbler
				window = TumblerListWindow.instance();
			case 2: // Mixed Drinks
				window = MartiniListWindow.instance();
		}
		
		if ( null != window )
		{
			_em.removeAllEvents();
			window.setBackHandler( this );
			window.populate();
		}
	}
	
}
