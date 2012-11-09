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

import com.drinkzage.Globals;
import com.drinkzage.DrinkingZage;

/**
 * @author Robert Flesch
 */
class IListWindow 
{
	private var _items:Vector<Item> = null;
	private var _stage:Stage;
	private var _window:DrinkingZage;

	private var _listOffset ( getListOffset, setListOffset ):Float = 0;
	function getListOffset():Float { return _listOffset; }
	function setListOffset( val:Float ):Float { return _listOffset = val; }
	
	private var _clickPoint:Float = 0;
	private var _change:Float = 0;
	private var _drag:Bool = false;
	private var _maxOffset:Float = 0;
	private var _time:Int = 0;
	private var _swipeSpeed:Float = 0;
	
	private function new () {
		_stage = Globals.g_stage;
		_window = Globals.g_app;
		
		if ( null == _items )
		{
			_items = new Vector<Item>();
		}
		
		_maxOffset = _items.length * Globals.g_app.componentHeight() - (_stage.stageHeight - Globals.g_app.tabHeight() - Globals.g_app.logoHeight());
		_maxOffset += Globals.g_app.tabHeight() + ListWindowConsts.FUDGE_FACTOR; // Fudge factor
	}
	
	public function addListeners():Void {}
	public function removeListeners():Void {}
	public function createList():Void {}
	
	public function populate():Void
	{
		_clickPoint = 0.0;
		_change = 0.0;
		_drag = false;
		
		addListeners();
		_window.prepareNewWindow();		
	}

	public function itemAdd( item:Item ):Void
	{
		_items.push ( item );
		Globals.g_app.addItem( item );
	}
}