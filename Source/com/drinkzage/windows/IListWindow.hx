package com.drinkzage.windows;

import nme.Lib;
import nme.Vector;
import nme.display.DisplayObject;

import nme.events.Event;
import nme.events.MouseEvent;
import nme.events.KeyboardEvent;

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
	
	private var _listHasMomentum( listHasMomentum, setListHasMomentum ):Bool = true;
	function listHasMomentum():Bool { return _listHasMomentum; }
	function setListHasMomentum( val:Bool ):Bool { return _listHasMomentum = val; }
	
	private var _clickPoint:Float = 0;
	private var _dragDistance:Float = 0;
	private var _drag:Bool = false;
	private var _time:Int = 0;
	private var _swipeSpeed:Float = 0;
	
	private var _maxOffset:Float = 0;
	private var _item:Item = null;
	private var _maxComponents:Int = 0;
	private var _components:Vector<DisplayObject> = null;
	private var _tf:TextFormat = null;
	
	private function new () {
		super();
		
		if ( null == _items )
		{
			_items = new Vector<Item>();
		}
	}
	
	public function createList():Void 
	{
		throw ( "IListWindow.createList - VIRTUAL FUNCTION WHICH NEEDS TO BE OVERRIDDEN" );
	}
	
	override public function populate():Void
	{
		//trace( "IListWindow.populate" );
		_clickPoint = 0.0;
		_dragDistance = 0.0;
		_drag = false;

		_maxOffset = _items.length * Globals.g_app.componentHeight() - (_stage.stageHeight - Globals.g_app.tabHeight() - Globals.g_app.logoHeight());
		_maxOffset += Globals.g_app.tabHeight() + ListWindowConsts.FUDGE_FACTOR; // Fudge factor
		
		var drawableArea:Float = _stage.stageHeight - Globals.g_app.tabHeight() - Globals.g_app.logoHeight() - ( getUseSearch() ? Globals.g_app.searchHeight() : 0 );
		var maxVisibleComponents:Float = drawableArea / Globals.g_app.componentHeight() + 0.5;
		// Add in one extra for when partial components at top and bottom as visible
		_maxComponents = Std.int( maxVisibleComponents ) + 1;
	
		if ( null == _components )
			createComponents();
		
		_window.removeAllChildrenAndDrawLogo();		
		
		// need to duplicate functionality of parent
		// because list drawn need to come before tab and search
		listDraw( _listOffset );
		
		_tabHandler = tabHandler;
		tabsDraw( _tabs, _tabSelected );
		
		
		if ( getUseSearch() )
			_window.searchDraw();

		_em.addEvent( _stage, KeyboardEvent.KEY_UP, onKeyUp );
		_em.addEvent( _stage, MouseEvent.MOUSE_DOWN, mouseDownHandler );
		_em.addEvent( _stage, Event.ENTER_FRAME, onEnter );
	}	
	
	public function createComponents():Void
	{
		if ( null == _tf )
		{
			_tf = new TextFormat("_sans");
			_tf.size = 36;                // set the font size
			_tf.align = TextFormatAlign.CENTER;
			_tf.color = 0xFF0000;           // set the color
		}
		
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
			
		}
	}
	
	private function setComponentValues( displyObject:DisplayObject, item:Item, i:Int, countDrawn:Int, offset:Float, remainder:Float ):Void
	{
		cast( displyObject, TextField ).text = item.name();
		cast( displyObject, TextField ).setTextFormat(_tf);
		displyObject.name = Std.string( i );
		displyObject.x = ListWindowConsts.GUTTER;
		displyObject.y = countDrawn * Globals.g_app.componentHeight() + offset - remainder;
		displyObject.width = _stage.stageWidth - ListWindowConsts.GUTTER * 2;
		cast( displyObject, DataTextField ).setData( item );
	}
	
	private function applyFilter():Void
	{
		// override this to apply a custom filter
		// just make sure everything is visible
		_window.resetVisiblity( _items );
	}
	
	private function listDraw( scrollOffset:Float, addChild:Bool = true ):Void
	{
		for ( j in 0..._maxComponents )
			_components[j].visible = false;

		// this gives decendants a choice of what items they want to display
		applyFilter();
		
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
				item = _items[i];
				if ( true == item.isVisible() )
				{
					_components[countDrawn].visible = true;
					
					setComponentValues( _components[countDrawn], item, i, countDrawn, offset, remainder );
					
					if ( _components[countDrawn].y + Globals.g_app.logoHeight() > _stage.stageHeight )
						break;
					
					if ( addChild )
						_window.addChild(_components[countDrawn]);
					countDrawn++;
					if ( countDrawn == _maxComponents )
						break;
				}
			}
		}
	}
	
	private function mouseDownHandler( me:MouseEvent ):Void
	{
		_em.addEvent( _stage, MouseEvent.MOUSE_UP, mouseUpHandler );
		_em.addEvent( _stage, MouseEvent.MOUSE_MOVE, mouseMoveHandler );
		
		_clickPoint = me.stageY;
	}
	
	public function mouseUpHandler( me:MouseEvent ):Void
	{
		_em.removeEvent( _stage, MouseEvent.MOUSE_UP, mouseUpHandler );
		_em.removeEvent( _stage, MouseEvent.MOUSE_MOVE, mouseMoveHandler );
		
		// if we let the mouse up over the header or logo, and it hasnt moved then return
		if ( me.stageY < Globals.g_app.tabHeight() + Globals.g_app.logoHeight() && me.stageY - _clickPoint < 5 )
			return;
			
		// _dragDistance is calculated in the last mouseMove event
		listOffsetAdjust( _dragDistance );
		
		if ( _drag )
		{
			if ( listHasMomentum() )
			{
				var swipeTime:Float = Lib.getTimer() - _time;
				_swipeSpeed = _dragDistance / swipeTime ; // * 500;
				_swipeSpeed *= 10;
				_swipeSpeed = Math.min( _swipeSpeed, 15 );
				//trace( "swipeSpeed: " + _swipeSpeed + "  change: " + _dragDistance + "  swipeTime: " + swipeTime );
			}

			// drag is done, reset data
			_drag = false;
			_dragDistance = 0;
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
	
//	public var _temp:Item = null;
	private function onEnter(e:Event):Void
	{
		//_temp.setText( "2" );
		//_window.addChild( _temp );
		//_temp.setText( Std.string( Std.parseInt( _temp._textField.text ) + 1) );
		
		if ( 0 != _swipeSpeed && true != _drag )
		{	
			_swipeSpeed = 0.95 * _swipeSpeed;
			//trace( "decay swipeSpeed: " + _swipeSpeed );
			if ( 0.1 > Math.abs( _swipeSpeed ) )
				_swipeSpeed = 0;
			
			listOffsetAdjust( _swipeSpeed );

			listDraw( _listOffset, false );
		}
	}
	
	private function mouseMoveHandler( me:MouseEvent ):Void
	{
		if ( 5 < Math.abs( _clickPoint - me.stageY ) )
		{
			// only set the start time on the first message
			if ( false == _drag )
				_time = Lib.getTimer();
				
			_drag = true;
		}
	
		if ( _drag )
		{
			_swipeSpeed = 0;
			_dragDistance = _clickPoint - me.stageY;
		
			// is list at bottom?
			if ( _maxOffset < _listOffset + _dragDistance )
			{
				// end of list
				listDraw( _maxOffset, false );
			}
			else
			{
				// Beginning of list
				if ( _listOffset + _dragDistance < 0 )
					listDraw( 0, false );
				else
				{
					// middle of list
					listDraw( _listOffset + _dragDistance, false ); // middle of list
				}
			}
		}
	}
	
	public function selectionHandler():Void
	{
		throw ( "IListWindow.selectionHandler - VIRTUAL FUNCTION WHICH SHOULD BE OVERRIDDEN" );
		_em.removeAllEvents();
		var ndyw:NotDoneYetWindow = NotDoneYetWindow.instance();
		ndyw.populate();
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
}