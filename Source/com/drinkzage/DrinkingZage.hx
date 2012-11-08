package com.drinkzage;

import com.drinkzage.windows.Item;
import Std;

import nme.Lib;
import nme.Vector;
import nme.Assets;

import nme.display.Sprite;
import nme.display.Bitmap;
import nme.display.StageAlign;
import nme.display.StageQuality;
import nme.display.StageScaleMode;
import nme.display.LoaderInfo;
import nme.display.Stage;

import nme.events.MouseEvent;
import nme.events.KeyboardEvent;
import nme.events.Event;

import nme.filters.GlowFilter;

import nme.geom.Vector3D;

import nme.text.TextField;
import nme.text.TextFormat;
import nme.text.TextFormatAlign;

import com.drinkzage.Globals;
import com.drinkzage.windows.BeerListWindow;
import com.drinkzage.windows.LiquorChoice;
import com.drinkzage.utils.Utils;
import com.drinkzage.windows.LogoConsts;
import com.drinkzage.windows.NotDoneYetWindow;
import com.drinkzage.windows.WineChoiceWindow;
import com.drinkzage.windows.NonAlcoholicDrinks;
import com.drinkzage.windows.EmoticonsWindow;

import com.drinkzage.windows.ListWindowConsts;

#if flash
import org.flashdevelop.utils.FlashConnect;
#end
/**
 * @author Robert Flesch
 */
class DrinkingZage extends Sprite {
	
	static inline var GUTTER:Float = 10;
	private var _frontButtons:Vector<FrontButton>;
	
	public function new () {
		
		super ();
		
		Globals.g_app = this;
		Lib.current.stage.scaleMode = EXACT_FIT;
		
		//initialize ();
		addEventListener( Event.ADDED_TO_STAGE, addedToStage );
		
		_frontButtons = new Vector<FrontButton>();
		_frontButtons.push( new FrontButton( "Fav", "fav.jpg" ) );
		_frontButtons.push( new FrontButton( "Beer", "beer.jpg" ) );
		_frontButtons.push( new FrontButton( "Wine", "wine.jpg" ) );
		_frontButtons.push( new FrontButton( "Emote", "emote.jpg" ) );
		_frontButtons.push( new FrontButton( "Liquor", "liquor.jpg" ) );
		_frontButtons.push( new FrontButton( "Non Alco", "non.jpg" ) );
	}
	
	function resizeHandler(e:Event):Void
	{
		populate();
	}

	private function addedToStage( e:Event ):Void
	{
		removeEventListener( Event.ADDED_TO_STAGE, addedToStage );
		
		Globals.g_stage = stage;
#if flash
		stage.showDefaultContextMenu = false;
#end
		//stage.scaleMode = StageScaleMode.EXACT_FIT;
		stage.needsSoftKeyboard = true;
		//stage.autoOrients = false;
		
		stage.addEventListener(Event.RESIZE, resizeHandler);
		populate();
	}
	
	public function populate():Void
	{
		prepareNewWindow();
		addButtons();
	}
	
	public function addButtons():Void
	{
		
		var width:Float = stage.stageWidth/2;
		var height:Float = (stage.stageHeight  - logoHeight())/3;

		for ( i in 0...2 )
		{
			for ( j in 0...3 )
			{
				var graphic:Sprite = Utils.loadGraphic ( "assets/" + _frontButtons[ i * 3 + j ]._image, true );
				graphic.name = Std.string( i * 3 + j );
				graphic.x = i * width + GUTTER;
				graphic.y = j * height + GUTTER + logoHeight();
				graphic.width = width - (GUTTER * 2);
				graphic.height = height - (GUTTER * 2);
				graphic.addEventListener( MouseEvent.CLICK, mouseDownHandler);
				addChild(graphic);
			}
		}
	}
	
	private function logoDraw():Void
	{
		var logo:Sprite = Utils.loadGraphic ( "assets/logo.jpg", true );
		logo.width = Lib.current.stage.stageWidth;
		logo.height = logoHeight();
		this.addChild(logo);
	}
	
