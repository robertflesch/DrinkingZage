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

import nme.text.TextFieldType;
import nme.events.KeyboardEvent;

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

/**
 * @author Robert Flesch
 */
class SearchWindow extends ITabListWindow
{
	
	private static var _instance:SearchWindow = null;
	private static var _lastCategory:BeerCategory = null;
	private static var _lastString:String = "";
	private static var _textFormat:TextFormat = null;
	
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
		
		_tabs.push( "BACK" );
		_tabSelected = TabDefault.Back;

		_textFormat = new TextFormat("_sans");
		_textFormat.size = 32;                // set the font size
		_textFormat.align = TextFormatAlign.LEFT;
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
		listDraw( _listOffset );
		_window.tabsDraw( _tabs, _tabSelected, tabHandler );
	}
	
	
	override public function listDraw( scrollOffset:Float ):Void
	{
		_window.resetVisiblity();
		if ( "" != _lastString )
		{
			_window.hideItemsWithoutString( _lastString );
		}
		
		var width:Int = Lib.current.stage.stageWidth;

		var textOffset:Float = 5;
		var text : TextField = new TextField();
		text.text = _lastString;
		text.selectable = true;
		text.border = true;
		text.borderColor = Globals.COLOR_SAGE;
		text.width = Lib.current.stage.stageWidth - 6;
		text.height = _window.componentHeight();
#if android
		text.y = Lib.current.stage.stageHeight / 2; // - text.height;
#else		
		text.y = Lib.current.stage.stageHeight - text.height - 2;
#end		
		text.x = 2;
		text.type = TextFieldType.INPUT;
		text.addEventListener (Event.CHANGE, TextField_onChange);
		text.background = true;
		text.backgroundColor = Globals.COLOR_WHITE;
		text.setTextFormat( SearchWindow._textFormat );
		
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
					graphic.x = item._textField.x;
					graphic.y = item._textField.y + 1;
					graphic.height = Globals.g_app.componentHeight() - 2; 
					graphic.width = Globals.g_app.componentHeight(); 
					
					_window.addChild(item._textField);
					_window.addChild(graphic);
					countDrawn++;
					
#if android
					if ( Lib.current.stage.stageHeight < item._textField.y )
#else		
					if ( ( Lib.current.stage.stageHeight - text.height - 2) < item._textField.y )
#end		
						break;
				}
			}
		}

		//var fe:FocusEvent = new FocusEvent( FOCUS_IN, true, false );	
		//DisplayObject
		//SetFocusObject(
		_window.addChild( text );

/*
#if android
		var clickMe:Sprite = Utils.loadGraphic ( "assets/wine.jpg", true );
		clickMe.x = 0;
		clickMe.y = Lib.current.stage.stageHeight / 2 + _window.componentHeight();
		clickMe.width = width;
		clickMe.height = Lib.current.stage.stageHeight / 2 - _window.componentHeight();
		
		var clickMeText : TextField = new TextField();
		clickMeText.text = "Click Me For Keyboard";
		clickMeText.selectable = true;
		clickMeText.border = true;
		clickMeText.borderColor = Globals.COLOR_SAGE;
		clickMeText.width = Lib.current.stage.stageWidth - 6;
		clickMeText.height = _window.componentHeight();
		clickMe.addChild( clickMeText );
		_window.addChild(clickMe);
#end
*/
		_stage.focus = text;
		text.setSelection(text.text.length,text.text.length);//();
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
		var bh:Int = Std.int( Lib.current.stage.stageHeight/2 - Globals.g_app.searchHeight() * 2 );
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
			var shotCount:Int = allItems.length;
			for ( i in 0...shotCount )
			{
				if ( distance + Globals.g_app.componentHeight() < clickLoc )
				{
					distance += Globals.g_app.componentHeight();
					countDrawn++;
				}
				else 
				{
					trace( allItems[countDrawn]._name );
					if ( true == allItems[countDrawn].isVisible() )
					{
						_item = allItems[countDrawn];
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
 
		trace (textField.text);		
//		_window.hideItemsWithoutString( textField.text );
		_lastString = textField.text;
		populate();
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
