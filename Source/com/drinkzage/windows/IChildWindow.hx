package com.drinkzage.windows;

import nme.Lib;

import nme.display.Stage;
import nme.display.Sprite;
import nme.display.DisplayObject;

import nme.events.MouseEvent;

import com.drinkzage.Globals;
import com.drinkzage.DrinkingZage;
import com.drinkzage.events.EventManager;
import com.drinkzage.utils.Utils;

/**
 * @author Robert Flesch
 */
class IChildWindow
{
	private var _stage:Stage = null;
	private var _window:DrinkingZage = null;
	private var _em:EventManager = null;
	
	private var _searchBut:Sprite = null;
	private var _customBut:Sprite = null;
	
	private function new () 
	{
		_stage = Globals.g_stage;
		_window = Globals.g_app;
		_em = new EventManager();
	}
	
	private function logoDraw():Void
	{
		//trace( "DrinkZage.logoDraw" );
		var logo:Sprite = Utils.loadGraphic ( "assets/logo.jpg", true );
		logo.name = "DrinkZage Logo";
		logo.width = Lib.current.stage.stageWidth;
		logo.height = logoHeight();
		_window.addChild(logo);
	}
	
	public function tabHeight():Float
	{
		return ListWindowConsts.TAB_HEIGHT * Lib.current.stage.stageHeight;
	}
	
	public function logoHeight():Float
	{
		return LogoConsts.LOGO_SCALE * Lib.current.stage.stageHeight;
	}
	
	public function componentHeight():Float
	{
		return ListWindowConsts.COMPONENT_HEIGHT * Lib.current.stage.stageHeight;
	}

	public function searchHeight():Float
	{
		var returnVal:Float = ListWindowConsts.COMPONENT_HEIGHT * Lib.current.stage.stageHeight;
		return returnVal;
	}
	
	public function drawableHeight():Float
	{
		return (Globals.g_stage.stageHeight - logoHeight() - tabHeight());
	}
	
	public function searchDraw():Void
	{
		//_customBut = Utils.loadGraphic ( "assets/custom.png", true );
		//_customBut.name = "customBut";
		//_customBut.y = Lib.current.stage.stageHeight - _customBut.height;
		//_customBut.x = 0;
		//_customBut.width = Lib.current.stage.stageWidth;
		//_customBut.addEventListener( MouseEvent.CLICK, searchDrinkClickHandler);
		//this.addChild(_customBut);
		
		if ( null == _searchBut )
		{
			_searchBut = Utils.loadGraphic ( "assets/search.jpg", true );
			_searchBut.name = "searchBut";
			_searchBut.y = Lib.current.stage.stageHeight - _searchBut.height;
			_searchBut.x = 0;
			_searchBut.width = Lib.current.stage.stageWidth;
			// This is a special case of add event, since this button lives from screen to screen
			// we want to leave this listener attached to it.
			_searchBut.addEventListener( MouseEvent.CLICK, searchDrinkClickHandler);
		}
		_window.addChild(_searchBut);
	}
	
	private function searchDrinkClickHandler( me:MouseEvent )
	{
		//trace("searchDrinkClickHandler");
		_em.removeAllEvents();
		var sw:SearchWindow = SearchWindow.instance();
		sw.setBackHandler( this );
		sw.populate();
	}

	public function removeAllChildrenAndDrawLogo():Void
	{
		// remove ALL items from the display list
		for ( i in 0..._window.numChildren )
		{
			_window.removeChildAt( 0 );
		}

		logoDraw();
	}
	
	public function traceChildNames():Void
	{
		trace( "IChildWindow.dumpChildNames: " + _window.numChildren );
		for  ( j in 0... _window.numChildren )
		{
			var item:DisplayObject = _window.getChildAt(j);
			trace ( item.name );
		}
	}
}