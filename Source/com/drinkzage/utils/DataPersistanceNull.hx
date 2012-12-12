package com.drinkzage.utils;

/**
 * @author Robert Flesch
 */
class DataPersistanceNull  {
	
	public function new () 
	{
		trace( "DataPersistanceNull - new" );
	}

	public function addCustomDrink( drinkType:String, name:String, val:String ):Void
	{
		addEntry( drinkType + name, val );
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
