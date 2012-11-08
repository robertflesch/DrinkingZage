package com.drinkzage.windows;

import nme.Assets;
import nme.Vector;

import nme.display.Sprite;
import nme.display.Bitmap;
import nme.display.Stage;

import nme.events.MouseEvent;
import com.drinkzage.Globals;

import com.drinkzage.windows.BeerListWindow;
import com.drinkzage.windows.Item;
import com.drinkzage.utils.Utils;

/**
 * @author Robert Flesch
 */
class BeerWindow extends ItemFinalWindow {
	
	private static var _instance:BeerWindow = null;
	private static var _lastContainer:BeerContainer = null;
	private static var _tabSelected:Dynamic = BeerContainer.Bottle;
	
	public static function instance():BeerWindow
	{ 
		if ( null == _instance )
			_instance = new BeerWindow();
			
		return _instance;
	}
	
	public function new () 
	{
		super();
		
		var width:Float = _stage.stageWidth;
		var height:Float = _stage.stageHeight;
		_countTextField.x = width - 180;
		_countTextField.y = height / 2 - 30;
		_countTextField.height = 200;
		_countTextField.rotation = 0;
		
		_tabs.push( "Bottle" );
		_tabs.push( "Can" );
		_tabs.push( "Draft" );
		_tabs.push( "Pitcher" );
		_tabs.push( "Back" );
	}
	
	//override public function populate( item:Item ):Void
	//{
		//super.populate( item );
		//
		//_window.prepareNewWindow();
		//_item = item;
//
		//itemDraw();
		//countDraw();
		//_window.tabsDraw( _tabs, _tabSelected, tabHandler );
	//}
	
	override public function tabHandler( me:MouseEvent ):Void
	{
		if ( me.stageY >= Globals.g_app.tabHeight() + Globals.g_app.logoHeight() )
			return;
			
		var index:Int = me.target.name;
		switch ( index )
		{
			case 0: // Bottle
				_tabSelected = BeerContainer.Bottle;
				populate( _item );
			case 1: // Can
				_tabSelected = BeerContainer.Can;
				populate( _item );
			case 2: // ..
				_tabSelected = BeerContainer.Draft;
				populate( _item );
			case 3: // ..
				_tabSelected = BeerContainer.Pitcher;
				populate( _item );
			case 4: // Back
				backHandler();
		}
	}
	
	override public function backHandler():Void
	{
		super.backHandler();
		var blw: BeerListWindow = BeerListWindow.instance();
		blw.populate();
	}
	
/*
	override public function countDraw():Void
	{
		var width:Float = _stage.stageWidth;
		var height:Float = _stage.stageHeight;
		

		_window.addChild( _countTextField );
		
		var plus:Sprite = Utils.loadGraphic ( "assets/plus.png", true );
		plus.name = "plus";
		plus.x = width - 140;
		plus.y = Globals.g_app.logoHeight() + Globals.g_app.tabHeight() + height/20;
		plus.addEventListener( MouseEvent.MOUSE_DOWN, plusHandler );
		_window.addChild(plus);
		
		var minus:Sprite = Utils.loadGraphic ( "assets/minus.png", true );
		minus.name = "minus";
		minus.x = width - 140;
		minus.y = height - 140;
		minus.addEventListener( MouseEvent.MOUSE_DOWN, minusHandler );
		_window.addChild(minus);
	}
	*/
	
	private function getBeerImage( beer:ItemBeer, container:BeerContainer ):Bitmap
	{
		var bottleImage:Bitmap;
		if ( Type.enumEq( BeerContainer.Can, container ) )
		{
			bottleImage = new Bitmap (Assets.getBitmapData ("assets/Can.png"));
		}
		else if ( Type.enumEq( BeerContainer.Bottle, container ) )
		{
			var colorName:String = Std.string( beer._color );
			var containerName:String = Std.string( container );
			
			trace( "assets/" + containerName + colorName + ".png");

			bottleImage = new Bitmap (Assets.getBitmapData ("assets/" + containerName + colorName + ".png"));
		}
		else
		{
			var colorName:String = Std.string( beer._bcolor );
			var containerName:String = Std.string( container );
			
			trace( "assets/" + containerName + colorName + ".png");

			bottleImage = new Bitmap (Assets.getBitmapData ("assets/" + containerName + colorName + ".png"));
		}
		return bottleImage;
	}
	
