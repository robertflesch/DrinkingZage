package com.drinkzage.windows;

import nme.Vector;
import nme.Vector;
import Std;

import nme.Assets;
import nme.Lib;
import nme.Vector;

import nme.display.Sprite;
import nme.display.Stage;
import nme.display.DisplayObject;

import nme.events.Event;
import nme.events.FocusEvent;
import nme.events.MouseEvent;

import nme.text.TextField;
import nme.text.TextFormat;
import nme.text.TextFormatAlign;
import nme.text.TextFieldType;

import nme.ui.Mouse;
import nme.events.TimerEvent;

import com.drinkzage.Globals;

import com.drinkzage.utils.Utils;

import com.drinkzage.windows.Item;
import com.drinkzage.windows.ListWindowConsts;
import com.drinkzage.windows.WineWindow;
import com.drinkzage.windows.NonAlcoholicDrinkWindow;
import com.drinkzage.windows.BeerWindow;
import com.drinkzage.windows.Item;
import com.drinkzage.windows.ItemBeer;
import com.drinkzage.windows.ContainerColor;
import com.drinkzage.windows.BeerColor;
import com.drinkzage.windows.ShotWindow;
import com.drinkzage.windows.EmoteWindow;
import com.drinkzage.windows.IListWindow;

/**
 * @author Robert Flesch
 */
class SearchWindow extends IListWindow
{
	private static var _instance:SearchWindow = null;

	private 	   var _textFormat:TextFormat = null;
	private 	   var _searchText : TextField = null;

	public static function instance():SearchWindow
	{ 
		if ( null == _instance )
		{
			_instance = new SearchWindow();
		}
			
		return _instance;
	}

	private function new () 
	{
		super();
		
		setUseSearch( false );
		
		_tabs.push( "BACK" );

		_textFormat = new TextFormat("_sans");
		_textFormat.size = 32;                // set the font size
		_textFormat.align = TextFormatAlign.CENTER;
		_textFormat.color = 0x000000;
		
		_searchText = new TextField();
		_searchText.text = "";
		_searchText.setTextFormat( _textFormat );
		
		createList();
	}
	
	//
	///////////////////////////////////////////////////////////////
	// overides 
	///////////////////////////////////////////////////////////////
	
	override public function populate():Void
	{
		trace( "SearchWindow.populate" );		
		super.populate();
		
		_searchText.name = "_searchText";
		_searchText.selectable = true;
		_searchText.border = true;
		//_searchText.borderColor = Globals.COLOR_SAGE;
		_searchText.width = Lib.current.stage.stageWidth;
		_searchText.height = componentHeight();
		_searchText.y = Lib.current.stage.stageHeight - _searchText.height - 2;
		_searchText.x = 0;
		_searchText.type = TextFieldType.INPUT;
		_em.addEvent( _searchText, Event.CHANGE, TextField_onChange);
		_em.addEvent( _searchText, FocusEvent.FOCUS_IN, searchGetFocus );
		_searchText.background = true;
		_searchText.backgroundColor = Globals.COLOR_WHITE;
		_searchText.setTextFormat( _textFormat );
		
		
		listDraw( 0, false );

		_window.addChild( _searchText );
		
		_stage.focus = _searchText;
		//_searchText.setSelection(_searchText.text.length, _searchText.text.length);//();
	}

	public function searchGetFocus( event:FocusEvent ):Void
	{
		trace( "SearchWindow.searchGetFocus" );		
		_em.removeEvent( _searchText, FocusEvent.FOCUS_IN, searchGetFocus );
		_em.addEvent( _searchText, FocusEvent.FOCUS_OUT, searchLoseFocus );
		
		_searchText.setTextFormat( _textFormat );
//#if android
		_searchText.y = Lib.current.stage.stageHeight / 2 + _searchText.height/2 - 20;
//#end		
		// re adding button pops it to front
	}

