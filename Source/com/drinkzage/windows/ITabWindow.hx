package com.drinkzage.windows;

import nme.Vector;

import nme.events.MouseEvent;
import nme.events.KeyboardEvent;

import com.drinkzage.Globals;
import com.drinkzage.windows.TabConst;

/**
 * @author Robert Flesch
 */
class ITabWindow extends IChildWindow
{
	private var _tabs:Vector<String>;
	private var _tabSelected:Dynamic;
	private var _useSearch ( getUseSearch, setUseSearch ):Bool = true;
	function getUseSearch():Bool { return _useSearch; }
	function setUseSearch( val:Bool ):Bool { return _useSearch = val; }

	private var _backHandler(getBackHandler, setBackHandler):Dynamic = null;
	function getBackHandler():Dynamic { return _backHandler; }
	public function setBackHandler( val:Dynamic ):Dynamic { return _backHandler = val; }

	private function new () 
	{
		_backHandler = null;
		_tabs = new Vector<String>();
		_tabSelected = TabDefault.Back;
		
		super();
	}
	
	public function populate():Void
	{
		_window.prepareNewWindow();		
		_window.tabsDraw( _tabs, _tabSelected, tabHandler );
		
		if ( getUseSearch() )
			_window.searchDraw();
	}
	
	private function tabHandler( me:MouseEvent ):Void
	{
		if ( me.stageY >= Globals.g_app.tabHeight() + Globals.g_app.logoHeight() )
			return;
		
		backHandler();
	}
	
	public function backHandler():Void 
	{ 
		removeListeners();
		if ( null == _backHandler )
			trace( "IChildWindow.backHandler - ERROR - MISSING" );
		_backHandler.populate(); 
	}
	
	public function addListeners():Void
	{
		_stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp );	
	}
	
	public function removeListeners():Void
	{
		_stage.removeEventListener(KeyboardEvent.KEY_UP, onKeyUp );				
	}
	
	function onKeyUp( event:KeyboardEvent ):Void
	{
		if ( Globals.BACK_BUTTON == event.keyCode )
		{
			backHandler();
			event.stopImmediatePropagation();
		}
	}
}

