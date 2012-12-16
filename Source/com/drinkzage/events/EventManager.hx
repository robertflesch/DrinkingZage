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

	// This is called by functions whose events have short lives
	// Like a mouse move message, which is just active after a mouse down has been processed
	public function removeEvent( target:EventDispatcher, type:String, listener:Dynamic->Void ):Void 
	{
		//trace( "EventManager.removeEvent - target: " + target + "  type: " + type + " eventSize: " + _events.length );
		// can be slow if lots of listeners, but works for now
		for ( e in 0..._events.length )
		{
			if ( _events[e]._target == target 
			&& _events[e]._type == type
			&& _events[e]._listener == listener )
			{
				_events[e].dispose();
				_events.splice( e, 1 );
				return;
			}
		}
	}
	
	public function removeAllEvents():Void 
	{
		//trace( "EventManager.removeAllEvents" );
		while ( 0 < _events.length )
		{
			var eo:EventObject = _events.pop();
			eo.dispose();
		}
	}
}
