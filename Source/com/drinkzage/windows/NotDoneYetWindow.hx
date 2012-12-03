package com.drinkzage.windows;

import com.drinkzage.Globals;
import nme.display.Sprite;
import nme.display.Stage;

import nme.events.MouseEvent;
import nme.events.Event;
import nme.errors.Error;

import nme.text.TextField;
import nme.text.TextFormat;
import nme.text.TextFormatAlign;
import nme.text.Font;

import nme.filters.GlowFilter;
import nme.Assets;

import com.drinkzage.windows.Item;

import com.drinkzage.utils.Utils;

/**
 * @author Robert Flesch
 */
class NotDoneYetWindow extends ItemFinalWindow {
	
	private static var _instance:NotDoneYetWindow = null;
	
	public static function instance():NotDoneYetWindow
	{ 
		if ( null == _instance )
			_instance = new NotDoneYetWindow();
			
		return _instance;
	}


	public function new () 
	{
		super();
		
		_tabs.push( "BACK" );
	}
	
	override public function populate():Void
	{
		_item = new Item( "Not Done Yet", null );
		setItem( _item );
		super.populate();
	}
}
