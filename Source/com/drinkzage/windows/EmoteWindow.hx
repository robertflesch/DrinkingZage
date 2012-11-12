package com.drinkzage.windows;


import nme.events.MouseEvent;
import com.drinkzage.windows.TabConst;

/**
 * @author Robert Flesch
 */
class EmoteWindow extends ItemFinalWindow {
	
	private static var _instance:EmoteWindow = null;
	
	public static function instance():EmoteWindow
	{ 
		if ( null == _instance )
			_instance = new EmoteWindow();
			
		return _instance;
	}

	public function new () 
	{
		super();
		_tabs.push( "BACK" );
	}
	
	override public function populate(item:Item):Void
	{
		addListeners();
		
		_window.prepareNewWindow();
		_item = item;
		itemDraw();
		_window.tabsDraw( _tabs, TabDefault.Back, tabHandler );
	}
	
	
	override public function tabHandler( me:MouseEvent ):Void
	{
		if ( me.stageY >= Globals.g_app.tabHeight() + Globals.g_app.logoHeight() )
			return;
			
		backHandler();	
	}
	
	override public function backHandler():Void
	{
		super.backHandler();
		var blw: EmoticonsWindow = EmoticonsWindow.instance();
		blw.populate();
	}
	
}
