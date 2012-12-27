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
class EmotePictureWindow extends ItemFinalWindow {
	
	private static var _instance:EmotePictureWindow = null;
	
	public static function instance():EmotePictureWindow
	{ 
		if ( null == _instance )
			_instance = new EmotePictureWindow();
			
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
		icon = Utils.loadGraphic( "assets/emotes/" + _item.name(), true );
		icon.name = "icon.png";
		
		var hvw = icon.height / icon.width;
		icon.width = width * 0.9;
		icon.height = icon.width * hvw;
		
		icon.x = width/2 - icon.width/2;
		icon.y = height/2 - icon.height/2;
		_window.addChild(icon);
	}
}
