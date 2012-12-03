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
	private var _parent:Dynamic;
	//private var _tabs:Vector<String>;
	
	public function new () 
	{
		super();
		
		//_tabs = new Vector<String>();
		
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
		_countTextField.width = 200;
		_countTextField.setTextFormat( _countTextFormat );	

		var width:Float = _stage.stageWidth;
		var height:Float = _stage.stageHeight;
		
		_countTextField.x = width + 10;
		_countTextField.y = height / 2 - 30;
		
	}
	
	public function setItem( item:Item ):Void
	{
		_item = item;
	}
	
	override public function populate():Void
	{
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
		name.text = _item._name;
		name.width = height;
		name.height = width * 2 / 3;
		
		name.rotation = 90;
		name.addEventListener (FocusEvent.FOCUS_IN, TextField_onFocus);
		
		_window.addChild( name );

	}
	
	public function TextField_onFocus( event:Event ): Void
	{
		var textField:TextField = event.currentTarget;
		textField.type = TextFieldType.INPUT;
		textField.addEventListener (FocusEvent.FOCUS_OUT, TextField_loseFocus);
	}
	
	public function TextField_loseFocus( event:Event ): Void
	{
		var textField:TextField = event.currentTarget;
		textField.type = TextFieldType.DYNAMIC;
		textField.removeEventListener (FocusEvent.FOCUS_OUT, TextField_loseFocus);
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
