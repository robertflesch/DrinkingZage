package com.drinkzage.windows;

import nme.Vector;

import nme.Assets;

import nme.display.Sprite;
import nme.display.Bitmap;
import nme.display.Stage;

import nme.events.MouseEvent;
import nme.events.Event;

import com.drinkzage.utils.Utils;
import com.drinkzage.windows.IListWindow;

/**
 * @author Robert Flesch
 */

class ChoiceButton
{
	public var _text:String;
	public var _image:String;
	
	public function new( text:String, image:String )
	{
		_text = text;
		_image = image;
	}
}

