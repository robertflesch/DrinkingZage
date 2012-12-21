package com.drinkzage.windows;

import com.drinkzage.DrinkingZage;
import nme.events.MouseEvent;
import com.drinkzage.windows.Item;
import nme.Vector;
import com.drinkzage.windows.IListWindow;

/**
 * @author Robert Flesch
 */
class FavoritesWindow extends IListWindow
{
	private static var _instance:FavoritesWindow = null;
	
	public static function instance():FavoritesWindow
	{ 
		if ( null == _instance )
			_instance = new FavoritesWindow();
			
		return _instance;
	}
	
	public function new () 
	{
		super();
		
		_tabs.push( "BACK" );
		
		createList();
	}
	
	override public function createList():Void
	{
		var allItems:Vector<Item> = Globals.g_itemLibrary.allItems();
		var count:Int = allItems.length;
		for ( i in 0 ... count )
		{
			if ( true == allItems[i].fav()  )
				_items.push( allItems[i] );
		}
	}
	
	override public function populate():Void
	{
		resetItems();
		createList();
		super.populate();
	}
	
	override private function favoriteToggle( event:MouseEvent ):Void
	{
		super.favoriteToggle( event );
		resetItems();
		createList();
		listDraw( _listOffset, true );
	}

	override public function selectionHandler():Void
	{
		trace( "FavoritesWindow.selectionHandler" );		
		//if ( _clickPoint > _searchText.y )
				//return;
			
		var window:ItemFinalWindow = null;
		if ( EmoteWindow == _item.category() )
		{
			window = EmoteWindow.instance();
		}
		else if ( WineWindow == _item.category() )
		{
			window = WineWindow.instance();
		}
		else if ( NonAlcoholicDrinkWindow == _item.category() )
		{
			window = NonAlcoholicDrinkWindow.instance();
		}
		else if ( BeerWindow == _item.category() )
		{
			window = BeerWindow.instance();
		}
		else if ( ShotWindow == _item.category() )
		{
			window = ShotWindow.instance();
		}
		else if ( TumblerWindow == _item.category() )
		{
			window = TumblerWindow.instance();
		}
		else if ( MartiniWindow == _item.category() )
		{
			window = MartiniWindow.instance();
		}
		
		if ( null != window )
		{
			_em.removeAllEvents();
			window.setBackHandler( this );
			window.setItem( _item );
			window.populate();
		}
		else
			trace( "FavoritesWindow.selectionHandler - ERROR - no category found" );
		
	}

}


