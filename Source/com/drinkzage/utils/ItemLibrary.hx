package com.drinkzage.utils;

import haxe.Json;

import nme.Assets;
import nme.Vector;

import com.drinkzage.utils.DataPersistance;
import com.drinkzage.utils.DataPersistanceNull;

import com.drinkzage.windows.BeerWindow;
import com.drinkzage.windows.ContainerColor;
import com.drinkzage.windows.EmoteWindow;
import com.drinkzage.windows.Item;
import com.drinkzage.windows.ItemBeer;
import com.drinkzage.windows.ItemWine;
import com.drinkzage.windows.NonAlcoholicDrinkWindow;
import com.drinkzage.windows.NotDoneYetWindow;
import com.drinkzage.windows.ShotWindow;
import com.drinkzage.windows.WineWindow;
import com.drinkzage.windows.MartiniWindow;
import com.drinkzage.windows.TumblerWindow;


/**
 * @author Robert Flesch
 */
class ItemLibrary {
	
	private var _allItems( allItems, null ):Vector<Item>;
	public function allItems():Vector<Item> { return _allItems; }
	private var _dataPersistance:DataPersistanceNull = null;
	
	public function new () {
		
		Globals.g_itemLibrary = this;
		
		_allItems = new Vector<Item>();

#if ( flash || android )
		_dataPersistance = new DataPersistance();
#else		
		_dataPersistance = new DataPersistanceNull();
#end
		createList();
	}
	
	public function resetVisiblity( items:Vector<Item> ):Void
	{
		var count:Int = items.length;
		for ( i in 0...count )
		{
			items[i].setVisible( true );
		}
	}
	
	public function addItem( item:Item ):Void
	{
		_allItems.push( item );
	}

	private function createList():Void
	{
		var drinks : Dynamic;
		drinks = Json.parse(Assets.getText("assets/drinks.json"));

		var wineListSize:Int = drinks.wines.length;
		for ( i in 0 ... wineListSize )
		{
			addItem ( new ItemWine( drinks.wines[i].name, WineWindow, drinks.wines[i].color ) );
		}
		
		var nonAlcoholicDrinksListSize:Int = drinks.nonAlcoholicDrinks.length;
		for ( i in 0 ... nonAlcoholicDrinksListSize )
		{
			addItem ( new Item( drinks.nonAlcoholicDrinks[i].name, NonAlcoholicDrinkWindow ) );
		}
		
		var shotsListSize:Int = drinks.shots.length;
		for ( i in 0 ... shotsListSize )
		{
			addItem ( new Item( drinks.shots[i].name, ShotWindow ) );
		}
		
		var emotesListSize:Int = drinks.emotes.length;
		for ( i in 0 ... emotesListSize )
		{
			addItem ( new Item( drinks.emotes[i].name, EmoteWindow ) );
		}

		for ( i in 0 ... drinks.tumbler.length )
		{
			addItem ( new Item( drinks.tumbler[i].name, TumblerWindow ) );
		}
		
		for ( i in 0 ... drinks.martini.length )
		{
			addItem ( new Item( drinks.martini[i].name, MartiniWindow ) );
		}
		
		var commercial_beersListSize:Int = drinks.commercial_beers.length;
		for ( i in 0 ... commercial_beersListSize )
		{
			addItem ( new ItemBeer( drinks.commercial_beers[i].name
								  , BeerWindow
								  , drinks.commercial_beers[i].label
								  , drinks.commercial_beers[i].origin
								  , drinks.commercial_beers[i].container_color
								  , drinks.commercial_beers[i].beer_color
								  ) );
		}
		
		_allItems.sort( orderByName );
	}
	
	private function orderByName( item1:Item, item2:Item ):Int 
	{ 
		var name1:Int = item1.name().toLowerCase().charCodeAt(0);
		var name2:Int = item2.name().toLowerCase().charCodeAt(0);
		if (name1 < name2) 
		{ 
			return -1; 
		} 
		else if (name1 > name2) 
		{ 
			return 1; 
		} 
		else 
		{ 
			return 0; 
		} 
	}
	
	public function addCustomDrink( drinkType:String, name:String, val:String ):Void
	{
		var item:Item = new Item( name, drinkType );
		addItem( item );
		_dataPersistance.addEntry( "custom." + drinkType + "." + name, val );
		var test:String = _dataPersistance.getEntry( drinkType + "." + name );
		_dataPersistance.flush();
	}

	 
	public function isDrinkFavorite( item:Item ):Bool
	{
		var test:String = _dataPersistance.getEntry( "fav." + item.categoryName() + "." + item.name() );
		if ( "true" == test )
			return true;
		return false;
	}
	
	public function setItemAsFavorite( item:Item, favoriteOrNot:Bool ):Void
	{
		var test:String = _dataPersistance.getEntry( "fav." + item.categoryName() + "." + item.name() );
		if ( null != test )
		{
			if ( "true" == test )
				_dataPersistance.addEntry( "fav." + item.categoryName() + "." + item.name(), "false" );
			else
				_dataPersistance.addEntry( "fav." + item.categoryName() + "." + item.name(), "true" );
		}
		else 
		{
			_dataPersistance.addEntry( "fav." + item.categoryName() + "." + item.name(), "true" );
		}
	}
	
	private function storageTest():Void
	{
		/*
		trace("DrinkingZage.storageTest" );
		var so = SharedObject.getLocal( "storage-test" );
		// Load the values
		// Data.message is null the first time
		trace("DrinkingZage.storageTest data loaded: " + so.data.message );
		var count:Int = Std.parseInt( so.data.count );

		// Set the values
		so.data.message = "oh hello! [" + count + "]";
		so.data.count = count + 1 ;

		// Prepare to save.. with some checks
		#if ( cpp || neko )
			// Android didn't wanted SharedObjectFlushStatus not to be a String
			var flushStatus:SharedObjectFlushStatus = null;
		#else
			// Flash wanted it very much to be a String
			var flushStatus:String = null;
		#end

		try {
			flushStatus = so.flush() ;	// Save the object
		} catch ( e:Dynamic ) {
			trace("couldn't write...");
		}

		if ( flushStatus != null ) {
			switch( flushStatus ) {
				case SharedObjectFlushStatus.PENDING:
					trace("DrinkingZage.storageTest - requesting permission to save");
				case SharedObjectFlushStatus.FLUSHED:
					trace("DrinkingZage.storageTest - value saved");
			}
		}
		*/
	}
}
