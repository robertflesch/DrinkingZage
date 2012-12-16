package com.drinkzage.events;

import nme.events.Event;
import nme.events.EventDispatcher;


/**
 * @author Robert Flesch
 */

class EventObject
{
	public var _target:EventDispatcher = null;
	public var _type:String;
	public var _listener:Dynamic->Void = null;
	private var _useCapture:Bool = false;
	private var _add:Bool = false;
	
	public function new( target:EventDispatcher, type:String, listener:Dynamic->Void, useCapture:Bool, add:Bool ):Void 
	{
		_target = target;
		_type = type;
		_listener = listener;
		_useCapture = useCapture;
		_add = add;
		
		target.addEventListener( type, listener, useCapture, 0, add );
	}
	
	public function dispose():Void
	{
		//trace( "EventObject.dispose - type: " + _type + "   listener: " + _listener );
		_target.removeEventListener( _type, _listener );
	}
}