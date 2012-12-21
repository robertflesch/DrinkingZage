package com.drinkzage.windows;

import Std;

import nme.Assets;
import nme.Lib;
import nme.Vector;

import nme.display.Sprite;
import nme.display.Stage;
import nme.display.DisplayObject;

import nme.events.MouseEvent;
import nme.events.Event;

import nme.text.TextField;
import nme.text.TextFormat;
import nme.text.TextFormatAlign;

import nme.ui.Mouse;
import nme.events.TimerEvent;
import com.drinkzage.windows.Item;
import com.drinkzage.windows.IListWindow;
import com.drinkzage.windows.ListWindowConsts;

import com.drinkzage.Globals;
import com.drinkzage.utils.Utils;
/**
 * @author Robert Flesch
 */
class BeerListWindow extends IListWindow
{
	
	private static var _instance:BeerListWindow = null;
	private static var _lastCategory:BeerCategory = null;
	
	public static function instance():BeerListWindow
	{ 
		if ( null == _instance )
		{
			_instance = new BeerListWindow();
			//trace( "BeerListWindow.INSTANIAITE" );
		}
			
		return _instance;
	}

	private function new () 
	{
		super();
		
		_tabs.push( "All" );
		_tabs.push( "U.S." );
		_tabs.push( "Import" );
		_tabs.push( "Local" );
		_tabs.push( "BACK" );
		_tabSelected = BeerCategory.All;

		createList();
	}
	
	override public function populate():Void
	{
		// todo - BUG BUG BUG This should not be required
		// but if its not here, then only some of the items show up
		// when returning to this window
		_tabSelected = BeerCategory.All;
		
		super.populate();
	}
	//
	///////////////////////////////////////////////////////////////
	// overides 
	///////////////////////////////////////////////////////////////
	
	override private function tabHandler( me:MouseEvent ):Void
	{
		//trace( "BeerListWindow.tabHandler" );
		if ( me.stageY >= tabHeight() + logoHeight() )
			return;
		
		var index:Int = me.target.name;
		switch ( index )
		{
			case 0: // All
				_tabSelected = BeerCategory.All;
			case 1: // ..
				_tabSelected = BeerCategory.Domestic;
			case 2: // ..
				_tabSelected = BeerCategory.Import;
			case 3: // ..
				_tabSelected = BeerCategory.Local;
			case 4: // Back
				backHandler();
				return;
		}
		listDraw( _listOffset, false );
		tabsRefresh();
	}

	override private function applyFilter():Void
	{
		Globals.g_itemLibrary.resetVisiblity( _items );

		var count:Int = _items.length;
		for ( i in 0...count )
		{
			var item:Item = cast( _items[i], ItemBeer );
			if ( BeerCategory.All != _tabSelected && cast( item, ItemBeer ).beerCategory != _tabSelected )
				_items[i].setVisible( false );
		}
	}
	
	override public function selectionHandler():Void
	{
		//trace( "BeerListWindow.selectionHandler" );
		//removeListeners();
		_em.removeAllEvents();
		var bw:BeerWindow = BeerWindow.instance();
		bw.setBackHandler( this );
		bw.setItem( cast( _item, ItemBeer ) );
		bw.populate();
	}
	
	override public function createList():Void
	{
		var allItems:Vector<Item> = Globals.g_itemLibrary.allItems();
		var count:Int = allItems.length;
		for ( i in 0 ... count )
		{
			if ( allItems[i].category() == BeerWindow )
				_items.push( allItems[i] );
		}
	}
}
