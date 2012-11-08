﻿package com.drinkzage.windows;

import Std;

import nme.Assets;
import nme.Lib;
import nme.Vector;

import nme.display.Sprite;
import nme.display.Stage;

import nme.events.MouseEvent;
import nme.events.Event;

import nme.filters.GlowFilter;

import nme.text.TextField;
import nme.text.TextFormat;
import nme.text.TextFormatAlign;

import nme.ui.Mouse;
import nme.events.TimerEvent;
import com.drinkzage.windows.Item;
import com.drinkzage.windows.ITabListWindow;
import com.drinkzage.windows.ListWindowConsts;

import com.drinkzage.Globals;
import com.drinkzage.utils.Utils;
import com.drinkzage.windows.TabConst;
/**
 * @author Robert Flesch
 */
class BeerListWindow extends ITabListWindow
{
	
	private static var _instance:BeerListWindow = null;
	private static var _lastCategory:BeerCategory = null;
	
	public static function instance():BeerListWindow
	{ 
		if ( null == _instance )
			_instance = new BeerListWindow();
			
		return _instance;
	}

	private function new () 
	{
		super();
		_tabs.push( "All" );
		_tabs.push( "U.S." );
		_tabs.push( "Import" );
		_tabs.push( "Local" );
		_tabs.push( "Back" );

		_tabSelected = TabDefault.Back;
		
		createList();
		
		_tabSelected = BeerCategory.All;
	}
	
	//
	///////////////////////////////////////////////////////////////
	// overides 
	///////////////////////////////////////////////////////////////
	override private function tabHandler( me:MouseEvent ):Void
	{
		if ( me.stageY >= Globals.g_app.tabHeight() + Globals.g_app.logoHeight() )
			return;
		
		trace( "BeerListWindow.tabHandler - CLICK - index: " + me.target.name );
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
		populate();
	}

	// TODO Should add a filter funcion to all tabbed windows
	// All this doesnt differently is to filter on the selected tab
	override public function mouseUpHandler( me:MouseEvent ):Void
	{
		nme.Lib.current.removeEventListener( MouseEvent.MOUSE_UP, mouseUpHandler );
		nme.Lib.current.removeEventListener( MouseEvent.MOUSE_MOVE, mouseMoveHandler );

		
		if ( me.stageY < Globals.g_app.tabHeight() + Globals.g_app.logoHeight() )
			return;
			
		//listOffsetAdjust( _change );
		
		_item = null;
		if ( ListWindowConsts.MOVE_MIN > Math.abs( _change ) )
		{
			var countDrawn:Int = 0;
			var offsetDistance:Float = Globals.g_app.tabHeight() + Globals.g_app.logoHeight();
			var clickLoc:Float = _listOffset + (me.stageY);
			var beerCount:Int = _items.length;
			for ( i in 0...beerCount )
			{
				if ( offsetDistance + Globals.g_app.componentHeight() < clickLoc )
				{
					offsetDistance += Globals.g_app.componentHeight();
					countDrawn++;
				}
				else 
				{
					_item = _items[countDrawn];
					if ( BeerCategory.All == _tabSelected )
					{
						break;
					}
					else if ( cast( _item, ItemBeer ).category == _tabSelected )
					{
						break;
					}
					countDrawn++;
				}
			}

			if ( null != _item )
				selectionHandler();
		}
		
		var swipeTime:Float = Lib.getTimer() - _time;
		_swipeSpeed = _change / swipeTime * 10;

		_drag = false;
		_change = 0;
	}
	
	override public function listDraw( scrollOffset:Float ):Void
	{
		var width:Float = _stage.stageWidth;
		var height:Float = Globals.g_app.componentHeight();
		//var numComponents:Int = _stage.height / Globals.g_app.componentHeight();
		var offset:Float = Globals.g_app.tabHeight() + Globals.g_app.logoHeight();
		var beerCount:Int = _items.length;
		var beer:ItemBeer = null;
		var countDrawn:Int = 0;
		var remainder:Float = scrollOffset % Globals.g_app.componentHeight();
		
		for ( i in 0...beerCount )
		{
			if ( scrollOffset <= i * Globals.g_app.componentHeight() + Globals.g_app.componentHeight() )
			{
				beer = cast( _items[i], ItemBeer );
				if ( BeerCategory.All == _tabSelected )
				{
					beer._textField.name = Std.string( i );
					beer._textField.x = ListWindowConsts.GUTTER;
					beer._textField.width = width - ListWindowConsts.GUTTER * 2;
					
					beer._textField.y = countDrawn * Globals.g_app.componentHeight() + offset - remainder;
					_window.addChild(beer._textField);
					countDrawn++;
				}
				else 
				{
					if ( _tabSelected == beer._category )
					{
						beer._textField.name = Std.string( i );
						beer._textField.x = ListWindowConsts.GUTTER;
						beer._textField.width = width - ListWindowConsts.GUTTER * 2;
						
						beer._textField.y = countDrawn * Globals.g_app.componentHeight() + offset - remainder;
						_window.addChild(beer._textField);
						countDrawn++;
					}
				}
			}
		}
	}

	override public function selectionHandler():Void
	{
		removeListeners();
		var bw:BeerWindow = new BeerWindow();
		bw.populate( cast( _item, ItemBeer ) );
	}
	
