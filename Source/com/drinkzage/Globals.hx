package com.drinkzage;
import nme.display.Stage;
import nme.Vector;

class Globals
{
public static var g_app:DrinkingZage = null;
public static var g_stage:Stage = null;
public static var BACK_BUTTON:Int = 27; // keyboard.keycode looks like an Int, but compiler thinks its a UInt.. RSF 11.8.12
}
