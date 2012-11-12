package com.drinkzage.windows;

import Std;

import nme.Lib;
import nme.Vector;
import nme.Assets;

import nme.display.Sprite;
import nme.display.Bitmap;
import nme.display.StageAlign;
import nme.display.StageQuality;
import nme.display.StageScaleMode;
import nme.display.LoaderInfo;
import nme.display.Stage;

import nme.events.MouseEvent;
import nme.events.Event;

import nme.filters.GlowFilter;

import nme.geom.Vector3D;

import nme.text.TextField;
import nme.text.TextFormat;
import nme.text.TextFormatAlign;

import com.drinkzage.windows.BeerListWindow;
import com.drinkzage.utils.Utils;
import com.drinkzage.windows.LogoConsts;

/**
 * @author Robert Flesch
 */
class NonAlcoholicDrinks extends ITabListWindow
{
	private static var _instance:NonAlcoholicDrinks = null;
	
	public static function instance():NonAlcoholicDrinks
	{ 
		if ( null == _instance )
			_instance = new NonAlcoholicDrinks();
			
		return _instance;
	}
	
	public function new () 
	{
		super();
		
		_tabs.push( "BACK" );
		
		createList();
	}
	
	override private function tabHandler( me:MouseEvent ):Void
	{
		if ( me.stageY >= Globals.g_app.tabHeight() + Globals.g_app.logoHeight() )
			return;
			
		backHandler();
	}

	override public function selectionHandler():Void
	{
		removeListeners();
		var blw: NonAlcoholicDrinkWindow = NonAlcoholicDrinkWindow.instance();
		blw.populate( _item );
	}
	
	override public function createList():Void
	{
		var allItems:Vector<Item> = _window.getAllItems();
		var count:Int = allItems.length;
		for ( i in 0 ... count )
		{
			if ( allItems[i].category() == NonAlcoholicDrinkWindow )
				_items.push( allItems[i] );
		}
	}
}


