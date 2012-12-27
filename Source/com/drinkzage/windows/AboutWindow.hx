package com.drinkzage.windows;

import nme.Assets;
import nme.display.Bitmap;
import nme.display.Sprite;

import nme.events.MouseEvent;
import com.drinkzage.windows.TabConst;
import com.drinkzage.utils.Utils;

/**
 * @author Robert Flesch
 */
class AboutWindow extends ItemFinalWindow {
	
	private static var _instance:AboutWindow = null;
	
	public static function instance():AboutWindow
	{ 
		if ( null == _instance )
			_instance = new AboutWindow();
			
		return _instance;
	}

	public function new () 
	{
		super();
		_tabs.push( "BACK" );
	}
	
	override public function populate():Void
	{
		super.setUseCount( false );
		super.populate();
	}

	override public function itemDraw():Void
	{
		var width:Int = _stage.stageWidth;
		var height:Int = _stage.stageHeight;
		
		var icon:Sprite = null;
		icon = Utils.loadGraphic( "assets/dz_icon_114.png", true );
		icon.name = "icon.png";
		
		var hvw = icon.height / icon.width;
		icon.width = width * 0.5;
		icon.height = icon.width * hvw;
		
		icon.x = width/2 - icon.width/2;
		icon.y = height / 2 - icon.height;
		_window.addChild(icon);
		
		var btyb:Sprite = null;
		btyb = Utils.loadGraphic( "assets/broughtToYou.png", true );
		btyb.name = "btyb.png";
		
		var hvw = btyb.height / btyb.width;
		btyb.width = width * 0.9;
		btyb.height = btyb.width * hvw;
		
		btyb.x = width/2 - btyb.width/2;
		btyb.y = height / 2; // - btyb.height / 2;
		_window.addChild(btyb);
	}
}
