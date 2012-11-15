﻿package com.drinkzage.windows;

import com.drinkzage.Globals;
import nme.events.KeyboardEvent;

/**
 * @author Robert Flesch
 */
class IChildWindow
{
	private var _stage:Stage;
	private var _window:DrinkingZage;
	
	private var _backHandler(getBackHandler, setBackHandler):Dynamic = null;
	function getBackHandler():Dynamic { return _backHandler; }
	public function setBackHandler( val:Dynamic ):Dynamic { return _backHandler = val; }

	private function new () 
	{
		_backHandler = null;
		_stage = Globals.g_stage;
		_window = Globals.g_app;
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
		Globals.g_stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown );	
		trace( "IChildWindow.addListeners");
	}
	
	public function removeListeners():Void
	{
		Globals.g_stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown );				
		trace( "IChildWindow.removeListeners");
	}
	
	function onKeyDown( event:KeyboardEvent ):Void
	{
		if ( Globals.BACK_BUTTON == cast( event.keyCode, Int ) )
		{
			trace( "IChildWindow.onKeyDown - backHandler");
			backHandler();
			return;
		}
	}
	
	
}