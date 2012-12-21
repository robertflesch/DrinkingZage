package com.drinkzage.utils;

/**
 * @author Robert Flesch
 */
class DataPersistanceNull  {
	
	public function new () 
	{
		trace( "DataPersistanceNull - new" );
	}

	public function flush():Void
	{
		
	}
		
	public function getEntry( key:String ):String
	{
		return "";
	}
	
	public function addEntry( key:String, val:String ):Void
	{
	}
	
	public function removeEntry( key:String ):Void
	{
	}
}
