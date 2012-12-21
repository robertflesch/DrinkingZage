package com.drinkzage.windows;

import nme.Vector;

import nme.Assets;

import nme.display.Sprite;
import nme.display.Bitmap;
import nme.display.Stage;

import nme.events.MouseEvent;
import nme.events.Event;

import com.drinkzage.utils.Utils;
import com.drinkzage.windows.IListWindow;
import com.drinkzage.windows.ListWindowConsts;
import com.drinkzage.windows.ChoiceButton;

/**
 * @author Robert Flesch
 */
class ChoiceWindow extends ITabWindow
{
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
	}

	override public function populate():Void
	{
		super.populate();
		listDraw( 0 );
	}

	public function listDraw( scrollOffset:Float ):Void
	{
		var numberOfChoices:Int = _choiceButtons.length;
		var width:Float = _stage.stageWidth;
		var height:Float = (drawableHeight() - searchHeight())/numberOfChoices;

		for ( i in 0...numberOfChoices )
		{
			var graphic:Sprite = Utils.loadGraphic ( "assets/buttonBlank.jpg", true );
			graphic.name = Std.string( i );
			graphic.x = ListWindowConsts.GUTTER;
			graphic.y = i * height + ListWindowConsts.GUTTER + logoHeight() + tabHeight();
			graphic.width = width - (ListWindowConsts.GUTTER * 2);
			graphic.height = height - (ListWindowConsts.GUTTER * 1);
			_em.addEvent( graphic, MouseEvent.CLICK, choiceClickHandler );
			_window.addChild(graphic);

			var icon:Sprite = Utils.loadGraphic ( "assets/" + _choiceButtons[ i ]._image, true );
			icon.name = Std.string( i );
			var hvw = icon.height / icon.width;
			icon.height = graphic.height * 0.75;
			icon.width = icon.height / hvw;
			icon.x = graphic.x + graphic.width/2 - icon.width/2;
			icon.y = graphic.y + graphic.height/2 - icon.height/2;
			_em.addEvent( icon, MouseEvent.CLICK, choiceClickHandler );
			_window.addChild(icon);
		}
	}
	
	private function choiceClickHandler( me:MouseEvent ):Void
	{
		throw ( "Virtual Function needs to be overriden" );
	}
	
}
