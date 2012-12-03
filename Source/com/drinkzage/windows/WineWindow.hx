package com.drinkzage.windows;


import nme.events.MouseEvent;

import nme.Assets;
import nme.display.Bitmap;

/**
 * @author Robert Flesch
 */
class WineWindow extends ItemFinalWindow {
	
	private static var _instance:WineWindow = null;
	
	public static function instance():WineWindow
	{ 
		if ( null == _instance )
			_instance = new WineWindow();
			
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

		var bottleImage1:Bitmap;
		bottleImage1 = new Bitmap (Assets.getBitmapData ("assets/wine.jpg"));
		bottleImage1.bitmapData = BitmapScaled( bottleImage1, width, width );
		bottleImage1.rotation = 90;
		bottleImage1.x = width;
		bottleImage1.y = drawableHeight / 2 - bottleImage1.width / 2 + Globals.g_app.logoHeight() + Globals.g_app.tabHeight();
		bottleImage1.alpha = 0.5;
		_window.addChild( bottleImage1 );
		
		super.itemDraw();
	}
}
