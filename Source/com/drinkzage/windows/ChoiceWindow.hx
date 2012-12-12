﻿package com.drinkzage.windows;

import nme.Vector;

import nme.Assets;

import nme.display.Sprite;
import nme.display.Bitmap;
import nme.display.Stage;

import nme.events.MouseEvent;
import nme.events.Event;

import com.drinkzage.utils.Utils;
import com.drinkzage.windows.IListWindow;
import com.drinkzage.windows.ChoiceButton;

/**
 * @author Robert Flesch
 */
class ChoiceWindow extends IListWindow
{
	static inline var GUTTER:Float = 10;
	public var _choiceButtons:Vector<ChoiceButton>;
	
	private static var _instance:ChoiceWindow = null;
	
	public static function instance():ChoiceWindow
	{ 
		if ( null == _instance )
			_instance = new ChoiceWindow();
			
		return _instance;
	}
	
	public function new () 
	{
		super();
		
		_choiceButtons = new Vector<ChoiceButton>();
		
		createList();
	}
	
	override public function listDraw( scrollOffset:Float ):Void
	{
		var numberOfChoices:Int = _choiceButtons.length;
		var width:Float = _stage.stageWidth;
		var height:Float = (Globals.g_app.drawableHeight() - Globals.g_app.searchHeight())/numberOfChoices;

		for ( i in 0...numberOfChoices )
		{
			//var graphic:Sprite = Utils.loadGraphic ( "assets/buttonBlank.jpg", true );
			var graphic:Bitmap = new Bitmap (Assets.getBitmapData ("assets/buttonBlank.jpg"));
			graphic.name = Std.string( i );
			graphic.x = GUTTER;
			graphic.y = i * height + GUTTER + Globals.g_app.logoHeight() + Globals.g_app.tabHeight();
			graphic.width = width - (GUTTER * numberOfChoices);
			graphic.height = height - (GUTTER * numberOfChoices);
			graphic.addEventListener( MouseEvent.CLICK, choiceClickHandler);
			_window.addChild(graphic);

			var icon:Sprite = Utils.loadGraphic ( "assets/" + _choiceButtons[ i ]._image, true );
			icon.name = Std.string( i );
			icon.width = graphic.height * 0.75;
			icon.height = graphic.height * 0.75;
			icon.x = graphic.x + graphic.width/2 - icon.width/2;
			icon.y = graphic.y + graphic.height/2 - icon.height/2;
			icon.addEventListener( MouseEvent.CLICK, choiceClickHandler);
			_window.addChild(icon);
		}
	}
	
	private function choiceClickHandler( me:MouseEvent ):Void
	{
		throw ( "Virtual Function needs to be overriden" );
	}
	
}