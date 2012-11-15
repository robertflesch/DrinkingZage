package com.drinkzage.windows;

import nme.Vector;

import com.drinkzage.Globals;
import com.drinkzage.windows.IChildWindow;

/**
 * @author Robert Flesch
 */
class IListWindow extends IChildWindow
{
	private var _items:Vector<Item> = null;

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
		super();
		
		if ( null == _items )
		{
			_items = new Vector<Item>();
		}
		
		_maxOffset = _items.length * Globals.g_app.componentHeight() - (_stage.stageHeight - Globals.g_app.tabHeight() - Globals.g_app.logoHeight());
		_maxOffset += Globals.g_app.tabHeight() + ListWindowConsts.FUDGE_FACTOR; // Fudge factor
	}
	
	public function createList():Void {}
	
	public function populate():Void
	{
		_clickPoint = 0.0;
		_change = 0.0;
		_drag = false;
		
		removeListeners();
		addListeners();
		_window.prepareNewWindow();		
	}
}