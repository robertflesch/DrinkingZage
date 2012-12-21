package com.drinkzage.utils;

import nme.Lib;
import nme.Vector;
import com.drinkzage.Globals;
import com.drinkzage.windows.Item;
import nme.net.SharedObject;
import nme.net.SharedObjectFlushStatus;

/**
 * @author Robert Flesch
 */
class DataPersistance extends DataPersistanceNull  
{
	private var _so:SharedObject = null;
	
	public function new () 
	{
		super();
		trace("DataPersistance.new - opening: drinkdata" );
		open( "drinkdata" );
				
		trace( "--- start current data-----" );
		trace( expandAsString(_so.data) );
		trace( "--- end current data-----" );
		var iter:Iterator<String>=Reflect.fields(_so.data).iterator();
		for (i in iter)
		{
			trace( i );
		}
		var time = Lib.getTimer();
		
		var items:Vector<Item> = Globals.g_itemLibrary.allItems();
		//for ( j in 0...1000 )
		//{
		//for ( i in items )
		//{
			//trace( i );
		//}
		//}
		var endTime:Float = Lib.getTimer() - time;
		trace( "thousand loops: " + endTime );
		
		//storageTest();
	}

	public function open( val:String ):Void
	{
		if ( null == _so )
			_so = SharedObject.getLocal( val );
	}
	
	override public function flush():Void
	{
		// Prepare to save.. with some checks
		#if ( cpp || neko )
			// Android didn't wanted SharedObjectFlushStatus not to be a String
			var flushStatus:SharedObjectFlushStatus = null;
		#else
			// Flash wanted it very much to be a String
			var flushStatus:String = null;
		#end
		
		try {
			flushStatus = _so.flush() ;	// Save the object
		} catch ( e:Dynamic ) {
			trace("couldn't write...");
		}

		if ( flushStatus != null ) {
			switch( flushStatus ) {
				case SharedObjectFlushStatus.PENDING:
					trace("DataPersistance.storageTest - requesting permission to save");
				case SharedObjectFlushStatus.FLUSHED:
					trace("DataPersistance.storageTest - value saved");
			}
		}
	}
	
	override public function getEntry( key:String ):String
	{
		var result:String = Reflect.field(_so.data, key);
//		if ( "undefined" == result || null == result )
//			trace ("DataPersistance.getEntry ERROR ERROR - no value found for key: " + key );
//		else
//			trace( "DataPersistance.getEntry: " + key + " found: " + result );
		return result;
	}
	
	override public function addEntry( key:String, val:String ):Void
	{
		Reflect.setProperty( _so.data, key, val );
	}
	
	override public function removeEntry( key:String ):Void
	{
		Reflect.setProperty( _so.data, key, null );
	}
	
	private static function expandAsString(obj:Dynamic):String
	{
		if (obj==null)
		{
			return null;
		}

		var str:String="{";
		var iter:Iterator<String>=Reflect.fields(obj).iterator();
		for (i in iter)
		{
			str+=i+"="+Reflect.field(obj,i);
			if (iter.hasNext())
			{
				str+=",";
			}
		}
		str+="}";

		return str;
	}

	private function storageTest():Void
	{
//		trace("DataPersistance.storageTest" );
		
		open( "storage-test" );
		
		_so.clear();
		trace( expandAsString( _so.data ) );
		
		//var entry:String = getEntry( "wine.cheap" );
		//if ( null == entry )
		//{
			//addEntry( "wine.cheap", "CWW1" );
		//}
		//
		//entry = getEntry( "wine.expensive" );
		//if ( null == entry )
		//{
			//addEntry( "wine.expensive", "EWW1" );
		//}
		//
		//removeEntry( "wine.cheap" );
		//entry = getEntry( "FirstTest" );
		//
		// Load the values
		// Data.message is null the first time
		//trace("DataPersistance.storageTest data loaded: " + _so.data.message );
		//var count:Int = Std.parseInt( _so.data.count );
//
		// Set the values
		//_so.data.message = "oh hello! [" + count + "]";
		//_so.data.count = count + 1 ;
		//
		//trace( expandAsString( _so.data ) );
		
		flush();
	}
}
