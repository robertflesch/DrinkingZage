package com.drinkzage.windows;

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
import nme.events.KeyboardEvent;

import nme.filters.GlowFilter;

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
import com.drinkzage.windows.MixedDrinkWindow;
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
		
		_searchText = new TextField();
		
		_tabs.push( "BACK" );

		_textFormat = new TextFormat("_sans");
		_textFormat.size = 32;                // set the font size
		_textFormat.align = TextFormatAlign.CENTER;
		_textFormat.color = 0x000000;
		
		createList();
	}
	
	//
	///////////////////////////////////////////////////////////////
	// overides 
	///////////////////////////////////////////////////////////////
	
	override public function populate():Void
	{
		super.populate();
		
		_searchText.name = "_searchText";
		_searchText.selectable = true;
		_searchText.border = true;
		//_searchText.borderColor = Globals.COLOR_SAGE;
		_searchText.width = Lib.current.stage.stageWidth;
		_searchText.height = _window.componentHeight();
#if android
		_searchText.y = Lib.current.stage.stageHeight / 2 + _searchText.height/2 - 20;
#else		
		_searchText.y = Lib.current.stage.stageHeight - _searchText.height - 2;
#end		
		_searchText.x = 0;
		_searchText.type = TextFieldType.INPUT;
		_searchText.addEventListener (Event.CHANGE, TextField_onChange);
		_searchText.background = true;
		_searchText.backgroundColor = Globals.COLOR_WHITE;
		_searchText.setTextFormat( _textFormat );
		
		_window.addChild( _searchText );

		_stage.focus = _searchText;
		//_searchText.setSelection(_searchText.text.length, _searchText.text.length);//();
		}
	

	// This removes all of the "items" from the displayObject list.
	private function listUpdate():Void
	{
		var i:Int = _window.numChildren;
		// this removes the existing items from the list.
		// which allows list draw to add them back in.
		while ( i > 0 )
		{
			i--;
			var item:DisplayObject = _window.getChildAt(i);
			if ( "item" == item.name )
				_window.removeChildAt( i );
		}
		
		// now add these visible items back in
		listDraw( _listOffset );
	}
	
	override public function listDraw( scrollOffset:Float ):Void
	{
		_window.resetVisiblity();
		if ( "" != _searchText.text )
		{
			_window.hideItemsWithoutString( _searchText.text );
		}
		
		var width:Int = Lib.current.stage.stageWidth;

		var textOffset:Float = 5;
		
		var allItems:Vector<Item> = _window.getAllItems();
		var width:Float = _stage.stageWidth;
		var height:Float = Globals.g_app.componentHeight();
		var offset:Float = Globals.g_app.tabHeight() + Globals.g_app.logoHeight();
		var count:Int = allItems.length;
		var item:Item = null;
		var countDrawn:Int = 0;
		var remainder:Float = scrollOffset % Globals.g_app.componentHeight();
		for ( i in 0...count )
		{
			//if ( scrollOffset <= i * Globals.g_app.componentHeight() + Globals.g_app.componentHeight() )
			{
				
				item = allItems[i];
				if ( true == item.isVisible() )
				{
					item._textField.x = ListWindowConsts.GUTTER;
					item._textField.width = width - ListWindowConsts.GUTTER * 2;
					
					item._textField.y = countDrawn * Globals.g_app.componentHeight() + offset - remainder;
					
					var image:String = "search.jpg";
					if ( EmoteWindow == item.category() )
						image = "emote.jpg";
					else if ( WineWindow == item.category() )
						image = "wine.jpg";
					else if ( NonAlcoholicDrinkWindow == item.category() )
						image = "non.jpg";
					else if ( BeerWindow == item.category() )
						image = "beer.jpg";
					else if ( ShotWindow == item.category() )
						image = "shot.jpg";
					else if ( MixedDrinkWindow == item.category() )
						image = "liquor.jpg";

					var graphic:Sprite = Utils.loadGraphic ( "assets/" + image, true );
					graphic.name = "item";
					graphic.x = item._textField.x;
					graphic.y = item._textField.y + 1;
					graphic.height = Globals.g_app.componentHeight() - 2; 
					graphic.width = Globals.g_app.componentHeight(); 
					
					_window.addChild(item._textField);
					_window.addChild(graphic);
					countDrawn++;
					
#if android
					if ( Lib.current.stage.stageHeight < item._textField.y )
						break;
#else		
					if ( ( Lib.current.stage.stageHeight - _searchText.height - 2) < item._textField.y )
						break;
#end		
				}
			}
		}
		
		// readd the searchText field which bring it to the front.
		_searchText.setTextFormat( _textFormat );
		_window.addChild( _searchText );
		_stage.focus = _searchText;
	}

	override public function mouseUpHandler( me:MouseEvent ):Void
	{
		_stage.removeEventListener( MouseEvent.MOUSE_UP, mouseUpHandler );
		_stage.removeEventListener( MouseEvent.MOUSE_MOVE, mouseMoveHandler );
		
		// if we let the mouse up over the header or logo, and it hasnt moved
		// then return
		if ( me.stageY < Globals.g_app.tabHeight() + Globals.g_app.logoHeight() && me.stageY - _clickPoint < 5 )
			return;
			
		// if click is lower then search bar
#if android
		var bh:Int = Std.int( Lib.current.stage.stageHeight/2 - Globals.g_app.searchHeight() );
#else
		var bh:Int = Lib.current.stage.stageHeight - Std.int( Globals.g_app.searchHeight() * 2 );
#end
		if ( me.stageY > bh )
			return;
			
		//listOffsetAdjust( _change );
		
		_item = null;
		var allItems:Vector<Item> = _window.getAllItems();
		if ( ListWindowConsts.MOVE_MIN > Math.abs( _change ) )
		{
			var countDrawn:Int = 0;
			var distance:Float = Globals.g_app.tabHeight() + Globals.g_app.logoHeight();
			var clickLoc:Float = _listOffset + (me.stageY);
			var itemCount:Int = allItems.length;
			var item:Item = null;
			for ( i in 0...itemCount )
			{
				item = allItems[i];
				if ( false == item.isVisible() )
					continue;
				
				if ( distance + Globals.g_app.componentHeight() < clickLoc )
				{
					distance += Globals.g_app.componentHeight();
					countDrawn++;
				}
				else 
				{
					trace( allItems[i]._name );
					if ( true == allItems[i].isVisible() )
					{
						_item = allItems[i];
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

	public function TextField_onChange( event:Event ): Void
	{
		var textField:TextField = event.currentTarget;
		
		//_window.addItem( new Item( "1" + textField.text, EmoteWindow ) );
 
		trace ( "SearchWindow.TextField_onChange - search data:" + textField.text);		
		
		_searchText.text = textField.text;
		listUpdate();
	}
	
	override public function selectionHandler():Void
	{
		trace( "SearchWindow.selectionHandler" );
		removeListeners();
		
		var window:Dynamic = null;
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
		else if ( MixedDrinkWindow == _item.category() )
		{
			window = MixedDrinkWindow.instance();
		}
		
		if ( null != window )
		{
			window.setBackHandler( this );
			window.populate( _item );
		}
		else
			trace( "SearchWindow.selectionHandler - ERROR - no category found" );
		
	}
	
	override public function createList():Void
	{
	}
}
