package com.drinkzage.windows;

import nme.Vector;

import nme.display.Sprite;
import nme.display.Bitmap;
import nme.display.Stage;

import nme.events.MouseEvent;
import nme.events.Event;

import com.drinkzage.utils.Utils;

/**
 * @author Robert Flesch
 */
class LiquorChoice extends ITabListWindow
{
	static inline var GUTTER:Float = 10;
	static inline var CHOICES:Int = 2;
	private var _ChoiceButtons:Vector<ChoiceButton>;
	
	private static var _instance:LiquorChoice = null;
	
	public static function instance():LiquorChoice
	{ 
		if ( null == _instance )
			_instance = new LiquorChoice();
			
		return _instance;
	}
	
	public function new () 
	{
		super();
		
		_tabs.push( "BACK" );
		
		createList();
	}
	
	override public function listDraw( scrollOffset:Float ):Void
	{
		var width:Float = _stage.stageWidth;
		var height:Float = (_stage.stageHeight - Globals.g_app.logoHeight() - Globals.g_app.tabHeight())/CHOICES;

		for ( i in 0...CHOICES )
		{
			var graphic:Sprite = Utils.loadGraphic ( "assets/" + _ChoiceButtons[ i ]._image, true );
			graphic.name = Std.string( i );
			graphic.x = GUTTER;
			graphic.y = i * height + GUTTER + Globals.g_app.logoHeight() + Globals.g_app.tabHeight();
			graphic.width = width - (GUTTER * CHOICES);
			graphic.height = height - (GUTTER * CHOICES);
			graphic.addEventListener( MouseEvent.CLICK, liquorChoiceMouseDownHandler);
			_window.addChild(graphic);
		}
	}
	
	private function liquorChoiceMouseDownHandler( me:MouseEvent ):Void
	{
		var index:Int = me.target.name;
		switch ( index )
		{
			case 0: // Shots
				var slw:ShotListWindow = ShotListWindow.instance();
				slw.setBackHandler( this );
				slw.populate();
			case 1: // Mixed Drinks
				var mlw:MixedDrinkListWindow = MixedDrinkListWindow.instance();
				mlw.setBackHandler( this );
				mlw.populate();
		}
	}
	
	override public function createList():Void
	{
		_ChoiceButtons = new Vector<ChoiceButton>();
		_ChoiceButtons.push( new ChoiceButton( "Shots", "shot.jpg" ) );
		_ChoiceButtons.push( new ChoiceButton( "Liquor", "liquor.jpg" ) );
	}
}

class ChoiceButton
{
	public var _text:String;
	public var _image:String;
	
	public function new( text:String, image:String )
	{
		_text = text;
		_image = image;
	}
}

