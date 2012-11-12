package com.drinkzage;

import com.drinkzage.windows.Item;
import com.drinkzage.windows.SearchWindow;
import nme.Vector;
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

import nme.net.SharedObject;
import nme.net.SharedObjectFlushStatus;

import com.drinkzage.windows.WineWindow;
import com.drinkzage.windows.NonAlcoholicDrinkWindow;
import com.drinkzage.windows.BeerWindow;

import com.drinkzage.windows.Item;
import com.drinkzage.windows.ItemBeer;
import com.drinkzage.windows.ContainerColor;
import com.drinkzage.windows.BeerColor;
import com.drinkzage.windows.ShotWindow;
import com.drinkzage.windows.EmoteWindow;
import com.drinkzage.windows.MixedDrinkWindow;

#if flash
import org.flashdevelop.utils.FlashConnect;
#end
/**
 * @author Robert Flesch
 */
class DrinkingZage extends Sprite {
	
	static inline var GUTTER:Float = 10;
	private var _frontButtons:Vector<FrontButton>;
	private var _allItems:Vector<Item>;
	
	public function new () {
		
		super ();
		
		Globals.g_app = this;
		Lib.current.stage.scaleMode = EXACT_FIT;
		
		_allItems = new Vector<Item>();

		//initialize ();
		addEventListener( Event.ADDED_TO_STAGE, addedToStage );
		
		_frontButtons = new Vector<FrontButton>();
		_frontButtons.push( new FrontButton( "Fav", "fav.jpg" ) );
		_frontButtons.push( new FrontButton( "Beer", "beer.jpg" ) );
		_frontButtons.push( new FrontButton( "Wine", "wine.jpg" ) );
		_frontButtons.push( new FrontButton( "Emote", "emote.jpg" ) );
		_frontButtons.push( new FrontButton( "Liquor", "liquor.jpg" ) );
		_frontButtons.push( new FrontButton( "Non Alco", "non.jpg" ) );
		
		createList();
		
		storageTest();
	}
	
	public function getAllItems():Vector<Item>
	{
		return _allItems;
	}
	
	private function storageTest():Void
	{
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
	}
	
	function resizeHandler(e:Event):Void
	{
		populate();
	}
	
	public function addItem( item:Item ):Void
	{
		trace( "DrinkingZage.addItem: " + item + "  name: " + item._name );
		_allItems.push( item );
	}

	public function resetVisiblity():Void
	{
		var count:Int = _allItems.length;
		for ( i in 0...count )
		{
			_allItems[i].setVisible( true );
		}
	}
	
	public function hideItemsWithoutString( val:String ):Void
	{
		var count:Int = _allItems.length;
		for ( i in 0...count )
		{
			var index:Int = _allItems[i]._name.toLowerCase().indexOf( val.toLowerCase(), 0 );
			if ( 0 > index )
				_allItems[i].setVisible( false );
		}
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
		var returnVal:Float = ListWindowConsts.TAB_HEIGHT * Lib.current.stage.stageHeight;
		return returnVal;
	}
	
	public function logoHeight():Float
	{
		var returnVal:Float = LogoConsts.LOGO_HEIGHT * Lib.current.stage.stageHeight;
		return returnVal;
	}
	
	public function componentHeight():Float
	{
		var returnVal:Float = ListWindowConsts.COMPONENT_HEIGHT * Lib.current.stage.stageHeight;
		return returnVal;
	}

	public function searchHeight():Float
	{
		var returnVal:Float = ListWindowConsts.COMPONENT_HEIGHT * Lib.current.stage.stageHeight;
		return returnVal;
	}
	
	public function searchDraw():Void
	{
		//var logo:Sprite = Utils.loadGraphic ( "assets/bottombar.jpg", true );
		//logo.width = Lib.current.stage.stageWidth;
		//logo.height = logoHeight();
		//logo.y = Lib.current.stage.stageHeight - logo.height;
		//this.addChild(logo);
		
		var searchBut:Sprite = Utils.loadGraphic ( "assets/findDrink.png", true );
		searchBut.y = Lib.current.stage.stageHeight - searchBut.height;
		searchBut.x = 0;
		searchBut.width = Lib.current.stage.stageWidth/2;
		searchBut.addEventListener( MouseEvent.CLICK, searchDrinkClickHandler);
		this.addChild(searchBut);
		
		var customBut:Sprite = Utils.loadGraphic ( "assets/customDrink.png", true );
		customBut.y = Lib.current.stage.stageHeight - customBut.height;
		customBut.x = Lib.current.stage.stageWidth/2;
		customBut.width = Lib.current.stage.stageWidth/2;
		customBut.addEventListener( MouseEvent.CLICK, customDrinkClickHandler);
		this.addChild(customBut);
	}
	
