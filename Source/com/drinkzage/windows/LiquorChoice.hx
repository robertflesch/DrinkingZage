package com.drinkzage.windows;

import nme.Vector;

import nme.display.Sprite;
import nme.display.Bitmap;
import nme.display.Stage;

import nme.events.MouseEvent;
import nme.events.Event;

import com.drinkzage.utils.Utils;
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
	}
	
	override private function choiceClickHandler( me:MouseEvent ):Void
	{
		var index:Int = me.target.name;
		switch ( index )
		{
			case 0: // Shots
				_em.removeAllEvents();
				var slw:ShotListWindow = ShotListWindow.instance();
				slw.setBackHandler( this );
				slw.populate();
			case 1: // Mixed Drinks
				_em.removeAllEvents();
				var mlw:MixedDrinkListWindow = MixedDrinkListWindow.instance();
				mlw.setBackHandler( this );
				mlw.populate();
		}
	}
	
	override public function createList():Void
	{
		_choiceButtons.push( new ChoiceButton( "Shot", "shot.png" ) );
		_choiceButtons.push( new ChoiceButton( "Tumbler", "tumbler.png" ) );
		_choiceButtons.push( new ChoiceButton( "Martini", "martini.png" ) );
	}
}
