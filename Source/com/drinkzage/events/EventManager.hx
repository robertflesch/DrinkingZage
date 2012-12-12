package com.drinkzage.events;

import nme.events.EventDispatcher;

import com.drinkzage.events.EventObject;

/**
 * @author Robert Flesch
 */
class EventManager
{
	private var _events:Array<EventObject> = null;
	public function new () 
	{
		_events = new Array<EventObject>();
	}
	
	public function addEvent( target:EventDispatcher, type:String, listener:Dynamic->Void, useCapture:Bool = false, add:Bool = false):Void 
	{
		//trace( "EventManager.addEvent - target: " + target + "  type: " + type );
		var eo:EventObject = new EventObject( target, type, listener, useCapture, add );
		_events.push( eo );
	}

	public function removeEvent( target:EventDispatcher, type:String, listener:Dynamic->Void ):Void 
	{
		//trace( "EventManager.removeEvent - target: " + target + "  type: " + type );
		// can be slow if lots of listeners, but works for now
		for ( e in 0..._events.length )
		{
			if ( _events[e]._target == target 
			&& _events[e]._type == type
			&& _events[e]._listener == listener )
			{
				_events[e].dispose();
			}
		}
	}
	
	public function removeAllEvents():Void 
	{
		//trace( "EventManager.removeAllEvents" );
		while ( 0 < _events.length )
		{
			_events.pop().dispose();
		}
	}
}
