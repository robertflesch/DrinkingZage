package com.drinkzage.windows;

import nme.display.Sprite;
import nme.Vector;
import Std;

import nme.Assets;
import nme.Lib;
import nme.Vector;

import nme.display.Stage;

import nme.events.Event;
import nme.events.FocusEvent;
import nme.events.MouseEvent;
import nme.events.KeyboardEvent;

import nme.text.TextField;
import nme.text.TextFormat;
import nme.text.TextFormatAlign;
import nme.text.TextFieldType;

import nme.ui.Mouse;

import com.drinkzage.Globals;

import com.drinkzage.utils.Utils;

import com.drinkzage.windows.ListWindowConsts;

/**
 * @author Robert Flesch
 */
class CustomTextInputWindow extends ITabWindow
{
	private static var _instance:CustomTextInputWindow = null;

	private 	   var _textFormat:TextFormat = null;
	private 	   var _searchText : TextField = null;
	private 	   var _item:Item = null;
	private		   var _button:Sprite = null;
	private		   var _buttonSave:Sprite = null;

	public static function instance():CustomTextInputWindow
	{ 
		if ( null == _instance )
		{
			_instance = new CustomTextInputWindow();
		}
			
		return _instance;
	}

	public function setItem( item:Item ):Void
	{
		_item = item;
	}

	private function new () 
	{
		super();
		
		setUseSearch( false );
		
		_tabs.push( "BACK" );

		_textFormat = new TextFormat("_sans");
		_textFormat.size = 32;                // set the font size
		_textFormat.align = TextFormatAlign.CENTER;
		_textFormat.color = 0x000000;
		
		_searchText = new TextField();
		_searchText.text = "";
		_searchText.setTextFormat( _textFormat );
	}
	
	//
	///////////////////////////////////////////////////////////////
	// overides 
	///////////////////////////////////////////////////////////////
	
	override public function populate():Void
	{
		super.populate();
		
		_searchText.name = "_searchText";
		_searchText.selectable = true;
		_searchText.border = true;
		//_searchText.borderColor = Globals.COLOR_SAGE;
		_searchText.width = Lib.current.stage.stageWidth;
		_searchText.height = _window.componentHeight();
		_searchText.y = Lib.current.stage.stageHeight - _searchText.height - 2;
		_searchText.x = 0;
		_searchText.type = TextFieldType.INPUT;
		_searchText.addEventListener (Event.CHANGE, TextField_onChange);
		_searchText.addEventListener ( FocusEvent.FOCUS_IN, searchGetFocus );
		_searchText.background = true;
		_searchText.backgroundColor = Globals.COLOR_WHITE;
		_searchText.text = _item.name();
		_searchText.setTextFormat( _textFormat );
		
		_window.addChild( _searchText );
		
		// Accepts changes
		_button = Utils.loadGraphic( "assets/" + "tab_active.png", true );
		_button.height = Globals.g_app.componentHeight() * 2;
		_button.width = _stage.width;
		_button.y = _searchText.y - _button.height;
		_button.x = 0;
		
		var text : TextField = new TextField();
		text.selectable = false;
		text.text = "Use Changes one time";
		text.height = Globals.g_app.componentHeight()/3;
		text.name = "Accept Changes";
			
		text.width = _button.width / 6.5;
				
		text.y = _button.height/ 8;
		text.x = 0;
		
//		text.border = true;
//		text.borderColor = 0xffff00;
		
		var ts:TextFormat = new TextFormat("_sans");
		ts.size = 11;                // set the font size
		ts.align = TextFormatAlign.CENTER;
		ts.color = 0xffffff;
		text.setTextFormat(ts);
		_button.addChild(text);
		_button.addEventListener( MouseEvent.CLICK, acceptChanges );
	
		_window.addChild( _button );
		
		// Accepts and Save changes
		_buttonSave = Utils.loadGraphic( "assets/" + "tab_active.png", true );
		_buttonSave.height = Globals.g_app.componentHeight() * 2;
		_buttonSave.width = _stage.width;
		_buttonSave.y = _searchText.y - _buttonSave.height;
		_buttonSave.x = 0;
		
		var textSave : TextField = new TextField();
		textSave.selectable = false;
		textSave.text = "Accept & Save Changes";
		textSave.height = Globals.g_app.componentHeight()/3;
		textSave.name = "Accept SaveChanges";
			
		textSave.width = _buttonSave.width / 6.5;
				
		textSave.y = _buttonSave.height/ 8;
		textSave.x = 0;
		
//		textSave.border = true;
//		textSave.borderColor = 0xffff00;
		
		textSave.setTextFormat(ts);
		_buttonSave.addChild(textSave);
		_buttonSave.addEventListener( MouseEvent.CLICK, acceptChanges );
		
		_window.addChild( _buttonSave );
///////////////
		_stage.focus = _searchText;
	}
	
	override public function removeListeners():Void
	{
		super.removeListeners();
		_button.removeEventListener( MouseEvent.CLICK, acceptChanges );
		_buttonSave.removeEventListener( MouseEvent.CLICK, acceptChanges );
	}

	public function acceptChanges( event:MouseEvent ):Void
	{
		Globals.g_dataPersistance.addCustomDrink( "Wine", "Custom1", "Nancy doesnt suck" );
		_backHandler.setItem( new Item( _searchText.text, null ) );
		backHandler();
	}
	
	public function searchGetFocus( event:FocusEvent ):Void
	{
		_searchText.removeEventListener ( FocusEvent.FOCUS_IN, searchGetFocus );
		
		_searchText.setTextFormat( _textFormat );
//#if android
		_searchText.y = Lib.current.stage.stageHeight / 2 + _searchText.height / 2 - 20;
		_button.y  = _searchText.y - _button.height;
		_buttonSave.y  = _button.y - _buttonSave.height;
//#end		
	}

	public function TextField_onChange( event:Event ): Void
	{
		var textField:TextField = event.currentTarget;
		
		_searchText.text = textField.text;
		_searchText.setTextFormat( _textFormat );
	}
}
