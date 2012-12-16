package com.drinkzage.windows;

import nme.display.Stage;

import com.drinkzage.Globals;
import com.drinkzage.DrinkingZage;
import com.drinkzage.events.EventManager;

/**
 * @author Robert Flesch
 */
class IChildWindow
{
	private var _stage:Stage = null;
	private var _window:DrinkingZage = null;
	private var _em:EventManager = null;
	
	private function new () 
	{
		_stage = Globals.g_stage;
		_window = Globals.g_app;
		_em = new EventManager();
	}
}