﻿package com.drinkzage.windows;

import nme.display.Bitmap;
import nme.Vector;
import nme.Lib;
import com.drinkzage.utils.Utils;
import nme.display.Sprite;

import nme.text.TextField;
import nme.text.TextFormat;
import nme.text.TextFormatAlign;

import nme.events.MouseEvent;
import nme.events.KeyboardEvent;

import com.drinkzage.Globals;
import com.drinkzage.windows.TabConst;

/**
 * @author Robert Flesch
 */
class ITabWindow extends IChildWindow
{
	private static var TAB_COUNT:Int = 6;
	private var _tabs:Vector<String>;
	private var _tabSelected:Dynamic;
	private var _tabHandler:Dynamic -> Void;
	
	private var _tabSprites:Vector<Sprite> = null;
	private var _tabTextFields:Vector<TextField> = null;
	private var _tabTextFormat:TextFormat = null;
	
	private var _lastClickTime:Float = 0;

	private var _useSearch ( getUseSearch, setUseSearch ):Bool = true;
	function getUseSearch():Bool { return _useSearch; }
	function setUseSearch( val:Bool ):Bool { return _useSearch = val; }

	private var _backHandler(getBackHandler, setBackHandler):Dynamic = null;
	function getBackHandler():Dynamic { return _backHandler; }
	public function setBackHandler( val:Dynamic ):Dynamic 
	{ 
		//trace( "setBackHandler: " + val );  
		return _backHandler = val; 
	}

	private function new () 
	{
		_backHandler = null;
		_tabHandler = null;
		_tabs = new Vector<String>();
		_tabSelected = TabDefault.Back;
		
		_tabSprites = new Vector<Sprite>();
		for ( i in 0...TAB_COUNT )
		{
			_tabSprites[i] = new Sprite();
		}
		
		_tabTextFields = new Vector<TextField>();
		for ( i in 0...TAB_COUNT )
		{
			_tabTextFields[i] = new TextField();
			_tabTextFields[i].selectable = false;
			//_tabTextFields[i].border = true;
			//_tabTextFields[i].borderColor = 0xffff00;
		}

		_tabTextFormat = new TextFormat("_sans");
		_tabTextFormat.size = 28;
		_tabTextFormat.align = TextFormatAlign.CENTER;
		_tabTextFormat.color = 0xffffff;
		
		super();
	}
	
	// add the tabs and search button
	public function populate():Void
	{
		removeAllChildrenAndDrawLogo();		
		_tabHandler = tabHandler;
		tabsDraw( _tabs, _tabSelected );
		
		_em.addEvent( _stage, KeyboardEvent.KEY_UP, onKeyUp );
		
		if ( getUseSearch() )
			searchDraw();
	}

	public function tabsRefresh():Void
	{
		var width:Float = Lib.current.stage.stageWidth;
		var tabCount:Int = _tabs.length;
		for ( i in 0...tabCount )
		{
			//trace( "tabsRefresh: " + i );
			_tabSprites[i].getChildAt(0).visible = false;
			_tabSprites[i].getChildAt(1).visible = false;
			if ( i == Type.enumIndex( _tabSelected ) )
				_tabSprites[i].getChildAt(0).visible = true;
			else
				_tabSprites[i].getChildAt(1).visible = true;
		}
		
	}
	
	public function tabsDraw( tabs:Vector<String>, tabSelected:Dynamic ):Void
	{
		// have to remove old event listeners
//		_em.removeAllEvents();
		
		for ( ts in 0..._tabSprites.length )
		{
			_tabSprites[ts] = null;
		}
		
		var tabCount:Int = tabs.length;
		var width:Float = Lib.current.stage.stageWidth;
		
		for ( i in 0...tabCount )
		{
			//trace( "tabsDraw: " + i );
			// load both images onto tab
			_tabSprites[i] = Utils.loadGraphic( "assets/" + "tab_active.png", true );
			var bm:Bitmap = Utils.loadGraphic( "assets/" + "tab_inactive.png" );
			_tabSprites[i].addChildAt( bm, 1 );
				
			_tabSprites[i].x = i * width / tabCount;
			_tabSprites[i].y = logoHeight();
			_tabSprites[i].height = tabHeight();			
			_tabSprites[i].width =  width / tabCount;
			_tabSprites[i].name = Std.string( i );
			Globals.g_app.addChild( _tabSprites[i] );

			_tabTextFields[i].text = tabs[ i ];
			_tabTextFields[i].setTextFormat(_tabTextFormat);
			_tabTextFields[i].name = Std.string( i );
			_tabTextFields[i].x = i * width / tabCount;
			_tabTextFields[i].y = logoHeight() + tabHeight()/3;
			_tabTextFields[i].height = tabHeight()* 2/3;			
			_tabTextFields[i].width =  width / tabCount;
			_em.addEvent( _tabTextFields[i], MouseEvent.CLICK, _tabHandler );
			Globals.g_app.addChild(_tabTextFields[i]);
		}
		
		tabsRefresh();
	}
	
	
	// This should be overridden if more then the back tab is used
	private function tabHandler( me:MouseEvent ):Void
	{
		//trace( "ITabWindow.tabHandler: " + me );
		if ( me.stageY >= tabHeight() + logoHeight() )
			return;
		
		backHandler();
	}
	
	public function backHandler():Void 
	{ 
		if ( 750 < ( Lib.getTimer() - _lastClickTime ) )
		{
			//trace( "backHandler executed" );
			_lastClickTime = Lib.getTimer();
			//removeListeners();
			_em.removeAllEvents();
			if ( null == _backHandler )
				throw "ITabWindow.backHandler - ERROR - MISSING VALID BACKHANDLER";
			_backHandler.populate(); 
		}
		//else 
		// trace( "backHandler disable due to time" );
	}
	
	// this intercepts the ESC or BACK key (Android)
	// And calls the back handler to move to parent window
	function onKeyUp( event:KeyboardEvent ):Void
	{
		//trace( "ITabWindow.onKeyUp - key: " + event.keyCode );
		if ( Globals.BACK_BUTTON == event.keyCode )
		{
			//trace( "ITabWindow.onKeyUp - BACK_BUTTON: " + event.keyCode );
			backHandler();
			event.stopImmediatePropagation();
		}
	}
}

