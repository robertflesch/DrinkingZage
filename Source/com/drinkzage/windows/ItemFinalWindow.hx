package com.drinkzage.windows;

import nme.Assets;
import nme.Vector;

import nme.display.Bitmap;
import nme.display.BitmapData;
import nme.display.DisplayObject;
import nme.display.Sprite;
import nme.display.Stage;

import nme.events.MouseEvent;
import nme.events.FocusEvent;
import nme.events.Event;
import nme.events.KeyboardEvent;

import nme.errors.Error;

import nme.filters.GlowFilter;

import nme.geom.Matrix;

import nme.text.TextField;
import nme.text.TextFormat;
import nme.text.TextFormatAlign;
import nme.text.Font;
import nme.text.TextFieldType;

import com.drinkzage.Globals;

import com.drinkzage.utils.Utils;

import com.drinkzage.windows.Item;
import com.drinkzage.windows.LogoConsts;
import com.drinkzage.windows.TabConst;
import com.drinkzage.windows.ITabWindow;

/**
 * @author Robert Flesch
 */
class ItemFinalWindow extends ITabWindow {
	
	private var _countTextField:TextField;
	private var _countTextFormat:TextFormat;
	private var _item:Item;
	
	public function new () 
	{
		super();
		
		createCount();
	}
	
	public function setItem( item:Item ):Void
	{
		_item = item;
	}
	
	public function createCount():Void
	{
		var font = Assets.getFont ("assets/VeraSeBd.ttf");
		_countTextFormat = new TextFormat (font.fontName, 150, 0xffff00);
		_countTextFormat.align = TextFormatAlign.CENTER;
		
		_countTextField = new TextField();
		_countTextField.selectable = false;
		_countTextField.embedFonts = true;
		_countTextField.text = "1";
		_countTextField.selectable = false;
		_countTextField.rotation = 90;
		_countTextField.height = 200;
		_countTextField.width = 300;
		_countTextField.setTextFormat( _countTextFormat );	

		var width:Float = _stage.stageWidth;
		var height:Float = _stage.stageHeight;
		
		_countTextField.x = width + 10;
		//_countTextField.y = height / 2 - 30;
		_countTextField.y = height / 2 - 100;
	}
	
	override public function populate():Void
	{
		trace( "ItemFinalWindow.populate" );
		if ( null == _item )
		{
			trace( "ItemFinalWindow.populate - NULL ITEM" );
			throw "ItemFinalWindow.populate - NULL ITEM";
		}
		
		setUseSearch( false );
		super.populate();
		
		itemDraw();
		countDraw();
	}
	
	public function countDraw():Void
	{
		var width:Float = _stage.stageWidth;
		var height:Float = _stage.stageHeight;
		
		_window.addChild( _countTextField );
		
		var plus:Sprite = Utils.loadGraphic ( "assets/plus.png", true );
		plus.name = "plus";
		plus.width = 128 / 480 * width;
		plus.height = 128 / 854 * height;
		plus.x = width - 140;
		plus.y = Globals.g_app.logoHeight() + Globals.g_app.tabHeight() + height/20;
		plus.addEventListener( MouseEvent.MOUSE_DOWN, plusHandler );
		_window.addChild(plus);
		
		var minus:Sprite = Utils.loadGraphic ( "assets/minus.png", true );
		minus.name = "minus";
		minus.width = 128 / 480 * width;
		minus.height = 128 / 854 * height;
		minus.x = width - 140;
		minus.y = height - 170;
		minus.addEventListener( MouseEvent.MOUSE_DOWN, minusHandler );
		_window.addChild(minus);
	}
	
	public function itemDraw():Void
	{
		trace( "ItemFinalWindow.itemDraw - name: " + _item.name() );
		
		var width:Float = _stage.stageWidth;
		var height:Float = _stage.stageHeight;
		height = height - Globals.g_app.tabHeight() - Globals.g_app.logoHeight();
		
		var font = Assets.getFont ("assets/VeraSeBd.ttf");
		var format = new TextFormat (font.fontName, 120, 0xFF0000);
		
		var MAX_CHARS:Int = 10;
		format.size = height / MAX_CHARS;

		format.align = TextFormatAlign.CENTER;
		var name:TextField = new TextField();
		name.wordWrap = true;
		name.defaultTextFormat = format;
		name.embedFonts = true;
		name.x = width*5/8;
		name.y = Globals.g_app.logoHeight() + Globals.g_app.tabHeight();
		name.text = _item.name();
		name.width = height;
		name.height = width * 2 / 3;
		
		name.rotation = 90;
		name.addEventListener (MouseEvent.CLICK, onClickHander );
		//name.addEventListener (FocusEvent.FOCUS_IN, onFocusHandler );
		
		_window.addChild( name );

	}
	
	public function onClickHander( event:MouseEvent ): Void
	{
		trace( "ClickHander" );
		var textField:TextField = event.currentTarget;
		var ctiw:CustomTextInputWindow	= CustomTextInputWindow.instance();
		ctiw.setItem( new Item( textField.text, null ) );
		ctiw.setBackHandler( this );
		ctiw.populate();
	}
	
	public function onFocusHandler( event:FocusEvent ): Void
	{
		trace( "FocusHandler" );
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

	public function BitmapScaled(do_source:Bitmap, thumbWidth:Int, thumbHeight:Int):BitmapData 
	{
		var mat:Matrix = new Matrix();
		mat.scale(thumbWidth / do_source.width, thumbHeight / do_source.height);
		// doesnt like this, gives me a grey image... RSF
		// mat.rotate( 90 );
		var bmpd_draw:BitmapData = new BitmapData( thumbWidth, thumbHeight, false);
		bmpd_draw.draw(do_source, mat, null, null, null, true);
		return bmpd_draw;
	}	
}
