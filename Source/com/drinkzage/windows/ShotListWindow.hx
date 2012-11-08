package com.drinkzage.windows;

import Std;

import nme.Assets;
import nme.Lib;
import nme.Vector;

import nme.display.Sprite;
import nme.display.Stage;

import nme.events.MouseEvent;
import nme.events.Event;

import nme.filters.GlowFilter;

import nme.text.TextField;
import nme.text.TextFormat;
import nme.text.TextFormatAlign;

import nme.ui.Mouse;
import nme.events.TimerEvent;
import com.drinkzage.windows.Item;
import com.drinkzage.windows.ITabListWindow;
import com.drinkzage.windows.ListWindowConsts;

import com.drinkzage.Globals;
import com.drinkzage.utils.Utils;

/**
 * @author Robert Flesch
 */
class ShotListWindow extends ITabListWindow
{
	
	private static var _instance:ShotListWindow = null;
	
	public static function instance():ShotListWindow
	{ 
		if ( null == _instance )
			_instance = new ShotListWindow();
			
		return _instance;
	}

	private function new () {
		super();
		
		_tabs.push( "Back" );
		
		createList();
	}
	
	override private function backHandler():Void
	{
		super.backHandler();
		var blw: LiquorChoice = LiquorChoice.instance();
		blw.populate();
	}
	
	
	override public function selectionHandler():Void
	{
		removeListeners();
		var blw: ShotWindow = ShotWindow.instance();
		blw.populate( _item );
	}
	
	override public function createList():Void
	{
		_items.push ( new Item( "Jager Bomb" ) );
		_items.push ( new Item( "Red Headed Slut" ) );
		_items.push ( new Item( "Perfect Pussy" ) );
		_items.push ( new Item( "Tequila" ) );
		_items.push ( new Item( "Washington Apple" ) );
		_items.push ( new Item( "Buttery Nipple" ) );
		_items.push ( new Item( "Kamikaze" ) );
		_items.push ( new Item( "Lemon Drops" ) );
		_items.push ( new Item( "Irish Carbomb" ) );
		_items.push ( new Item( "Purple Hooter" ) );
		_items.push ( new Item( "Liquid Cocaine" ) );
	}
}
