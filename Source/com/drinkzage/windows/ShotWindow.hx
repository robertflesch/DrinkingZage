package com.drinkzage.windows;

import nme.display.Sprite;

import com.drinkzage.utils.Utils;


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

		var icon:Sprite = Utils.loadGraphic ( "assets/shot.png", true  );
		icon.name = "shot.png";
		icon.rotation = 90;
		icon.alpha = 0.5;
		icon.x = icon.width + width/2 - icon.width/2;
		icon.y = height/2;
		_window.addChild(icon);
		

		super.itemDraw();
	}
}