	private function searchDrinkClickHandler( me:MouseEvent )
	{
		trace("searchDrinkClickHandler");
		var sw:SearchWindow = SearchWindow.instance();
		sw.populate();
	}

	private function customDrinkClickHandler( me:MouseEvent )
	{
		trace("customDrinkClickHandler");
		var sw:SearchWindow = SearchWindow.instance();
		sw.populate();
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
			ts.size = 10;                // set the font size
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
	
	private function createList():Void
	{
		addItem ( new Item( "Red", WineWindow ) );
		addItem ( new Item( "White", WineWindow ) );
		addItem ( new Item( "Rose", WineWindow ) );
		addItem ( new Item( "Sparkling", WineWindow ) );
	
		addItem ( new Item( "Coffee", NonAlcoholicDrinkWindow ) );
		addItem ( new Item( "Soda", NonAlcoholicDrinkWindow ) );
		addItem ( new Item( "Non Alcoholic Beer", NonAlcoholicDrinkWindow ) );
		addItem ( new Item( "Water", NonAlcoholicDrinkWindow ) );
		addItem ( new Item( "Juice", NonAlcoholicDrinkWindow ) );
		
		addItem ( new Item( "Jager Bomb", ShotWindow ) );
		addItem ( new Item( "Red Headed Slut", ShotWindow ) );
		addItem ( new Item( "Perfect Pussy", ShotWindow ) );
		addItem ( new Item( "Tequila", ShotWindow ) );
		addItem ( new Item( "Washington Apple", ShotWindow ) );
		addItem ( new Item( "Buttery Nipple", ShotWindow ) );
		addItem ( new Item( "Kamikaze", ShotWindow ) );
		addItem ( new Item( "Lemon Drops", ShotWindow ) );
		addItem ( new Item( "Irish Carbomb", ShotWindow ) );
		addItem ( new Item( "Purple Hooter", ShotWindow ) );
		addItem ( new Item( "Liquid Cocaine", ShotWindow ) );
		
		addItem ( new Item( "Like", EmoteWindow ) );
		addItem ( new Item( "Love", EmoteWindow ) );
		addItem ( new Item( "Lets go to my place", EmoteWindow ) );
		addItem ( new Item( "Can I get you a drink", EmoteWindow ) );
		addItem ( new Item( "20 most original lines", EmoteWindow ) );
		addItem ( new Item( "20 lines to make them laugh", EmoteWindow ) );
		addItem ( new Item( "20 lines to shock them", EmoteWindow ) );
		
		addItem ( new Item( "Margarita", MixedDrinkWindow ) );
		addItem ( new Item( "Sex on the beach", MixedDrinkWindow ) );
		addItem ( new Item( "Rum and Coke", MixedDrinkWindow ) );
		addItem ( new Item( "Vodka and Cranberry", MixedDrinkWindow ) );
		addItem ( new Item( "Vodka and Tonic", MixedDrinkWindow ) );
		addItem ( new Item( "Salty Dog", MixedDrinkWindow ) );
		addItem ( new Item( "Long Island Ice Tea", MixedDrinkWindow ) );
		addItem ( new Item( "Screw Driver", MixedDrinkWindow ) );
		addItem ( new Item( "Rum and Pineapple", MixedDrinkWindow ) );
		addItem ( new Item( "Gin and Tonic", MixedDrinkWindow ) );
		addItem ( new Item( "Tequila Sunrise", MixedDrinkWindow ) );

		addItem ( new ItemBeer( "Bud Light", BeerWindow, "budweiser_lite_label.png", "Domestic", ContainerColor.Dark, BeerColor.Light ) );
		addItem ( new ItemBeer( "Budweiser", BeerWindow, "budweiser_label.png", "Domestic", ContainerColor.Dark, BeerColor.Light ) );
		addItem ( new ItemBeer( "Miller Lite", BeerWindow, "miller_lite_label.png", "Domestic", ContainerColor.Light, BeerColor.Light ) );
		addItem ( new ItemBeer( "Coors Lite", BeerWindow, "coors_lite_label.png", "Domestic", ContainerColor.Dark, BeerColor.Light ) );
		addItem ( new ItemBeer( "Natural Lite", BeerWindow, "natural_lite_label.png", "Domestic", ContainerColor.Dark, BeerColor.Light ) );
		addItem ( new ItemBeer( "Corona", BeerWindow, "corona_label.png", "Domestic", ContainerColor.Light, BeerColor.Light ) );
		addItem ( new ItemBeer( "Busch", BeerWindow, "busch_label.png", "Domestic", ContainerColor.Light, BeerColor.Light ) );
		addItem ( new ItemBeer( "Busch Light", BeerWindow, "busch_lite_label.png", "Domestic", ContainerColor.Light, BeerColor.Light ) );
		addItem ( new ItemBeer( "Heineken", BeerWindow, "heineken_label.png", "Import", ContainerColor.Green, BeerColor.Light ) );
		addItem ( new ItemBeer( "Miller High Life", BeerWindow, "miller_high_life_label.png", "Domestic", ContainerColor.Light, BeerColor.Light ) );

		//addItem ( new Item( "Aguila", "aguila_label.png", "import", ContainerColor.Dark ) );
		//addItem ( new Item( "Alexander Keith's Brown", "akbrown.png", "import", ContainerColor.Dark ) );
		//addItem ( new Item( "Alexander Keith's Lager", "aklager.png", "import", ContainerColor.Dark ) );
		//addItem ( new Item( "Alexander Keith's Pale Ale", "akpaleale.png", "import", ContainerColor.Light ) );
		//addItem ( new Item( "Amsel Light", "amsellight.png", "Domestic", ContainerColor.Light ) );
		//addItem ( new Item( "Animee Clear", "animeeclear.png", "Domestic", ContainerColor.Clear ) );
		//addItem ( new Item( "Animee Lemon", "animeelemon.png", "Domestic", ContainerColor.Lemon ) );
		//addItem ( new Item( "Animee Rose", "animeerose.png", "Domestic", ContainerColor.Other ) );
		//addItem ( new Item( "Apatinsko", "apatinsko.png", "import", ContainerColor.Dark ) );
		//addItem ( new Item( "Astika", "astika.png", "import", ContainerColor.Dark ) );
		//addItem ( new Item( "Astika Dark", "astikadark.png", "import", ContainerColor.Dark ) );
		//addItem ( new Item( "Bacardi Lemon", "bacardilemon.png", "import", ContainerColor.Lemon ) );
		//
		//addItem ( new Item( "Bacardi Mojito", "bacardimojito.png", "import", ContainerColor.Dark ) );
		//addItem ( new Item( "Bacardi Raz", "bacardiraz.png", "import", ContainerColor.Dark ) );
		//addItem ( new Item( "Bacardi Silver Sangria", "bacardisilversangria.png", "import", ContainerColor.Dark ) );
		//addItem ( new Item( "Bacardi Strawberry", "bacardistrawberry.png", "import", ContainerColor.Dark ) );
		//
		//addItem ( new Item( "CAguila", "aguila_label.png", "import", ContainerColor.Dark ) );
		//addItem ( new Item( "CAlexander Keith's Brown", "akbrown.png", "import", ContainerColor.Dark ) );
		//addItem ( new Item( "CAlexander Keith's Lager", "aklager.png", "import", ContainerColor.Dark ) );
		//addItem ( new Item( "CAlexander Keith's Pale Ale", "akpaleale.png", "import", ContainerColor.Dark ) );
		//addItem ( new Item( "CAmsel Light", "amsellight.png", "Domestic", ContainerColor.Dark ) );
		//addItem ( new Item( "CAnimee Clear", "animeeclear.png", "Domestic", ContainerColor.Dark ) );
		//addItem ( new Item( "CAnimee Lemon", "animeelemon.png", "Domestic", ContainerColor.Dark ) );
		//addItem ( new Item( "CAnimee Rose", "animeerose.png", "Domestic", ContainerColor.Dark ) );
		//addItem ( new Item( "CApatinsko", "apatinsko.png", "import", ContainerColor.Dark ) );
		//addItem ( new Item( "CAstika", "astika.png", "import", ContainerColor.Dark ) );
		//addItem ( new Item( "CAstika Dark", "astikadark.png", "import", ContainerColor.Dark ) );
		//addItem ( new Item( "CBacardi Lemon", "bacardilemon.png", "import", ContainerColor.Dark ) );
		//
		//addItem ( new Item( "CBacardi Mojito", "bacardimojito.png", "import", ContainerColor.Dark ) );
		//addItem ( new Item( "CBacardi Raz", "bacardiraz.png", "import", ContainerColor.Dark ) );
		//addItem ( new Item( "CBacardi Silver Sangria", "bacardisilversangria.png", "import", ContainerColor.Dark ) );
		//addItem ( new Item( "CBacardi Strawberry", "bacardistrawberry.png", "import", ContainerColor.Dark ) );
		
		_allItems.sort(orderLastName);
	}
	
	private function orderLastName( item1:Item, item2:Item ):Int 
	{ 
		var name1:Int = item1._name.toLowerCase().charCodeAt(0);
		var name2:Int = item2._name.toLowerCase().charCodeAt(0);
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

