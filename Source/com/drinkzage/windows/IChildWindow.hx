package com.drinkzage.windows;

import nme.events.Event;
import nme.events.EventDispatcher;
import nme.events.KeyboardEvent;
import nme.display.Stage;

import com.drinkzage.Globals;
import com.drinkzage.DrinkingZage;

/**
 * @author Robert Flesch
 */
class IChildWindow
{
	private var _stage:Stage;
	private var _window:DrinkingZage;
	
	private function new () 
	{
		_stage = Globals.g_stage;
		_window = Globals.g_app;
	}
}