	public function tabHeight():Float
	{
		var returnVal:Float = 0.0625 * Lib.current.stage.stageHeight;
//		var returnVal:Float = Globals.g_app.tabHeight() * Lib.current.stage.stageHeight;
		return returnVal;
	}
	
	public function logoHeight():Float
	{
		var returnVal:Float = 0.0625 * Lib.current.stage.stageHeight;
//		var returnVal:Float = Globals.g_app.logoHeight() * Lib.current.stage.stageHeight;
		return returnVal;
	}
	
	public function componentHeight():Float
	{
		var returnVal:Float = 0.0625 * Lib.current.stage.stageHeight;
//		var returnVal:Float = Globals.g_app.logoHeight() * Lib.current.stage.stageHeight;
		return returnVal;
	}
	
	public function tabsDraw( tabs:Vector<String>, tabSelected:Dynamic, tabHandler:Dynamic -> Void):Void
	{
		var tabCount:Int = tabs.length;
		var width:Float = Lib.current.stage.stageWidth;
		var height:Float = tabHeight();
		for ( i in 0...tabCount )
		{
			var tab:Sprite;
			if ( i == Type.enumIndex( tabSelected ) )
				tab = Utils.loadGraphic( "assets/" + "tab_active.png", true );
			else	
				tab = Utils.loadGraphic( "assets/" + "tab_inactive.png", true );
				
			tab.x = i * width / tabCount;
			tab.y = Globals.g_app.logoHeight();
			tab.width =  width / tabCount;
			tab.height = height;
			tab.addEventListener( MouseEvent.CLICK, tabHandler );
			tab.name = Std.string( i );

			var text : TextField = new TextField();
			text.selectable = false;
			text.text = tabs[ i ];
			text.height = tab.height * 0.55;
			text.name = Std.string( i );
			
			// This should work as text.width = tab.width
			// but it only works for some cases. strange....
			if ( tabCount == 1 )
				text.width = tab.width / 6.5;
			else if ( tabCount == 2 )
				text.width = tab.width / 3.3;// 2.1;
			else if ( tabCount == 3 )
				text.width = tab.width / 2.2;
			else if ( tabCount == 4 )
				text.width = tab.width / 1.65;
			else if ( tabCount == 5 )
				text.width = tab.width / 1.30;
			else
				text.width = tab.width * 1.15;
				
			text.y = tab.height/ 8;
			text.x = 0;
//			text.border = true;
//			text.borderColor = 0xffff00;
			
			var ts:TextFormat = new TextFormat("_sans");
			ts.size = 16;                // set the font size
			ts.align = TextFormatAlign.CENTER;
			ts.color = 0xffffff;
			text.setTextFormat(ts);
			tab.addChild(text);
			
			this.addChild( tab );
		}
	}
	
	public function prepareNewWindow():Void
	{
		var children:Int = this.numChildren;
		for ( i in 0...children )
		{
			this.removeChildAt( 0 );
		}
		
		logoDraw();
	}
	
	private function mouseDownHandler( me:MouseEvent ):Void
	{
		//trace( me.target.name );
		var index:Int = me.target.name;
		stage.removeEventListener(Event.RESIZE, resizeHandler);
		switch ( index )
		{
			case 0: // Fav
				NotDoneYetWindow.instance().populate( null );
			case 1: // Beer
				BeerListWindow.instance().populate();
			case 2: // Wine
				WineChoiceWindow.instance().populate();
			case 3: // Emote
				EmoticonsWindow.instance().populate();
			case 4: // Liquor
				LiquorChoice.instance().populate();
			case 5: // Non Alco
				NonAlcoholicDrinks.instance().populate();
		}
	}
	
	// Entry point
	public static function main () 
	{
		#if flash
			FlashConnect.redirect();
		#end
		Lib.current.addChild (new DrinkingZage ());
	}
	

}

class FrontButton
{
	public var _text:String;
	public var _image:String;
	
	public function new( text:String, image:String )
	{
		_text = text;
		_image = image;
	}
}

