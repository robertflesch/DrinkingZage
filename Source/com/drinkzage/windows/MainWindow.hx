package com.drinkzage.windows;

import com.drinkzage.windows.ChoiceWindow;
import Std;

import haxe.Json;

import nme.Assets;
import nme.Lib;
import nme.Vector;

import nme.display.Bitmap;
import nme.display.LoaderInfo;
import nme.display.Sprite;
import nme.display.Stage;
import nme.display.StageAlign;
import nme.display.StageQuality;
import nme.display.StageScaleMode;

import nme.events.Event;
import nme.events.MouseEvent;
import nme.events.KeyboardEvent;

import nme.display.DisplayObject;

import nme.geom.Vector3D;

import com.drinkzage.Globals;

import com.drinkzage.events.EventManager;

import com.drinkzage.utils.Utils;

import com.drinkzage.windows.Item;
import com.drinkzage.windows.LogoConsts;
import com.drinkzage.windows.ListWindowConsts;

import com.drinkzage.windows.BeerListWindow;
import com.drinkzage.windows.EmoticonsWindow;
import com.drinkzage.windows.NonAlcoholicDrinks;
import com.drinkzage.windows.NotDoneYetWindow;
import com.drinkzage.windows.LiquorChoice;
import com.drinkzage.windows.WineChoice;

import com.drinkzage.windows.SearchWindow;

import com.drinkzage.windows.ChoiceButton;

#if flash
import org.flashdevelop.utils.FlashConnect;
#end

/**
 * @author Robert Flesch
 */
class MainWindow extends ChoiceWindow 
{
	private static var _instance:MainWindow = null;
	public static function instance():MainWindow
	{ 
		if ( null == _instance )
			_instance = new MainWindow();
		
		return _instance;
	}
	
	public function new () {
		
		super ();
		
		_choiceButtons.push( new ChoiceButton( "Fav", "fav.jpg" ) );
		_choiceButtons.push( new ChoiceButton( "Beer", "beer.jpg" ) );
		_choiceButtons.push( new ChoiceButton( "Wine", "wine.jpg" ) );
		_choiceButtons.push( new ChoiceButton( "Emote", "emote.jpg" ) );
		_choiceButtons.push( new ChoiceButton( "Liquor", "liquor.jpg" ) );
		_choiceButtons.push( new ChoiceButton( "Non Alco", "non.jpg" ) );
	}
	
	override public function populate():Void
	{
		removeAllChildrenAndDrawLogo();		
		_tabHandler = null;
		
		listDraw( 0 );
		
		_em.addEvent( _stage, KeyboardEvent.KEY_UP, onKeyUp );
		
		searchDraw();
	}
	
	override public function listDraw( scrollOffset:Float ):Void
	{
		var width:Float = _stage.stageWidth/2;
		var height:Float = (_stage.stageHeight  - logoHeight() - searchHeight() )/3;

		for ( i in 0...2 )
		{
			for ( j in 0...3 )
			{
				var graphic:Sprite = Utils.loadGraphic ( "assets/" + _choiceButtons[ i * 3 + j ]._image, true );
				graphic.name = Std.string( i * 3 + j );
				graphic.x = i * width + ListWindowConsts.GUTTER;
				graphic.y = j * height + ListWindowConsts.GUTTER + logoHeight();
				graphic.width = width - (ListWindowConsts.GUTTER * 2);
				graphic.height = height - (ListWindowConsts.GUTTER * 2);
				_em.addEvent( graphic, MouseEvent.CLICK, choiceClickHandler );
				_window.addChild(graphic);
			}
		}
	}
	
	override private function choiceClickHandler( me:MouseEvent ):Void
	{
		var index:Int = me.target.name;
		var nw:Dynamic = null;
		_em.removeAllEvents();
		switch ( index )
		{
			case 0: // Fav
				nw = FavoritesWindow.instance();
			case 1: // Beer
				nw = BeerListWindow.instance();
			case 2: // Wine
				nw = WineChoice.instance();
			case 3: // Emote
				nw = EmoticonsWindow.instance();
			case 4: // Liquor
				nw = LiquorChoice.instance();
			case 5: // Non Alco
				nw = NonAlcoholicDrinks.instance();
			default:
				throw ( "DrinkingZage.mouseDownHandler - No VALID INDEX FOUND: " + index );
		}
		
		nw.setBackHandler( this );
		nw.populate();
	}
	
}
