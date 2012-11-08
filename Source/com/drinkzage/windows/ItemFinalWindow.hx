﻿package com.drinkzage.windows;

import com.drinkzage.Globals;
import nme.display.Sprite;
import nme.display.Stage;

import nme.events.MouseEvent;
import nme.events.Event;
import nme.events.KeyboardEvent;
import nme.errors.Error;

import nme.text.TextField;
import nme.text.TextFormat;
import nme.text.TextFormatAlign;
import nme.text.Font;

import nme.filters.GlowFilter;
import nme.Assets;
import nme.Vector;

import com.drinkzage.windows.Item;

import com.drinkzage.utils.Utils;
import com.drinkzage.windows.LogoConsts;
import com.drinkzage.windows.TabConst;
/**
 * @author Robert Flesch
 */
class ItemFinalWindow {
	
	private var _countTextField:TextField;
	private var _countTextFormat:TextFormat;
	private var _stage:Stage;
	private var _window:DrinkingZage;
	private var _item:Item;
	private var _parent:Dynamic;
	private var _tabs:Vector<String>;
	
	public function new () 
	{
		_stage = Globals.g_stage;
		_window = Globals.g_app;
		
		_tabs = new Vector<String>();
		
		var font = Assets.getFont ("assets/VeraSeBd.ttf");
		_countTextFormat = new TextFormat (font.fontName, 200, 0xffff00);
		_countTextFormat.align = TextFormatAlign.CENTER;
		
		_countTextField = new TextField();
		_countTextField.selectable = false;
		_countTextField.embedFonts = true;
		_countTextField.text = "1";
		_countTextField.selectable = false;
		_countTextField.rotation = 90;
		_countTextField.height = 200;
		_countTextField.width = 200;
		_countTextField.setTextFormat( _countTextFormat );	

		var width:Float = _stage.stageWidth;
		var height:Float = _stage.stageHeight;
		
		_countTextField.x = width;
		_countTextField.y = height / 2 - 30;
		
	}
	
	public function addListeners():Void
	{
		_stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown );	
	}
	
	public function removeListeners():Void
	{
		_stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown );				
	}
	
	public function populate(item:Item):Void
	{
		addListeners();
		
		_window.prepareNewWindow();
		_item = item;
		itemDraw();
		countDraw();
		_window.tabsDraw( _tabs, TabDefault.Back, tabHandler );
	}
	
	public function countDraw():Void
	{
		var width:Float = _stage.stageWidth;
		var height:Float = _stage.stageHeight;
		
		_window.addChild( _countTextField );
		
		var plus:Sprite = Utils.loadGraphic ( "assets/plus.png", true );
		plus.name = "plus";
		plus.x = width - 140;
		plus.y = Globals.g_app.logoHeight() + Globals.g_app.tabHeight() + height/20;
		plus.addEventListener( MouseEvent.MOUSE_DOWN, plusHandler );
		_window.addChild(plus);
		
		var minus:Sprite = Utils.loadGraphic ( "assets/minus.png", true );
		minus.name = "minus";
		minus.x = width - 140;
		minus.y = height - 140;
		minus.addEventListener( MouseEvent.MOUSE_DOWN, minusHandler );
		_window.addChild(minus);
	}
	
	public function itemDraw():Void
	{
		trace( "ItemFinalWindow.populate - name: " + _item._name );
		
		var width:Float = _stage.stageWidth;
		var height:Float = _stage.stageHeight;
		
		var font = Assets.getFont ("assets/VeraSeBd.ttf");
		var format = new TextFormat (font.fontName, 120, 0xFF0000);
		format.align = TextFormatAlign.CENTER;
		var name:TextField = new TextField();
		name.wordWrap = true;
		name.defaultTextFormat = format;
		name.selectable = false;
		name.embedFonts = true;
		//name.border = true;
		//name.borderColor = 0x00FF00;
//		name.x = width*2/3;
		name.x = width*5/8;
		name.y = Globals.g_app.logoHeight() + Globals.g_app.tabHeight();
		name.text = _item._name;
		name.width = height - name.y - 1;
		name.height = width *2 /3;
		name.rotation = 90;
		_window.addChild( name );

	}
	
	private function headerDraw():Void
	{
		var tab:Sprite = Utils.loadGraphic( "assets/tab_active.png", true );
		tab.x = 0;
		tab.y = Globals.g_app.logoHeight();
		tab.width =  _window.width;
		tab.height = Globals.g_app.tabHeight();
		tab.addEventListener( MouseEvent.CLICK, tabHandler );
		tab.name = "0";

		var text : TextField = new TextField();
		text.text = "Back";
		text.height = Globals.g_app.tabHeight();
		text.name = "0";
		text.width = tab.width;
		text.y = text.height / 4;
		text.x = 30;
		//text.x = text.width/2 - 10;
		text.selectable = false;
		
		var ts:TextFormat = new TextFormat("_sans");
		ts.size = 16;                // set the font size
		//ts.align = TextFormatAlign.CENTER;
		ts.color = 0xffffff;
		text.setTextFormat(ts);
		tab.addChild(text);
		
		_window.addChild( tab );
	}
	
	public function tabHandler( me:MouseEvent ):Void
	{
		if ( me.stageY >= Globals.g_app.tabHeight() + Globals.g_app.logoHeight() )
			return;
		
		backHandler();
	}
	
	function onKeyDown( event:KeyboardEvent )
	{
		if ( Globals.BACK_BUTTON == event.keyCode )
		{
			backHandler();
			return;
		}
	}
	
	public function backHandler():Void
	{
		removeListeners();
	}
	
	private function plusHandler( me:MouseEvent ):Void
	{
		var count:Int = Std.parseInt( _countTextField.text );
		if ( 0 < count )
		{
			_countTextField.text = Std.string( ++count );
			_countTextField.setTextFormat( _countTextFormat );
		}
	}
	
	private function minusHandler( me:MouseEvent ):Void
	{
		var count:Int = Std.parseInt( _countTextField.text );
		if ( 1 < count )
		{
			_countTextField.text = Std.string( --count );
			_countTextField.setTextFormat( _countTextFormat );
		}			
	}
}