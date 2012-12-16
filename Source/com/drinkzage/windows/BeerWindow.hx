package com.drinkzage.windows;

import nme.Assets;
import nme.display.DisplayObject;
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
	private 	   var _container:Sprite = null;
	private 	   var _label:Sprite = null;
	
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
		//_tabSelected = _beerTabSelected;
		_tabSelected = BeerContainer.Bottle;
		_container = new Sprite(); 
		_label = new Sprite();
		
		itemBuild();
		
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
				_tabSelected = BeerContainer.Bottle;
			case 1: // Can
				_tabSelected = BeerContainer.Can;
			case 2: // ..
				_tabSelected = BeerContainer.Draft;
			case 3: // ..
				_tabSelected = BeerContainer.Pitcher;
			case 4: // Back
				backHandler();
		}

		tabsRefresh();
		itemDraw();
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

	private function addImage( beer:ItemBeer, type:BeerContainer ):Void
	{
		var bottleImage:Bitmap = getBeerImage( beer, type );
		//var hvw = bottleImage.height / bottleImage.width;
		//bottleImage.height = _stage.stageHeight * 0.75;
		//bottleImage.width = bottleImage.height / hvw;
		bottleImage.visible = false;
		_container.addChildAt( bottleImage, Type.enumIndex( type ) );
	}
	
	public function itemBuild():Void
	{
		var beer:ItemBeer = cast( _item, ItemBeer );
		addImage( beer, BeerContainer.Bottle );
		addImage( beer, BeerContainer.Can );
		addImage( beer, BeerContainer.Draft );
		addImage( beer, BeerContainer.Pitcher );
		var label:Bitmap = new Bitmap (Assets.getBitmapData ( "assets/" + beer._label ));
		var tmp:Float = Globals.g_app.drawableHeight();
		var hvw = _stage.height / _stage.width;
		_container.y = (Globals.g_app.logoHeight() + Globals.g_app.tabHeight() + Globals.g_app.drawableHeight() / 2) - _container.height / 2;
		_container.x = (_stage.width * 2 / 3 ) / 2 - _container.width / 2;
		
		_label = Utils.loadGraphic( "assets/" + beer._label, true );
		label.x = 300;
		//label.x = (_stage.width * 2 / 3 ) / 2 - label.width / 2;

	}
	
	private function hideContainers():Void
	{
		for ( i in 0..._container.numChildren )
			_container.getChildAt( i ).visible = false;
	}
	
	override public function itemDraw():Void	
	{
		// height is 744
		// width is 320
		var beer:ItemBeer = cast( _item, ItemBeer );
		
		var width:Float = _stage.stageWidth;
		var height:Float = _stage.stageHeight;
		
		hideContainers();
		
		_container.getChildAt( Type.enumIndex( _tabSelected ) ).visible = true;
		if ( Type.enumEq( BeerContainer.Bottle, _tabSelected ) )
		{
		}
		else if ( Type.enumEq( BeerContainer.Can, _tabSelected ) )
		{
		}
		else if ( Type.enumEq( BeerContainer.Draft, _tabSelected ) )
		{
		}
		else if ( Type.enumEq( BeerContainer.Pitcher, _tabSelected ) )
		{
		}
		else
		{  
			throw ("Unknown Container" );
		}

		
/*		if ( Type.enumEq( BeerContainer.Bottle, _tabSelected ) )
		{
			var bottleImage:Bitmap = cast( _container.getChildAt( 0 ), Bitmap );
			var scaling:Float = bottleImage.width/_container.width;
			
			_container.y = bottleImage.y + bottleImage.height / 2 - _container.height / 2 + 10;
			_container.x = bottleImage.x + bottleImage.width / 2 - _container.width / 2;
		}
		else if ( Type.enumEq( BeerContainer.Can, _tabSelected ) )
		{
			var bottleImage:Bitmap = cast( _container.getChildAt( 0 ), Bitmap );
			var scaling:Float = bottleImage.width/_container.width;
			_container.width = bottleImage.width;
			_container.height = _container.height * scaling;
			
			_container.y = bottleImage.y + bottleImage.height / 2 - _container.height / 2 + 10;
			_container.x = bottleImage.x + bottleImage.width / 2 - _container.width / 2;
		}
		/*
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
		{  // BOTTLE
			var scaling:Float = bottleImage.width/label.width;
			label.width = bottleImage.width;
			label.height = label.height * scaling;
			
			label.y = bottleImage.y + bottleImage.height * 11 / 16 - label.height / 2;
			label.x = bottleImage.x + bottleImage.width / 2 - label.width / 2;
		}
*/
		_window.addChild( _container );
		_window.addChild( _label );

	}
}

enum BeerContainer {
	Bottle;
	Can;
	Draft;
	Pitcher;
	Other;
}
