package com.drinkzage;

import com.drinkzage.windows.MartiniWindow;
import com.drinkzage.windows.TumblerWindow;
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

import nme.display.DisplayObject;

import nme.geom.Vector3D;

//import nme.net.SharedObject;
//import nme.net.SharedObjectFlushStatus;

import nme.text.TextField;
import nme.text.TextFormat;
import nme.text.TextFormatAlign;

import com.drinkzage.Globals;
import com.drinkzage.utils.Utils;
import com.drinkzage.utils.DataPersistance;
import com.drinkzage.utils.DataPersistanceNull;

import com.drinkzage.windows.BeerColor;
import com.drinkzage.windows.BeerListWindow;
import com.drinkzage.windows.BeerWindow;
import com.drinkzage.windows.ContainerColor;
import com.drinkzage.windows.EmoticonsWindow;
import com.drinkzage.windows.EmoteWindow;
import com.drinkzage.windows.Item;
import com.drinkzage.windows.ItemBeer;
import com.drinkzage.windows.ItemWine;
import com.drinkzage.windows.LogoConsts;
import com.drinkzage.windows.NonAlcoholicDrinks;
import com.drinkzage.windows.NonAlcoholicDrinkWindow;
import com.drinkzage.windows.NotDoneYetWindow;
import com.drinkzage.windows.LiquorChoice;
import com.drinkzage.windows.WineChoice;
import com.drinkzage.windows.ListWindowConsts;
import com.drinkzage.windows.SearchWindow;
import com.drinkzage.windows.ShotWindow;
import com.drinkzage.windows.WineListWindow;
import com.drinkzage.windows.WineWindow;

import com.drinkzage.events.EventManager;

#if flash
import org.flashdevelop.utils.FlashConnect;
#end

/**
 * @author Robert Flesch
 */
class DrinkingZage extends Sprite {
	
	static inline var GUTTER:Float = 10;
	private var _allItems( allItems, null ):Vector<Item>;
	public function allItems():Vector<Item> { return _allItems; }
	
	private var _frontButtons:Vector<FrontButton>;
	private var _searchBut:Sprite = null;
	private var _customBut:Sprite = null;
	
	private var _em:EventManager = null;
	
	public function new () {
		
		super ();
		
		Globals.g_app = this;
		Lib.current.stage.scaleMode = EXACT_FIT;
		_em = new EventManager();
		
		_allItems = new Vector<Item>();
		addEventListener( Event.ADDED_TO_STAGE, addedToStage );
		
		_frontButtons = new Vector<FrontButton>();
		_frontButtons.push( new FrontButton( "Fav", "fav.jpg" ) );
		_frontButtons.push( new FrontButton( "Beer", "beer.jpg" ) );
		_frontButtons.push( new FrontButton( "Wine", "wine.jpg" ) );
		_frontButtons.push( new FrontButton( "Emote", "emote.jpg" ) );
		_frontButtons.push( new FrontButton( "Liquor", "liquor.jpg" ) );
		_frontButtons.push( new FrontButton( "Non Alco", "non.jpg" ) );

		createList();
		
#if ( flash || android )
		Globals.g_dataPersistance = new DataPersistance();
#else		
		Globals.g_dataPersistance = new DataPersistanceNull();
#end
	}
	
	public function resetVisiblity( items:Vector<Item> ):Void
	{
		var count:Int = items.length;
		for ( i in 0...count )
		{
			items[i].setVisible( true );
		}
	}
	
	private function addedToStage( e:Event ):Void
	{
		removeEventListener( Event.ADDED_TO_STAGE, addedToStage );
		
		Globals.g_stage = stage;
#if flash
		stage.showDefaultContextMenu = false;
#end
		
#if android		
		stage.needsSoftKeyboard = true;
#end		
	
		populate();
	}
	
	public function populate():Void
	{
		trace( "DrinkingZage.populate" );
		removeAllChildrenAndDrawLogo();
		addButtons();
		searchDraw();
	}
	
