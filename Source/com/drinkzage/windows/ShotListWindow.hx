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
		itemAdd ( new Item( "Jager Bomb" ) );
		itemAdd ( new Item( "Red Headed Slut" ) );
		itemAdd ( new Item( "Perfect Pussy" ) );
		itemAdd ( new Item( "Tequila" ) );
		itemAdd ( new Item( "Washington Apple" ) );
		itemAdd ( new Item( "Buttery Nipple" ) );
		itemAdd ( new Item( "Kamikaze" ) );
		itemAdd ( new Item( "Lemon Drops" ) );
		itemAdd ( new Item( "Irish Carbomb" ) );
		itemAdd ( new Item( "Purple Hooter" ) );
		itemAdd ( new Item( "Liquid Cocaine" ) );
	}
}
