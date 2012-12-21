package com.drinkzage;
import nme.display.Stage;
import com.drinkzage.utils.ItemLibrary;
import nme.Vector;

class Globals
{
public static var g_app:DrinkingZage = null;
public static var g_stage:Stage = null;
public static var g_itemLibrary:ItemLibrary = null;

public static inline var BACK_BUTTON:Int = 27; // keyboard.keycode looks like an Int, but compiler thinks its a UInt.. RSF 11.8.12

public static inline var COLOR_SAGE:Int = 0x21919d;
public static inline var COLOR_WHITE:Int = 0xffffff;
}