	override public function itemDraw():Void	
	{
		 var beer:ItemBeer = cast( _item, ItemBeer );
		
		var width:Float = _stage.stageWidth;
		var height:Float = _stage.stageHeight;
		
		var bottleImage:Bitmap = getBeerImage( beer, _tabSelected );
		var hvw = bottleImage.height / bottleImage.width;
		bottleImage.height = height * 0.75;
		bottleImage.width = bottleImage.height / hvw;
		
		bottleImage.x = width * 1/3 - bottleImage.width/2;
		bottleImage.y = height / 2 - bottleImage.height / 2 + Globals.g_app.logoHeight(); // + Globals.g_app.tabHeight();

		_window.addChild( bottleImage );
		
		var label:Bitmap = new Bitmap (Assets.getBitmapData ( "assets/" + beer._label ));
		if ( Type.enumEq( BeerContainer.Can, _tabSelected ) )
		{
			var scaling:Float = bottleImage.width/label.width;
			label.width = bottleImage.width;
			label.height = label.height * scaling;
			
			label.y = bottleImage.y + bottleImage.height / 2 - label.height / 2 + 10;
			label.x = bottleImage.x + bottleImage.width / 2 - label.width / 2;
		}
		else if ( Type.enumEq( BeerContainer.Draft, _tabSelected ) )
		{
			var scaling:Float = bottleImage.width/label.width;
			label.width = bottleImage.width * 0.75;
			label.height = label.height * scaling * 0.75;
			
			label.y = bottleImage.y + bottleImage.height / 2 - label.height / 2;
			label.x = bottleImage.x + bottleImage.width / 2 - label.width / 2;
		}
		else if ( Type.enumEq( BeerContainer.Pitcher, _tabSelected ) )
		{
			var scaling:Float = bottleImage.width/label.width;
			label.width = bottleImage.width * 0.6;
			label.height = label.height * scaling * 0.6;
			
			label.y = bottleImage.y + bottleImage.height / 2 - label.height / 2; // - height / 10;
			label.x = bottleImage.x + bottleImage.width / 2 - label.width / 2 + width/40;
		}
		else
		{
			var scaling:Float = bottleImage.width/label.width;
			label.width = bottleImage.width;
			label.height = label.height * scaling;
			
			label.y = bottleImage.y + bottleImage.height * 11 / 16 - label.height / 2;
			label.x = bottleImage.x + bottleImage.width / 2 - label.width / 2;
		}

		_window.addChild( label );
	}
}

enum BeerContainer {
	Bottle;
	Can;
	Draft;
	Pitcher;
	Other;
}

