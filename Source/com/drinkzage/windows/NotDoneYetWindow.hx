package com.drinkzage.windows;

import com.drinkzage.Globals;
import nme.display.Sprite;
import nme.display.Stage;

import nme.events.MouseEvent;
import nme.events.Event;
import nme.errors.Error;

import nme.text.TextField;
import nme.text.TextFormat;
import nme.text.TextFormatAlign;
import nme.text.Font;

import nme.filters.GlowFilter;
import nme.Assets;

import com.drinkzage.windows.Item;

import com.drinkzage.utils.Utils;
import com.drinkzage.windows.TabConst;

/**
 * @author Robert Flesch
 */
class NotDoneYetWindow extends ItemFinalWindow {
	
	private static var _instance:NotDoneYetWindow = null;
	private static var _tabSelected:Dynamic;
	
	public static function instance():NotDoneYetWindow
	{ 
		if ( null == _instance )
			_instance = new NotDoneYetWindow();
			
		return _instance;
	}


	public function new () 
	{
		super();
		
		_tabs.push( "Back" );
		
		_tabSelected = TabDefault.Back;
	}
	
	override public function populate( item:Item ):Void
	{
		_item = new Item( "Not Done Yet" );
		super.populate( _item );
	}
	
	override public function itemDraw():Void
	{
		trace( "NotDoneYetWindow.populate - name: " + _item._name );
		
		var width:Float = _stage.stageWidth;
		var height:Float = _stage.stageHeight;
		
		var font = Assets.getFont ("assets/VeraSeBd.ttf");
		var format = new TextFormat (font.fontName, 60, 0xFF0000);
		format.align = TextFormatAlign.CENTER;
		var name:TextField = new TextField();
		name.wordWrap = true;
		name.defaultTextFormat = format;
		name.selectable = false;
		name.embedFonts = true;
		name.x = width*5/8;
		name.y = Globals.g_app.logoHeight() + Globals.g_app.tabHeight();
		name.text = _item._name;
		name.width = height - name.y - 1;
		name.height = width *2 /3;
		name.rotation = 90;
		_window.addChild( name );
	}
	
	override public function tabHandler( me:MouseEvent ):Void
	{
		if ( me.stageY >= Globals.g_app.tabHeight() + Globals.g_app.logoHeight() )
			return;
			
		backHandler();	
	}
	
	override public function backHandler():Void
	{
		super.backHandler();
		Globals.g_app.populate();
	}
}