	override public function createList():Void
	{
		_items.push ( new ItemBeer( "Bud Light", "budweiser_lite_label.png", "Domestic", ContainerColor.Dark, BeerColor.Light ) );
		_items.push ( new ItemBeer( "Budweiser", "budweiser_label.png", "Domestic", ContainerColor.Dark, BeerColor.Light ) );
		_items.push ( new ItemBeer( "Miller Lite", "miller_lite_label.png", "Domestic", ContainerColor.Light, BeerColor.Light ) );
		_items.push ( new ItemBeer( "Coors Lite", "coors_lite_label.png", "Domestic", ContainerColor.Dark, BeerColor.Light ) );
		_items.push ( new ItemBeer( "Natural Lite", "natural_lite_label.png", "Domestic", ContainerColor.Dark, BeerColor.Light ) );
		_items.push ( new ItemBeer( "Corona", "corona_label.png", "Domestic", ContainerColor.Light, BeerColor.Light ) );
		_items.push ( new ItemBeer( "Busch", "busch_label.png", "Domestic", ContainerColor.Light, BeerColor.Light ) );
		_items.push ( new ItemBeer( "Busch Light", "busch_lite_label.png", "Domestic", ContainerColor.Light, BeerColor.Light ) );
		_items.push ( new ItemBeer( "Heineken", "heineken_label.png", "Import", ContainerColor.Green, BeerColor.Light ) );
		_items.push ( new ItemBeer( "Miller High Life", "miller_high_life_label.png", "Domestic", ContainerColor.Light, BeerColor.Light ) );

		//_items.push ( new Item( "Aguila", "aguila_label.png", "import", ContainerColor.Dark ) );
		//_items.push ( new Item( "Alexander Keith's Brown", "akbrown.png", "import", ContainerColor.Dark ) );
		//_items.push ( new Item( "Alexander Keith's Lager", "aklager.png", "import", ContainerColor.Dark ) );
		//_items.push ( new Item( "Alexander Keith's Pale Ale", "akpaleale.png", "import", ContainerColor.Light ) );
		//_items.push ( new Item( "Amsel Light", "amsellight.png", "Domestic", ContainerColor.Light ) );
		//_items.push ( new Item( "Animee Clear", "animeeclear.png", "Domestic", ContainerColor.Clear ) );
		//_items.push ( new Item( "Animee Lemon", "animeelemon.png", "Domestic", ContainerColor.Lemon ) );
		//_items.push ( new Item( "Animee Rose", "animeerose.png", "Domestic", ContainerColor.Other ) );
		//_items.push ( new Item( "Apatinsko", "apatinsko.png", "import", ContainerColor.Dark ) );
		//_items.push ( new Item( "Astika", "astika.png", "import", ContainerColor.Dark ) );
		//_items.push ( new Item( "Astika Dark", "astikadark.png", "import", ContainerColor.Dark ) );
		//_items.push ( new Item( "Bacardi Lemon", "bacardilemon.png", "import", ContainerColor.Lemon ) );
		//
		//_items.push ( new Item( "Bacardi Mojito", "bacardimojito.png", "import", ContainerColor.Dark ) );
		//_items.push ( new Item( "Bacardi Raz", "bacardiraz.png", "import", ContainerColor.Dark ) );
		//_items.push ( new Item( "Bacardi Silver Sangria", "bacardisilversangria.png", "import", ContainerColor.Dark ) );
		//_items.push ( new Item( "Bacardi Strawberry", "bacardistrawberry.png", "import", ContainerColor.Dark ) );
		//
		//_items.push ( new Item( "CAguila", "aguila_label.png", "import", ContainerColor.Dark ) );
		//_items.push ( new Item( "CAlexander Keith's Brown", "akbrown.png", "import", ContainerColor.Dark ) );
		//_items.push ( new Item( "CAlexander Keith's Lager", "aklager.png", "import", ContainerColor.Dark ) );
		//_items.push ( new Item( "CAlexander Keith's Pale Ale", "akpaleale.png", "import", ContainerColor.Dark ) );
		//_items.push ( new Item( "CAmsel Light", "amsellight.png", "Domestic", ContainerColor.Dark ) );
		//_items.push ( new Item( "CAnimee Clear", "animeeclear.png", "Domestic", ContainerColor.Dark ) );
		//_items.push ( new Item( "CAnimee Lemon", "animeelemon.png", "Domestic", ContainerColor.Dark ) );
		//_items.push ( new Item( "CAnimee Rose", "animeerose.png", "Domestic", ContainerColor.Dark ) );
		//_items.push ( new Item( "CApatinsko", "apatinsko.png", "import", ContainerColor.Dark ) );
		//_items.push ( new Item( "CAstika", "astika.png", "import", ContainerColor.Dark ) );
		//_items.push ( new Item( "CAstika Dark", "astikadark.png", "import", ContainerColor.Dark ) );
		//_items.push ( new Item( "CBacardi Lemon", "bacardilemon.png", "import", ContainerColor.Dark ) );
		//
		//_items.push ( new Item( "CBacardi Mojito", "bacardimojito.png", "import", ContainerColor.Dark ) );
		//_items.push ( new Item( "CBacardi Raz", "bacardiraz.png", "import", ContainerColor.Dark ) );
		//_items.push ( new Item( "CBacardi Silver Sangria", "bacardisilversangria.png", "import", ContainerColor.Dark ) );
		//_items.push ( new Item( "CBacardi Strawberry", "bacardistrawberry.png", "import", ContainerColor.Dark ) );
	}
}