	public function searchLoseFocus( event:FocusEvent ):Void
	{
		trace( "SearchWindow.searchLoseFocus" );
		_em.removeEvent( _searchText,  FocusEvent.FOCUS_OUT, searchLoseFocus );
		_em.addEvent( _searchText, FocusEvent.FOCUS_IN, searchGetFocus );
		
		_searchText.y = Lib.current.stage.stageHeight - _searchText.height - 2;
	}
	
/*	
 	// This removes all of the "items" from the displayObject list.
	override private function listRefresh( scrollOffset:Float ):Void
	{
		Globals.g_itemLibrary.resetVisiblity();
		if ( "" != _searchText.text )
		{
			_window.hideItemsWithoutString( _searchText.text );
		}

		//super.listRefresh( scrollOffset );
		for ( j in 0..._maxComponents )
		{
			_components[j].visible = false;
			cast( _components[j], DataTextField ).setData( null );
		}
		
		var offset:Float = tabHeight() + logoHeight();
		var itemCount:Int = _items.length;
		var countDrawn:Int = 0;
		var remainder:Float = scrollOffset % componentHeight();
		var item:Item = null;
		for ( i in 0...itemCount )
		{
			if ( scrollOffset <= i * componentHeight() + componentHeight() )
			{
				item = _items[i];
				if ( true == item.isVisible() )
				{
					_components[countDrawn].visible = true;
					cast( _components[countDrawn], TextField ).text = item.name();
					cast( _components[countDrawn], TextField ).setTextFormat(_tf);
					_components[countDrawn].y = countDrawn * componentHeight() + offset - remainder;
					cast( _components[countDrawn], DataTextField ).setData( item );
					
					if ( _components[countDrawn].y + logoHeight() > _stage.stageHeight )
						break;
					countDrawn++;
					if ( countDrawn == _maxComponents )
						break;
				}
			}
		}
	}
*/

	private function hideItemsWithoutString( val:String ):Void
	{
		var count:Int = _items.length;
		for ( i in 0...count )
		{
			var index:Int = _items[i].name().toLowerCase().indexOf( val.toLowerCase(), 0 );
			if ( 0 > index )
				_items[i].setVisible( false );
		}
	}
	

	override private function applyFilter():Void
	{
		Globals.g_itemLibrary.resetVisiblity( _items );
		if ( "" != _searchText.text )
		{
			hideItemsWithoutString( _searchText.text );
		}
	}
/*
	override private function listDraw( scrollOffset:Float, addChild:Bool = true ):Void
	{
		trace( "SearchWindow.listDraw" );
		var width:Float = _stage.stageWidth;
		var height:Float = componentHeight();
		var offset:Float = tabHeight() + logoHeight();
		var itemCount:Int = _items.length;
		var item:Item = null;
		var countDrawn:Int = 0;
		var remainder:Float = scrollOffset % componentHeight();
		for ( i in 0...itemCount )
		{
			if ( scrollOffset <= i * componentHeight() + componentHeight() )
			{
				item = _items[i];
				cast( _components[countDrawn], TextField ).text = item.name();
				cast( _components[countDrawn], TextField ).setTextFormat(_tf);
				_components[countDrawn].name = Std.string( i );
				_components[countDrawn].x = ListWindowConsts.GUTTER;
				_components[countDrawn].width = width - ListWindowConsts.GUTTER * 2;
				_components[countDrawn].y = countDrawn * componentHeight() + offset - remainder;
				cast( _components[countDrawn], DataTextField ).setData( item );
				_window.addChild(_components[countDrawn]);
				///////////
				
					//var image:String = "search.jpg";
					//if ( EmoteWindow == item.category() )
						//image = "emote.jpg";
					//else if ( WineWindow == item.category() )
						//image = "wine.jpg";
					//else if ( NonAlcoholicDrinkWindow == item.category() )
						//image = "non.jpg";
					//else if ( BeerWindow == item.category() )
						//image = "beer.jpg";
					//else if ( ShotWindow == item.category() )
						//image = "shot.jpg";
//
					//var graphic:Sprite = Utils.loadGraphic ( "assets/" + image, true );
					//graphic.name = "item";
					//graphic.x = _components[countDrawn].x;
					//graphic.y = _components[countDrawn].y + 1;
					//graphic.height = componentHeight() - 2; 
					//graphic.width = componentHeight(); 
					//_window.addChild(graphic);
				
				////////////
				if ( _components[countDrawn].y + logoHeight() > _stage.stageHeight )
					break;
				countDrawn++;
				if ( countDrawn == _maxComponents )
					break;
			}
		}
	}
*/
	public function TextField_onChange( event:Event ): Void
	{
		trace( "SearchWindow.onChange" );		
		//var textField:TextField = event.currentTarget;
		//_searchText.text = textField.text;
		
		_searchText.setTextFormat( _textFormat );

		listDraw( 0, false );
		
		_window.addChild( _searchText );
	}
	
	override public function selectionHandler():Void
	{
		trace( "SearchWindow.selectionHandler" );		
		if ( _clickPoint > _searchText.y )
			return;
			
		//trace( "SearchWindow.selectionHandler" );
		//removeListeners();
		
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
			trace( "SearchWindow.selectionHandler - ERROR - no category found" );
		
	}
	
	override public function createList():Void
	{
		trace( "SearchWindow.createList" );		
		_items = Globals.g_itemLibrary.allItems();
	}
}