/*
class BeerWindow {
	
	private var _beerHeaderButtons:Vector<String>;
	private var _countTextField:TextField;
	private var _countTextFormat:TextFormat;
	private var _stage:Stage;
	private var _window:DrinkingZage;
	private var _beer:ItemBeer;
	private static var _tabSelected:BeerContainer = BeerContainer.Bottle;
	
	private static var _instance:BeerWindow = null;
	
	public static function instance():BeerWindow
	{ 
		if ( null == _instance )
			_instance = new BeerWindow();
			
		return _instance;
	}

	
	public function new () 
	{
		_stage = Globals.g_stage;
		_window = Globals.g_app;

		Globals.resetButtons();
		_tabs.push( "Back" );
		
		_tabSelected.push( "Bottle" );
		_tabSelected.push( "Can" );
		_tabSelected.push( "Draft" );
		_tabSelected.push( "Pitcher" );
		_tabSelected.push( "Back" );
		
		_countTextField = new TextField();
		_countTextFormat = new TextFormat();
		_countTextFormat.size = 96;                // set the font size
		_countTextFormat.align = TextFormatAlign.CENTER;
		_countTextFormat.color = 0xffff00;
	}
	
	public function populate( item:ItemBeer ):Void
	{
		_beer = item;
		_window.prepareNewWindow();
		//beerHeader();
		
		var width:Float = _stage.stageWidth;
		var height:Float = _stage.stageHeight;
		
		_countTextField.x = width - width/3;
		_countTextField.y = height / 2 - 40;
		_countTextField.text = "1";
		_countTextField.selectable = false;
		_countTextField.setTextFormat( _countTextFormat );	
		_window.addChild( _countTextField );
		
		var bottleImage:Bitmap = getBeerImage( _beer, _tabSelected );
		bottleImage.x = width * 1/3 - bottleImage.width/2;
		bottleImage.y = height / 2 - bottleImage.height / 2 + Globals.g_app.logoHeight(); // + Globals.g_app.tabHeight();
		_window.addChild( bottleImage );
		
		//trace( "BeerWindow.populate - beer label: " + _beer._label );
		var label:Bitmap = new Bitmap (Assets.getBitmapData ( "assets/" + _beer._label ));
		if ( Type.enumEq( BeerContainer.Can, _tabSelected ) )
		{
			var scaling:Float = bottleImage.width/label.width;
			label.width = bottleImage.width;
			label.height = label.height * scaling;
			
			label.y = bottleImage.y + bottleImage.height / 2 - label.height / 2 + 10;
			label.x = bottleImage.x + bottleImage.width / 2 - label.width / 2;
		}
		else if ( Type.enumEq( BeerContainer.Draft, _tabSelected ) )
		{
			var scaling:Float = bottleImage.width/label.width;
			label.width = bottleImage.width * 0.75;
			label.height = label.height * scaling * 0.75;
			
			label.y = bottleImage.y + bottleImage.height / 2 - label.height / 2;
			label.x = bottleImage.x + bottleImage.width / 2 - label.width / 2;
		}
		else if ( Type.enumEq( BeerContainer.Pitcher, _tabSelected ) )
		{
			var scaling:Float = bottleImage.width/label.width;
			label.width = bottleImage.width * 0.6;
			label.height = label.height * scaling * 0.6;
			
			label.y = bottleImage.y + bottleImage.height / 2 - label.height / 2; // - height / 10;
			label.x = bottleImage.x + bottleImage.width / 2 - label.width / 2 + width/40;
		}
		else
		{
			var scaling:Float = bottleImage.width/label.width;
			label.width = bottleImage.width;
			label.height = label.height * scaling;
			
			label.y = bottleImage.y + bottleImage.height * 11 / 16 - label.height / 2;
			label.x = bottleImage.x + bottleImage.width / 2 - label.width / 2;
		}

		_window.addChild( label );

		var plus:Sprite = Utils.loadGraphic ( "assets/plus.png", true );
		plus.name = "plus";
		plus.x = width - 80;
		plus.y = Globals.g_app.logoHeight() + Globals.g_app.tabHeight() + height/20;
		plus.addEventListener( MouseEvent.MOUSE_DOWN, plusHandler );
		_window.addChild(plus);
		
		var minus:Sprite = Utils.loadGraphic ( "assets/minus.png", true );
		minus.name = "minus";
		minus.x = width - 80;
		minus.y = height - 80;
		minus.addEventListener( MouseEvent.MOUSE_DOWN, minusHandler );
		_window.addChild(minus);
	}
	
	private function resizeHandler(e:Event):Void
	{
		populate(  _beer  );
	}

	private function beerHeader():Void
	{
		var BEER_BUTTON_COUNT:Int = 5;
		var width:Float = _stage.stageWidth;
		var height:Float = 30;
		for ( i in 0...BEER_BUTTON_COUNT )
		{
			var tab:Sprite;
			if ( i == Type.enumIndex( _tabSelected ) )
				tab = Utils.loadGraphic( "assets/" + "tab_active.png", true );
			else	
				tab = Utils.loadGraphic( "assets/" + "tab_inactive.png", true );
				
			tab.x = i * width / BEER_BUTTON_COUNT;
			tab.y = Globals.g_app.logoHeight();
			tab.width =  width / BEER_BUTTON_COUNT;
			tab.height = height;
			tab.addEventListener( MouseEvent.CLICK, beerTabHandler );
			tab.name = Std.string( i );

			var text : TextField = new TextField();
			text.text = _beerHeaderButtons[ i ];
			text.height = height;
			text.name = Std.string( i );
			text.width = tab.width;
			text.y = height/ 4;
			text.x = 0;
			text.selectable = false;
			
			var ts:TextFormat = new TextFormat("_sans");
			ts.size = 16;                // set the font size
			ts.align = TextFormatAlign.CENTER;
			ts.color = 0xffffff;
			text.setTextFormat(ts);
			tab.addChild(text);
			
			_window.addChild( tab );
		}
		
	}
	
	

	override public function draw( offset:Float ):Void
	{
		Globals.g_app.clearChildren();		
		listDraw( offset );
		Globals.g_app.tabsDraw( beerTabHandler );
	}

	

	private function beerHandler( me:MouseEvent ):Void
	{
	}
	
	private function plusHandler( me:MouseEvent ):Void
	{
		var count:Int = Std.parseInt( _countTextField.text );
		if ( 0 < count )
		{
			_countTextField.text = Std.string( ++count );
			_countTextField.setTextFormat( _countTextFormat );
		}
	}
	
	private function minusHandler( me:MouseEvent ):Void
	{
		var count:Int = Std.parseInt( _countTextField.text );
		if ( 1 < count )
		{
			_countTextField.text = Std.string( --count );
			_countTextField.setTextFormat( _countTextFormat );
		}			
	}
}
*/
