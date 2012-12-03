package com.drinkzage.windows;

import nme.Lib;
import nme.Vector;
import nme.display.DisplayObject;


import nme.events.Event;
import nme.events.KeyboardEvent;
import nme.events.MouseEvent;

import com.drinkzage.Globals;
import com.drinkzage.windows.IChildWindow;

/**
 * @author Robert Flesch
 */
class IListWindow extends ITabWindow
{
	private var _items:Vector<Item> = null;

	private var _listOffset ( getListOffset, setListOffset ):Float = 0;
	function getListOffset():Float { return _listOffset; }
	function setListOffset( val:Float ):Float { return _listOffset = val; }
	
	private var _clickPoint:Float = 0;
	private var _change:Float = 0;
	private var _drag:Bool = false;
	private var _maxOffset:Float = 0;
	private var _time:Int = 0;
	private var _swipeSpeed:Float = 0;
	public  var _item:Item = null;
	
	private function new () {
		super();
		
		if ( null == _items )
		{
			_items = new Vector<Item>();
		}
	}
	
	public function createList():Void {}
	
	override public function populate():Void
	{
		_maxOffset = _items.length * Globals.g_app.componentHeight() - (_stage.stageHeight - Globals.g_app.tabHeight() - Globals.g_app.logoHeight());
		_maxOffset += Globals.g_app.tabHeight() + ListWindowConsts.FUDGE_FACTOR; // Fudge factor
		
		_window.prepareNewWindow();		

		_clickPoint = 0.0;
		_change = 0.0;
		_drag = false;
		
		removeListeners();
		addListeners();
		listDraw( _listOffset );

		_window.tabsDraw( _tabs, _tabSelected, tabHandler );
		
		if ( getUseSearch() )
			_window.searchDraw();
	}
	
	private function listDraw( scrollOffset:Float ):Void
	{
		var width:Float = _stage.stageWidth;
		var height:Float = Globals.g_app.componentHeight();
		var offset:Float = Globals.g_app.tabHeight() + Globals.g_app.logoHeight();
		var beerCount:Int = _items.length;
		var beer:Item = null;
		var countDrawn:Int = 0;
		var remainder:Float = scrollOffset % Globals.g_app.componentHeight();
		for ( i in 0...beerCount )
		{
			if ( scrollOffset <= i * Globals.g_app.componentHeight() + Globals.g_app.componentHeight() )
			{
				beer = _items[i];
				beer._textField.name = Std.string( i );
				beer._textField.x = ListWindowConsts.GUTTER;
				beer._textField.width = width - ListWindowConsts.GUTTER * 2;
				
				beer._textField.y = countDrawn * Globals.g_app.componentHeight() + offset - remainder;
				if ( beer._textField.y + Globals.g_app.logoHeight() > _stage.stageHeight )
					break;
				
				_window.addChild(beer._textField);
				countDrawn++;
			}
		}
		trace( "IListWindow.listDraw - countDrawn: " + countDrawn );
	}
	
	// This removes all of the "items" from the displayObject list.
	private function listRefresh( scrollOffset:Float ):Void
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
		listDraw( scrollOffset );
		
		// TODO - Just need to readd these, not recreate
		_window.searchPop();
		_window.tabsDraw( _tabs, _tabSelected, tabHandler );
	}
	
	public function mouseUpHandler( me:MouseEvent ):Void
	{
		_stage.removeEventListener( MouseEvent.MOUSE_UP, mouseUpHandler );
		_stage.removeEventListener( MouseEvent.MOUSE_MOVE, mouseMoveHandler );
		
		// if we let the mouse up over the header or logo, and it hasnt moved
		// then return
		if ( me.stageY < Globals.g_app.tabHeight() + Globals.g_app.logoHeight() && me.stageY - _clickPoint < 5 )
			return;
			
		listOffsetAdjust( _change );
		
		if ( _drag )
		{
			var swipeTime:Float = Lib.getTimer() - _time;
			_swipeSpeed = _change / swipeTime * 10;

			_drag = false;
			_change = 0;
		}
		else
		{
			_item = null;
			if ( ListWindowConsts.MOVE_MIN > Math.abs( _change ) )
			{
				trace( "mixedDrinkList.MouseUpHandler - CLICKED at: " + _clickPoint );
				var countDrawn:Int = 0;
				var distance:Float = Globals.g_app.tabHeight() + Globals.g_app.logoHeight();
				var clickLoc:Float = _listOffset + (me.stageY);
				var shotCount:Int = _items.length;
				for ( i in 0...shotCount )
				{
					if ( distance + Globals.g_app.componentHeight() < clickLoc )
					{
						distance += Globals.g_app.componentHeight();
						countDrawn++;
					}
					else 
					{
						_item = _items[countDrawn];
						break;
					}
				}

				if ( null != _item )
					selectionHandler();
			}
		}
	}
	
	private function mouseDownHandler( me:MouseEvent ):Void
	{
		_stage.addEventListener( MouseEvent.MOUSE_UP, mouseUpHandler );
		_stage.addEventListener( MouseEvent.MOUSE_MOVE, mouseMoveHandler );
		//if ( !_drag )
		{
			_clickPoint = me.stageY;
			//_time = Lib.getTimer();
			//_drag = true;		
		}
	}
	
	private function mouseMoveHandler( me:MouseEvent ):Void
	{
		if ( 5 < Math.abs( _clickPoint - me.stageY ) )
		{
			_drag = true;
		}
	
		if ( _drag )
		{
			_swipeSpeed = 0;
			_change = _clickPoint - me.stageY;
//			trace( "mixedDrinkListMouseMoveHandler change:" + _change + "  _clickPoint: " + _clickPoint + "  me.stageY: " + me.stageY );
		
			if ( _maxOffset < _listOffset + _change )
			{
				// end of list
				listRefresh( _maxOffset );
			}
			else
			{
				// Beginning of list
				if ( _listOffset + _change < 0 )
					listRefresh( 0 );
				else
				{
//					trace( "mouseMoveHandler: " + _listOffset + _change );
					listRefresh( _listOffset + _change ); // middle of list
				}
			}
		}
	}
	
	public function selectionHandler():Void
	{
		removeListeners();
		var ndyw:NotDoneYetWindow = NotDoneYetWindow.instance();
		ndyw.populate();
	}
	
	private function onEnter(e:Event):Void
	{
		/*
		if ( 0 != _swipeSpeed && true != _drag )
		{	
			_swipeSpeed = 0.95 * _swipeSpeed;
			if ( 0.1 > Math.abs( _swipeSpeed ) )
				_swipeSpeed = 0;
			
//			listOffsetAdjust( _swipeSpeed );

			populate(); 	
		}
		*/
	}
	
	private function listOffsetAdjust( changeAmount:Float ):Void
	{
		if ( 0 > _listOffset + changeAmount )
			_listOffset = 0;
		else	
		{
			if ( _maxOffset < _listOffset + changeAmount )
				_listOffset = _maxOffset;
			else
			{
				_listOffset += changeAmount;
			}
		}
	}
	
	override public function addListeners():Void
	{
		super.addListeners();
		_stage.addEventListener( MouseEvent.MOUSE_DOWN, mouseDownHandler );
		_stage.addEventListener( nme.events.Event.ENTER_FRAME, onEnter);
	}
	
	override public function removeListeners():Void
	{
		super.removeListeners();
		_stage.removeEventListener( MouseEvent.MOUSE_DOWN, mouseDownHandler );
		_stage.removeEventListener( nme.events.Event.ENTER_FRAME, onEnter);
	}
	
}