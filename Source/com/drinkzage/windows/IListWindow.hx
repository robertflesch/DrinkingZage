package com.drinkzage.windows;

import nme.Lib;
import nme.Vector;
import nme.display.DisplayObject;

import nme.events.Event;
import nme.events.KeyboardEvent;
import nme.events.MouseEvent;

import nme.text.TextField;
import nme.text.TextFormat;
import nme.text.TextFormatAlign;

import com.drinkzage.Globals;
import com.drinkzage.windows.IChildWindow;
import com.drinkzage.windows.DataTextField;

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
	private var _maxComponents:Int = 0;
	private var _components:Vector<DisplayObject> = null;
	public  var _tf:TextFormat = null;
	
	public var _temp:Item = null;
	
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
		trace( "IListWindow.populate" );
		_maxOffset = _items.length * Globals.g_app.componentHeight() - (_stage.stageHeight - Globals.g_app.tabHeight() - Globals.g_app.logoHeight());
		_maxOffset += Globals.g_app.tabHeight() + ListWindowConsts.FUDGE_FACTOR; // Fudge factor
		
		var drawableArea:Float = _stage.stageHeight - Globals.g_app.tabHeight() - Globals.g_app.logoHeight() - ( getUseSearch() ? Globals.g_app.searchHeight() : 0 );
		var maxVisibleComponents:Float = drawableArea / Globals.g_app.componentHeight() + 0.5;
		// Add in one extra for when partial components at top and bottom as visible
		_maxComponents = Std.int( maxVisibleComponents ) + 1;
		
		createComponents();
		
		_window.prepareNewWindow();		

		_clickPoint = 0.0;
		_change = 0.0;
		_drag = false;
		
		removeListeners();
		addListeners();
		listDraw( _listOffset );

		_tabHandler = tabHandler;
		tabsDraw( _tabs, _tabSelected );
		
		if ( getUseSearch() )
			_window.searchDraw();
	}
	
	public function createComponents():Void
	{
		_components = new Vector<DisplayObject>();
		for ( i in 0..._maxComponents )
		{
			_components.push( new DataTextField() );
			_components[i].height = Globals.g_app.componentHeight();
//			_components[i].text = name;
			cast( _components[i], TextField ).background = true;
			cast( _components[i], TextField ).backgroundColor = 0x000000;
			cast( _components[i], TextField ).border = true;
			cast( _components[i], TextField ).borderColor = 0xffffff;
			cast( _components[i], TextField ).selectable = false;
			//_components[i].name = "item";
			
			if ( null == _tf )
			{
				_tf = new TextFormat("_sans");
				_tf.size = 36;                // set the font size
				_tf.align = TextFormatAlign.CENTER;
				_tf.color = 0xFF0000;           // set the color
			}
		}
	}
	
	private function listDraw( scrollOffset:Float ):Void
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
	
	// This removes all of the "items" from the displayObject list.
	private function listRefresh( scrollOffset:Float ):Void
	{
		for ( j in 0..._maxComponents )
			_components[j].visible = false;
			
		var offset:Float = Globals.g_app.tabHeight() + Globals.g_app.logoHeight();
		var itemCount:Int = _items.length;
		var countDrawn:Int = 0;
		var remainder:Float = scrollOffset % Globals.g_app.componentHeight();
		for ( i in 0...itemCount )
		{
			if ( scrollOffset <= i * Globals.g_app.componentHeight() + Globals.g_app.componentHeight() )
			{
				_components[countDrawn].visible = true;
				cast( _components[countDrawn], TextField ).text = _items[i].name();
				cast( _components[countDrawn], TextField ).setTextFormat(_tf);
				_components[countDrawn].y = countDrawn * Globals.g_app.componentHeight() + offset - remainder;
				cast( _components[countDrawn], DataTextField ).setData( _items[i] );
				
				if ( _components[countDrawn].y + Globals.g_app.logoHeight() > _stage.stageHeight )
					break;
				countDrawn++;
				if ( countDrawn == _maxComponents )
					break;
			}
		}
	}
	
	public function mouseUpHandler( me:MouseEvent ):Void
	{
		_stage.removeEventListener( MouseEvent.MOUSE_UP, mouseUpHandler );
		_stage.removeEventListener( MouseEvent.MOUSE_MOVE, mouseMoveHandler );
		
		// if we let the mouse up over the header or logo, and it hasnt moved then return
		if ( me.stageY < Globals.g_app.tabHeight() + Globals.g_app.logoHeight() && me.stageY - _clickPoint < 5 )
			return;
			
		listOffsetAdjust( _change );
		
		if ( _drag )
		{
			// TODO currently the list doesnt have momentum
			// so when you stop moving, the list stops
			var swipeTime:Float = Lib.getTimer() - _time;
			_swipeSpeed = _change / swipeTime * 10;

			_drag = false;
			_change = 0;
		}
		else
		{
			var remainder:Float = _listOffset % Globals.g_app.componentHeight();
			// where did I click in the client area?
			var relativeClickPoint:Float = (_clickPoint - Globals.g_app.tabHeight() - Globals.g_app.logoHeight());
			// this gets the component index from where I clicked
			var componentIndex:Int = Std.int((remainder + relativeClickPoint) / Globals.g_app.componentHeight());
			_item = null;
			if ( componentIndex <= Std.int( _components.length ) )
			{
				_item = cast( _components[componentIndex], DataTextField ).getData();
				if ( null != _item )
					selectionHandler();
			}
		}
	}
	
	private function mouseDownHandler( me:MouseEvent ):Void
	{
		_stage.addEventListener( MouseEvent.MOUSE_UP, mouseUpHandler );
		_stage.addEventListener( MouseEvent.MOUSE_MOVE, mouseMoveHandler );
		
		_clickPoint = me.stageY;
	}
	
	private function mouseMoveHandler( me:MouseEvent ):Void
	{
		if ( 5 < Math.abs( _clickPoint - me.stageY ) )
		{
			_drag = true;
			_time = Lib.getTimer();
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
		//_temp.setText( "2" );
		//_window.addChild( _temp );
		//_temp.setText( Std.string( Std.parseInt( _temp._textField.text ) + 1) );
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