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

import nme.filters.GlowFilter;

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
	
	//
	///////////////////////////////////////////////////////////////
	// overides 
	///////////////////////////////////////////////////////////////
	
	override private function tabHandler( me:MouseEvent ):Void
	{
		//trace( "BeerListWindow.tabHandler" );
		if ( me.stageY >= Globals.g_app.tabHeight() + Globals.g_app.logoHeight() )
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
		populate();
	}

	override private function listDraw( scrollOffset:Float ):Void
	{
		var width:Float = _stage.stageWidth;
		var height:Float = Globals.g_app.componentHeight();
		var offset:Float = Globals.g_app.tabHeight() + Globals.g_app.logoHeight();
		var itemCount:Int = _items.length;
		var item:Item = null;
		var countDrawn:Int = 0;
		var remainder:Float = scrollOffset % Globals.g_app.componentHeight();
		for ( i in 0...itemCount )
		{
			if ( scrollOffset <= i * Globals.g_app.componentHeight() + Globals.g_app.componentHeight() )
			{
				item = cast( _items[i], ItemBeer );
				if ( BeerCategory.All == _tabSelected )
				{
					cast( _components[countDrawn], TextField ).text = _items[i].name();
					cast( _components[countDrawn], TextField ).setTextFormat(_tf);
					_components[countDrawn].name = Std.string( i );
					_components[countDrawn].x = ListWindowConsts.GUTTER;
					_components[countDrawn].width = width - ListWindowConsts.GUTTER * 2;
					
					_components[countDrawn].y = countDrawn * Globals.g_app.componentHeight() + offset - remainder;
					cast( _components[countDrawn], DataTextField ).setData( _items[i] );
					
					if ( _components[countDrawn].y + Globals.g_app.logoHeight() > _stage.stageHeight )
						break;
					
					_window.addChild(_components[countDrawn]);
					countDrawn++;
					if ( countDrawn == _maxComponents )
						break;
				}
				else 
				{
					if ( _tabSelected == cast( item, ItemBeer ).beerCategory )
					{
						cast( _components[countDrawn], TextField ).text = _items[i].name();
						cast( _components[countDrawn], TextField ).setTextFormat(_tf);
						_components[countDrawn].name = Std.string( i );
						_components[countDrawn].x = ListWindowConsts.GUTTER;
						_components[countDrawn].width = width - ListWindowConsts.GUTTER * 2;
						
						_components[countDrawn].y = countDrawn * Globals.g_app.componentHeight() + offset - remainder;
						cast( _components[countDrawn], DataTextField ).setData( _items[i] );
						
						if ( _components[countDrawn].y + Globals.g_app.logoHeight() > _stage.stageHeight )
							break;
						
						_window.addChild(_components[countDrawn]);
						countDrawn++;
						if ( countDrawn == _maxComponents )
							break;
					}
				}
				
				
			}
		}
	}
	
	override public function selectionHandler():Void
	{
		//trace( "BeerListWindow.selectionHandler" );
		removeListeners();
		var bw:BeerWindow = new BeerWindow();
		bw.setBackHandler( this );
		bw.setItem( cast( _item, ItemBeer ) );
		bw.populate();
	}
	
	override public function createList():Void
	{
		var allItems:Vector<Item> = _window.allItems();
		var count:Int = allItems.length;
		for ( i in 0 ... count )
		{
			if ( allItems[i].category() == BeerWindow )
				_items.push( allItems[i] );
		}
	}
}