	public function addButtons():Void
	{
		var width:Float = stage.stageWidth/2;
		var height:Float = (stage.stageHeight  - logoHeight() - searchHeight() )/3;

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
				_em.addEvent( graphic, MouseEvent.CLICK, mouseDownHandler );
				addChild(graphic);
			}
		}
	}
	
	private function logoDraw():Void
	{
		//trace( "DrinkZage.logoDraw" );
		var logo:Sprite = Utils.loadGraphic ( "assets/logo.jpg", true );
		logo.name = "DrinkZage Logo";
		logo.width = Lib.current.stage.stageWidth;
		logo.height = logoHeight();
		this.addChild(logo);
	}
	
	public function tabHeight():Float
	{
		return ListWindowConsts.TAB_HEIGHT * Lib.current.stage.stageHeight;
	}
	
	public function logoHeight():Float
	{
		return LogoConsts.LOGO_SCALE * Lib.current.stage.stageHeight;
	}
	
	public function componentHeight():Float
	{
		return ListWindowConsts.COMPONENT_HEIGHT * Lib.current.stage.stageHeight;
	}

	public function searchHeight():Float
	{
		var returnVal:Float = ListWindowConsts.COMPONENT_HEIGHT * Lib.current.stage.stageHeight;
		return returnVal;
	}
	
	public function drawableHeight():Float
	{
		return (Globals.g_stage.stageHeight - Globals.g_app.logoHeight() - Globals.g_app.tabHeight());
	}
	
	public function searchDraw():Void
	{
		//_customBut = Utils.loadGraphic ( "assets/custom.png", true );
		//_customBut.name = "customBut";
		//_customBut.y = Lib.current.stage.stageHeight - _customBut.height;
		//_customBut.x = 0;
		//_customBut.width = Lib.current.stage.stageWidth;
		//_customBut.addEventListener( MouseEvent.CLICK, searchDrinkClickHandler);
		//this.addChild(_customBut);
		
		if ( null == _searchBut )
		{
			_searchBut = Utils.loadGraphic ( "assets/search.jpg", true );
			_searchBut.name = "searchBut";
			_searchBut.y = Lib.current.stage.stageHeight - _searchBut.height;
			_searchBut.x = 0;
			_searchBut.width = Lib.current.stage.stageWidth;
			// This is a special case of add event, since this button lives from screen to screen
			// we want to leave this listener attached to it.
			_searchBut.addEventListener( MouseEvent.CLICK, searchDrinkClickHandler);
		}
		this.addChild(_searchBut);
	}
	
	private function searchDrinkClickHandler( me:MouseEvent )
	{
		//trace("searchDrinkClickHandler");
		_em.removeAllEvents();
		var sw:SearchWindow = SearchWindow.instance();
		sw.setBackHandler( this );
		sw.populate();
	}

	public function removeAllChildrenAndDrawLogo():Void
	{
		// remove ALL items from the display list
		for ( i in 0...numChildren )
		{
			this.removeChildAt( 0 );
		}

		logoDraw();
	}
	
	private function mouseDownHandler( me:MouseEvent ):Void
	{
		//trace( me.target.name );
		var index:Int = me.target.name;
		var nw:Dynamic = null;
		switch ( index )
		{
			case 0: // Fav
			{
				_em.removeAllEvents();
				nw = NotDoneYetWindow.instance();
				nw.setBackHandler( this );
				nw.populate();
			}
			case 1: // Beer
			{
				_em.removeAllEvents();
				nw = BeerListWindow.instance();
				nw.setBackHandler( this );
				nw.populate();
			}
			case 2: // Wine
			{
				_em.removeAllEvents();
				nw = WineChoice.instance();
				nw.setBackHandler( this );
				nw.populate();
			}
			case 3: // Emote
			{
				_em.removeAllEvents();
				nw = EmoticonsWindow.instance();
				nw.setBackHandler( this );
				nw.populate();
			}
			case 4: // Liquor
			{
				_em.removeAllEvents();
				nw = LiquorChoice.instance();
				nw.setBackHandler( this );
				nw.populate();
			}
			case 5: // Non Alco
			{
				_em.removeAllEvents();
				nw = NonAlcoholicDrinks.instance();
				nw.setBackHandler( this );
				nw.populate();
			}
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
	
	public function addItem( item:Item ):Void
	{
		_allItems.push( item );
	}

	private function createList():Void
	{
		var drinks : Dynamic;
		drinks = Json.parse(Assets.getText("assets/drinks.json"));

		var wineListSize:Int = drinks.wines.length;
		for ( i in 0 ... wineListSize )
		{
			addItem ( new ItemWine( drinks.wines[i].name, WineWindow, drinks.wines[i].color ) );
		}
		
		var nonAlcoholicDrinksListSize:Int = drinks.nonAlcoholicDrinks.length;
		for ( i in 0 ... nonAlcoholicDrinksListSize )
		{
			addItem ( new Item( drinks.nonAlcoholicDrinks[i].name, NonAlcoholicDrinkWindow ) );
		}
		
		var shotsListSize:Int = drinks.shots.length;
		for ( i in 0 ... shotsListSize )
		{
			addItem ( new Item( drinks.shots[i].name, ShotWindow ) );
		}
		
		var emotesListSize:Int = drinks.emotes.length;
		for ( i in 0 ... emotesListSize )
		{
			addItem ( new Item( drinks.emotes[i].name, EmoteWindow ) );
		}

		for ( i in 0 ... drinks.tumbler.length )
		{
			addItem ( new Item( drinks.tumbler[i].name, TumblerWindow ) );
		}
		
		for ( i in 0 ... drinks.martini.length )
		{
			addItem ( new Item( drinks.martini[i].name, MartiniWindow ) );
		}
		
		var commercial_beersListSize:Int = drinks.commercial_beers.length;
		for ( i in 0 ... commercial_beersListSize )
		{
			addItem ( new ItemBeer( drinks.commercial_beers[i].name
								  , BeerWindow
								  , drinks.commercial_beers[i].label
								  , drinks.commercial_beers[i].origin
								  , drinks.commercial_beers[i].container_color
								  , drinks.commercial_beers[i].beer_color
								  ) );
		}
		
		_allItems.sort( orderByName );
	}
	
	private function orderByName( item1:Item, item2:Item ):Int 
	{ 
		var name1:Int = item1.name().toLowerCase().charCodeAt(0);
		var name2:Int = item2.name().toLowerCase().charCodeAt(0);
		if (name1 < name2) 
		{ 
			return -1; 
		} 
		else if (name1 > name2) 
		{ 
			return 1; 
		} 
		else 
		{ 
			return 0; 
		} 
	}
	
	public function traceChildNames():Void
	{
		trace( "DrinkZage.dumpChildNames: " + this.numChildren );
		for  ( j in 0... this.numChildren )
		{
			var item:DisplayObject = this.getChildAt(j);
			trace ( item.name );
		}
	}

	private function storageTest():Void
	{
		/*
		trace("DrinkingZage.storageTest" );
		var so = SharedObject.getLocal( "storage-test" );
		// Load the values
		// Data.message is null the first time
		trace("DrinkingZage.storageTest data loaded: " + so.data.message );
		var count:Int = Std.parseInt( so.data.count );

		// Set the values
		so.data.message = "oh hello! [" + count + "]";
		so.data.count = count + 1 ;

		// Prepare to save.. with some checks
		#if ( cpp || neko )
			// Android didn't wanted SharedObjectFlushStatus not to be a String
			var flushStatus:SharedObjectFlushStatus = null;
		#else
			// Flash wanted it very much to be a String
			var flushStatus:String = null;
		#end

		try {
			flushStatus = so.flush() ;	// Save the object
		} catch ( e:Dynamic ) {
			trace("couldn't write...");
		}

		if ( flushStatus != null ) {
			switch( flushStatus ) {
				case SharedObjectFlushStatus.PENDING:
					trace("DrinkingZage.storageTest - requesting permission to save");
				case SharedObjectFlushStatus.FLUSHED:
					trace("DrinkingZage.storageTest - value saved");
			}
		}
		*/
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

