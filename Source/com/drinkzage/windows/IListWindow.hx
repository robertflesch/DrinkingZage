package com.drinkzage.windows;

import nme.display.Bitmap;
import nme.Lib;
import nme.Vector;
import nme.display.DisplayObject;
import nme.display.Sprite;

import nme.events.Event;
import nme.events.MouseEvent;
import nme.events.KeyboardEvent;

import nme.text.TextField;
import nme.text.TextFormat;
import nme.text.TextFormatAlign;

import com.drinkzage.Globals;
import com.drinkzage.windows.IChildWindow;
import com.drinkzage.windows.DataTextField;
import com.drinkzage.utils.Utils;
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
	private var _item:Item = null;					// Selected item or null
	private var _maxComponents:Int = 0;
	private var _components:Vector<Sprite> = null;
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

		_maxOffset = _items.length * componentHeight() - (_stage.stageHeight - tabHeight() - logoHeight());
		_maxOffset += tabHeight() + ListWindowConsts.FUDGE_FACTOR; // Fudge factor
		
		var drawableArea:Float = _stage.stageHeight - tabHeight() - logoHeight() - ( getUseSearch() ? searchHeight() : 0 );
		var maxVisibleComponents:Float = drawableArea / componentHeight() + 0.5;
		// Add in one extra for when partial components at top and bottom as visible
		_maxComponents = Std.int( maxVisibleComponents ) + 1;
	
		if ( null == _components )
			createComponents();
		
		removeAllChildrenAndDrawLogo();		
		
		// need to duplicate functionality of parent
		// because list drawn need to come before tab and search
		listDraw( _listOffset );
		
		_tabHandler = tabHandler;
		tabsDraw( _tabs, _tabSelected );
		
		
		if ( getUseSearch() )
			searchDraw();

		_em.addEvent( _stage, KeyboardEvent.KEY_UP, onKeyUp );
		_em.addEvent( _stage, MouseEvent.MOUSE_DOWN, mouseDownHandler );
		_em.addEvent( _stage, Event.ENTER_FRAME, onEnter );
	}	
	
	static inline private var BASE_TEXT_FIELD = 0;
	static inline private var TEXT_FIELD = 1;
	static inline private var FAV_ICON = 2;
	static inline private var ICON_ACTIVE = 0;
	static inline private var ICON_INACTIVE = 1;
	public function createComponents():Void
	{
		if ( null == _tf )
		{
			_tf = new TextFormat("_sans");
			_tf.size = 36;                // set the font size
			_tf.align = TextFormatAlign.CENTER;
			_tf.color = 0xFF0000;           // set the color
		}
		
		_components = new Vector<Sprite>();
		for ( i in 0..._maxComponents )
		{
			_components.push( new Sprite() );

			var outlineField:DataTextField = new DataTextField();
			//outlineField.border = true;
			//outlineField.borderColor = 0xffffff;
			_components[i].addChildAt( outlineField, BASE_TEXT_FIELD );
			
			var textField:DataTextField = new DataTextField();
			textField.height = componentHeight();
//			textField.text = name;
			textField.background = true;
			textField.backgroundColor = 0x000000;
			//textField.border = false;
			//textField.borderColor = 0xffffff;
			textField.selectable = false;
			_components[i].addChildAt( textField, TEXT_FIELD );
			//_components[i].name = "item";
			
			var icon:Sprite = new Sprite();
			icon.name = "fav.png";
			addImage( icon, "assets/fav_icon.png", ICON_ACTIVE );
			addImage( icon, "assets/fav_not_icon.png", ICON_INACTIVE );
				
			_components[i].addChildAt(icon, FAV_ICON);
		}
	}
	
	private function addImage( container:Sprite, image:String, index:Int ):Void
	{
		var icon:Bitmap = Utils.loadGraphic( image );
		icon.height = icon.width = componentHeight();
		icon.visible = false;
		container.addChildAt( icon, index );
	}
	
	private function favoriteToggle( event:MouseEvent ):Void
	{
		var item:Item = findSelectedItem();
		var icon:Sprite = event.target;
		if ( true == icon.getChildAt( ICON_ACTIVE ).visible )
		{
			if ( null != item )
			{
				item.setFav( false );
				Globals.g_itemLibrary.setItemAsFavorite( item, false );
			}
			icon.getChildAt( ICON_ACTIVE ).visible = false;
			icon.getChildAt( ICON_INACTIVE ).visible = true;
		}
		else
		{
			if ( null != item )
			{
				item.setFav( true );
				Globals.g_itemLibrary.setItemAsFavorite( item, true );
			}
			icon.getChildAt( ICON_ACTIVE ).visible = true;
			icon.getChildAt( ICON_INACTIVE ).visible = false;
		}
		
	}
	
	private function setComponentValues( displyObject:Sprite, item:Item, i:Int, countDrawn:Int, offset:Float, remainder:Float ):Void
	{
		var tf:DataTextField = cast( displyObject.getChildAt( TEXT_FIELD ), DataTextField );
		tf.text = item.name();
		tf.setTextFormat(_tf);
		tf.name = Std.string( i );
		tf.x = componentHeight();
//		tf.x = ListWindowConsts.GUTTER;
		tf.y = countDrawn * componentHeight() + offset - remainder;
//		tf.width = _stage.stageWidth - ListWindowConsts.LIST_GUTTER * 2;
		tf.width = _stage.stageWidth - ListWindowConsts.LIST_GUTTER * 2 - tf.x;
		tf.setData( item );
		
		var icon:Sprite = cast( displyObject.getChildAt( FAV_ICON ), Sprite );
		icon.x = ListWindowConsts.LIST_GUTTER;
		icon.y = countDrawn * componentHeight() + offset - remainder;
		if ( item.fav() )
		{
			icon.getChildAt( ICON_ACTIVE ).visible = true;
			icon.getChildAt( ICON_INACTIVE ).visible = false;
		}
		else
		{
			icon.getChildAt( ICON_ACTIVE ).visible = false;
			icon.getChildAt( ICON_INACTIVE ).visible = true;
		}
	}
	
	private function applyFilter():Void
	{
		// override this to apply a custom filter
		// just make sure everything is visible
		Globals.g_itemLibrary.resetVisiblity( _items );
	}
	
	private function listDraw( scrollOffset:Float, isListRefresh:Bool = true ):Void
	{
		for ( j in 0..._maxComponents )
			_components[j].visible = false;

		// this gives decendants a choice of what items they want to display
		applyFilter();
		
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
				if ( true == item.isVisible() )
				{
					_components[countDrawn].visible = true;
					
					setComponentValues( _components[countDrawn], item, i, countDrawn, offset, remainder );
					
					if ( _components[countDrawn].y + logoHeight() > _stage.stageHeight )
						break;
					
					// We dont want to readd component, since that brings it to the front, and we want it to stay behind the search and tabs
					if ( isListRefresh )
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
		if ( me.stageY < tabHeight() + logoHeight() && me.stageY - _clickPoint < 5 )
			return;
			
		if ( me.stageX < componentHeight() )
		{
			favoriteToggle( me );
			return;
		}
		
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
			_item = null;
			_item = findSelectedItem();
			if ( null != _item )
				selectionHandler();
		}
	}

	private function findSelectedItem():Item
	{
		var remainder:Float = _listOffset % componentHeight();
		// where did I click in the client area?
		var relativeClickPoint:Float = (_clickPoint - tabHeight() - logoHeight());
		// this gets the component index from where I clicked
		var componentIndex:Int = Std.int((remainder + relativeClickPoint) / componentHeight());
		var item:Item = null;
		if ( componentIndex <= Std.int( _components.length ) )
			item = cast( _components[componentIndex].getChildAt(TEXT_FIELD), DataTextField ).getData();
			
		return item;	
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
	
	private function resetItems():Void
	{
		var itemCount:Int = _items.length;
		for ( i in 0...itemCount )
		{
			_items.pop();
		}
	}

}