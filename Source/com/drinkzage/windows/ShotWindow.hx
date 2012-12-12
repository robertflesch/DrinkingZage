package com.drinkzage.windows;

import nme.events.MouseEvent;

import nme.Assets;
import com.drinkzage.utils.
import nme.display.Bitmap;
import nme.geom.Matrix;
import nme.display.BitmapData;
import nme.display.DisplayObject;


/**
 * @author Robert Flesch
 */
class ShotWindow extends ItemFinalWindow {
	
	private static var _instance:ShotWindow = null;
	
	public static function instance():ShotWindow
	{ 
		if ( null == _instance )
			_instance = new ShotWindow();
			
		return _instance;
	}

	public function new () 
	{
		super();
		_tabs.push( "BACK" );
	}

	override public function itemDraw():Void
	{
		// This draws the image of the drink in the background
		var width:Int = _stage.stageWidth;
		var height:Int = _stage.stageHeight;
		var drawableHeight = height - Globals.g_app.logoHeight() - Globals.g_app.tabHeight();

		//var bottleImage1:Bitmap;
		//bottleImage1 = new Bitmap (Assets.getBitmapData ("assets/shot.png"));
		//bottleImage1.bitmapData = BitmapScaled( bottleImage1, width, width );
		//bottleImage1.rotation = 90;
		//bottleImage1.x = width;
		//bottleImage1.y = drawableHeight / 2 - bottleImage1.width / 2 + Globals.g_app.logoHeight() + Globals.g_app.tabHeight();
		//bottleImage1.alpha = 0.5;
		//_window.addChild( bottleImage1 );
		
		var icon:Sprite = Utils.loadGraphic ( "assets/shot.png" );
		icon.name = Std.string( i );

		super.itemDraw();
	}
	
}
