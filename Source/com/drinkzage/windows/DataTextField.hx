package com.drinkzage.windows;

import nme.text.TextField;

/**
 * @author Robert Flesch
 */
class DataTextField extends TextField
{
	private var _data ( getData, setData ):Dynamic = null;
	public function getData():Dynamic { return _data; }
	public function setData( val:Dynamic ):Float { return _data = val; }
	
}