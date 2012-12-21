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
	private 	   var _customText : TextField = null;
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
		
		_customText = new TextField();
		_customText.text = "";
		_customText.setTextFormat( _textFormat );
	}
	
	//
	///////////////////////////////////////////////////////////////
	// overides 
	///////////////////////////////////////////////////////////////
	
	override public function populate():Void
	{
		super.populate();
		
		_customText.name = "_customText";
		_customText.selectable = true;
		_customText.border = true;
		//_customText.borderColor = Globals.COLOR_SAGE;
		_customText.width = Lib.current.stage.stageWidth;
		_customText.height = componentHeight();
		_customText.y = Lib.current.stage.stageHeight - _customText.height - 2;
		_customText.x = 0;
		_customText.type = TextFieldType.INPUT;
		_em.addEvent( _customText, Event.CHANGE, TextField_onChange );
		_em.addEvent( _customText, FocusEvent.FOCUS_IN, searchGetFocus );
		_customText.background = true;
		_customText.backgroundColor = Globals.COLOR_WHITE;
		_customText.text = _item.name();
		_customText.setTextFormat( _textFormat );
		
		_window.addChild( _customText );
		
		// Accepts changes
		_button = Utils.loadGraphic( "assets/" + "tab_active.png", true );
		_button.height = componentHeight() * 2;
		_button.width = _stage.width;
		_button.y = _customText.y - _button.height;
		_button.x = 0;
		
		var text : TextField = new TextField();
		text.selectable = false;
		text.text = "Use Changes one time";
		text.height = componentHeight()/3;
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
		_em.addEvent( _button, MouseEvent.CLICK, acceptChanges );
	
		_window.addChild( _button );
		
		// Accepts and Save changes
		_buttonSave = Utils.loadGraphic( "assets/" + "tab_active.png", true );
		_buttonSave.height = componentHeight() * 2;
		_buttonSave.width = _stage.width;
		_buttonSave.y = _button.y - _buttonSave.height;
		_buttonSave.x = 0;
		
		var textSave : TextField = new TextField();
		textSave.selectable = false;
		textSave.text = "Accept & Save Changes";
		textSave.height = componentHeight()/3;
		textSave.name = "Accept SaveChanges";
			
		textSave.width = _buttonSave.width / 6.5;
				
		textSave.y = _buttonSave.height/ 8;
		textSave.x = 0;
		
//		textSave.border = true;
//		textSave.borderColor = 0xffff00;
		
		textSave.setTextFormat(ts);
		_buttonSave.addChild(textSave);
		_em.addEvent( _buttonSave, MouseEvent.CLICK, acceptChanges );
		
		_window.addChild( _buttonSave );
///////////////
		_stage.focus = _customText;
	}
	
	public function acceptChanges( event:MouseEvent ):Void
	{
		Globals.g_itemLibrary.addCustomDrink( _item.category(), _item.name(), _customText.text );
		_backHandler.setItem( new Item( _customText.text, null ) );
		backHandler();
	}
	
	public function searchGetFocus( event:FocusEvent ):Void
	{
		_em.addEvent( _customText, FocusEvent.FOCUS_IN, searchGetFocus );
		
		_customText.setTextFormat( _textFormat );
#if android
		_customText.y = Lib.current.stage.stageHeight / 2 + _customText.height / 2 - 20;
		_button.y  = _customText.y - _button.height;
		_buttonSave.y  = _button.y - _buttonSave.height;
#end		
	}

	public function TextField_onChange( event:Event ): Void
	{
		var textField:TextField = event.currentTarget;
		
		_customText.text = textField.text;
		_customText.setTextFormat( _textFormat );
	}
}
