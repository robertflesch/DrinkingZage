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

import nme.Lib;


/**
 * @author Robert Flesch
 */
class BeerWindow extends ItemFinalWindow {
	
	private static var _instance:BeerWindow = null;
	private static var _lastContainer:BeerContainer = null;
	private static var _beerTabSelected:Dynamic = BeerContainer.Bottle;
	private 	   var _container:Sprite = null;
	private 	   var _label:Sprite = null;
	private 	   var _label_hvw:Float = 0;
	
	public static function instance():BeerWindow
	{ 
		if ( null == _instance )
			_instance = new BeerWindow();
			
		return _instance;
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
		trace( "BeerWindow.populate" );
		_tabSelected = _beerTabSelected;
		
		_container = new Sprite(); 
		_label = new Sprite();
		
		itemBuild();
		
		super.populate();
	}
	
	override public function tabHandler( me:MouseEvent ):Void
	{
		if ( me.stageY >= tabHeight() + logoHeight() )
			return;
			
		var index:Int = me.target.name;
		switch ( index )
		{
			case 0: // Bottle
				_tabSelected = _beerTabSelected = BeerContainer.Bottle;
			case 1: // Can
				_tabSelected = _beerTabSelected = BeerContainer.Can;
			case 2: // ..
				_tabSelected = _beerTabSelected = BeerContainer.Draft;
			case 3: // ..
				_tabSelected = _beerTabSelected = BeerContainer.Pitcher;
			case 4: // Back
				backHandler();
				return;
		}

		tabsRefresh();
		itemDraw();
	}
	
	private function getBeerImage( beer:ItemBeer, container:BeerContainer ):Bitmap
	{
		var bottleImage:Bitmap;
		if ( Type.enumEq( BeerContainer.Can, container ) )
		{
			bottleImage = new Bitmap (Assets.getBitmapData ("assets/beer/Can.png"));
		}
		else if ( Type.enumEq( BeerContainer.Bottle, container ) )
		{
			var colorName:String = Std.string( beer._color );
			var containerName:String = Std.string( container );
			
			trace( "assets/" + containerName + colorName + ".png");

			bottleImage = new Bitmap (Assets.getBitmapData ("assets/beer/" + containerName + colorName + ".png"));
		}
		else
		{
			var colorName:String = Std.string( beer._bcolor );
			var containerName:String = Std.string( container );
			
			trace( "assets/" + containerName + colorName + ".png");

			bottleImage = new Bitmap (Assets.getBitmapData ("assets/beer/" + containerName + colorName + ".png"));
		}
		return bottleImage;
	}

	private function addImage( beer:ItemBeer, type:BeerContainer ):Void
	{
		var bottleImage:Bitmap = getBeerImage( beer, type );
		var hvw = bottleImage.height / bottleImage.width;
		bottleImage.height = drawableHeight() * 0.90;
		bottleImage.width = bottleImage.height / hvw;
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
		
		_label = Utils.loadGraphic( "assets/beer/" + beer._label, true );
		_label_hvw = _label.height / _label.width;
	}
	
	private function hideContainers():Void
	{
		for ( i in 0..._container.numChildren )
			_container.getChildAt( i ).visible = false;
	}
	
	override public function itemDraw():Void	
	{
		hideContainers();
		
		// make the selected container visible
		var selectedContainer:DisplayObject = _container.getChildAt( Type.enumIndex( _tabSelected ) );
		selectedContainer.visible = true;
		
		var drawableCenterHeight:Float = (logoHeight() + tabHeight() + drawableHeight() / 2);
		_container.y = drawableCenterHeight - selectedContainer.height / 2;
		_container.x = (_stage.width * 2 / 3 ) / 2 - selectedContainer.width / 2;
		
		_label.width = selectedContainer.width;
		_label.height = _label.width * _label_hvw;
		
		var containerCenterHeight:Float = (logoHeight() + tabHeight() + drawableHeight() * 2 /  4 );
		
		// for each container we need to tweak the vertical label position 
		if ( Type.enumEq( BeerContainer.Bottle, _tabSelected ) )
		{
			// center of beer bottle label is below center of bottle image
			containerCenterHeight = (logoHeight() + tabHeight() + drawableHeight() * 2 /  3 );
		}
		else if ( Type.enumEq( BeerContainer.Can, _tabSelected ) )
		{
			// no special handling needed
		}
		else if ( Type.enumEq( BeerContainer.Draft, _tabSelected ) )
		{
			_label.width = (selectedContainer.width * 0.70);
			_label.height = _label.width * _label_hvw;
		}
		else if ( Type.enumEq( BeerContainer.Pitcher, _tabSelected ) )
		{
			_label.width = (selectedContainer.width * 0.70);
			_label.height = _label.width * _label_hvw;
		}
		else
		{  
			throw ("Unknown Container" );
		}

		_label.x = (_stage.width * 2 / 3 ) / 2 - _label.width / 2;
		_label.y = containerCenterHeight - (_label.height * 0.5);

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
