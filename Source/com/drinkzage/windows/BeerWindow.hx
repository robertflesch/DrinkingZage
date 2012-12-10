package com.drinkzage.windows;

import nme.Assets;
import nme.Vector;

import nme.display.Sprite;
import nme.display.Bitmap;
import nme.display.Stage;

import nme.text.TextField;
import nme.text.TextFormat;
import nme.text.TextFormatAlign;
import nme.text.Font;
import nme.text.TextFieldType;

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
	private static var _beerTabSelected:Dynamic = BeerContainer.Bottle;
	
	public static function instance():BeerWindow
	{ 
		if ( null == _instance )
			_instance = new BeerWindow();
			
		return _instance;
	}
	
	private function setSelectedBeerType( container:BeerContainer ):Void
	{
		_tabSelected = container;
		// Remember this for next time window is activated
		_beerTabSelected = _tabSelected;
	}
	
	public function new () 
	{
		super();
		
		var width:Float = _stage.stageWidth;
		var height:Float = _stage.stageHeight;
		//_countTextField.x = width - 180;
		//_countTextField.y = height / 2 - 30;
		//_countTextField.height = 200;
		//_countTextField.rotation = 0;
		
		_tabs.push( "Bottle" );
		_tabs.push( "Can" );
		_tabs.push( "Draft" );
		_tabs.push( "Pitcher" );
		_tabs.push( "BACK" );
	}
	
	override public function createCount():Void
	{
		var font = Assets.getFont ("assets/VeraSeBd.ttf");
		_countTextFormat = new TextFormat (font.fontName, 150, 0x00ff00);
		_countTextFormat.align = TextFormatAlign.CENTER;
		
		_countTextField = new TextField();
		_countTextField.selectable = false;
		_countTextField.embedFonts = true;
		_countTextField.text = "1";
		_countTextField.selectable = false;
		_countTextField.height = 200;
		_countTextField.width = 200;
		_countTextField.setTextFormat( _countTextFormat );	

		var width:Float = _stage.stageWidth;
		var height:Float = _stage.stageHeight;
		
		_countTextField.x = width / 1.6; // + 10;
		_countTextField.y = height / 2 - 30;
	}
	
	override public function populate():Void
	{
		_tabSelected = _beerTabSelected;
		super.populate();
	}
	
	override public function tabHandler( me:MouseEvent ):Void
	{
		if ( me.stageY >= Globals.g_app.tabHeight() + Globals.g_app.logoHeight() )
			return;
			
		var index:Int = me.target.name;
		switch ( index )
		{
			case 0: // Bottle
				setSelectedBeerType(  BeerContainer.Bottle );
				setItem( _item );
				populate();
			case 1: // Can
				setSelectedBeerType(  BeerContainer.Can );
				setItem( _item );
				populate();
			case 2: // ..
				setSelectedBeerType(  BeerContainer.Draft );
				setItem( _item );
				populate();
			case 3: // ..
				setSelectedBeerType(  BeerContainer.Pitcher );
				setItem( _item );
				populate();
			case 4: // Back
				backHandler();
		}
	}
	
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
