package com.drinkzage.windows;

import nme.Vector;

import nme.Assets;

import nme.display.Sprite;
import nme.display.Bitmap;
import nme.display.Stage;

import nme.events.MouseEvent;
import nme.events.Event;

import com.drinkzage.utils.Utils;
import com.drinkzage.windows.IListWindow;
import com.drinkzage.windows.ListWindowConsts;
import com.drinkzage.windows.EmoticonsPictureListWindow;
import com.drinkzage.windows.ChoiceButton;
import com.drinkzage.windows.AboutWindow;

/**
 * @author Robert Flesch
 */
class EmoteChoiceWindow extends ChoiceWindow
{
	private static var _instance:EmoteChoiceWindow = null;
	public static function instance():EmoteChoiceWindow
	{ 
		if ( null == _instance )
			_instance = new EmoteChoiceWindow();
		
		return _instance;
	}
	
	private function new () 
	{
		super();
		
		_tabs.push( "BACK" );

		_choiceButtons.push( new ChoiceButton( "Icons", "emote.png" ) );
		_choiceButtons.push( new ChoiceButton( "Lines", "lines.png" ) );
		_choiceButtons.push( new ChoiceButton( "About", "about.png" ) );
	}
	
	override private function choiceClickHandler( me:MouseEvent ):Void
	{
		var index:Int = me.target.name;
		trace( "EmoteChoiceWindow.choiceClickHandler: " + index );
		var window:ITabWindow = null;
		switch ( index )
		{
			case 0: // 
				window = EmoticonsPictureListWindow.instance();
			case 1: // 
				window = EmoticonsWindow.instance();
			case 2: // 
				window = AboutWindow.instance();
				cast( window, ItemFinalWindow).setItem( new Item( "About", null ) );
		}
		
		if ( null != window )
		{
			_em.removeAllEvents();
			window.setBackHandler( this );
			window.populate();
		}
	}
}
