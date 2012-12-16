package com.drinkzage.windows;


import nme.events.MouseEvent;

import nme.Assets;
import nme.display.Bitmap;
import nme.display.Sprite;

import com.drinkzage.windows.WineCategory;
import com.drinkzage.utils.Utils;
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

		var icon:Sprite = null;
		var item:ItemWine = cast( _item, ItemWine );
		if ( WineCategory.Red == item.getWineCategory() )
			icon = Utils.loadGraphic( "assets/wineRed.png", true );
		else
			icon = Utils.loadGraphic( "assets/wineWhite.png", true );
			
		icon.name = "wine.png";
		icon.rotation = 90;
		icon.alpha = 0.5;
		icon.x = icon.width + width/2 - icon.width/2;
		icon.y = height/2;
		_window.addChild(icon);
		
		
		super.itemDraw();
	}
}
