package com.drinkzage.windows;

/**
 * @author Robert Flesch
 */
class NotDoneYetWindow extends ItemFinalWindow {
	
	private static var _instance:NotDoneYetWindow = null;
	
	public static function instance():NotDoneYetWindow
	{ 
		if ( null == _instance )
			_instance = new NotDoneYetWindow();
			
		return _instance;
	}


	public function new () 
	{
		super();
		
		_tabs.push( "BACK" );
	}
	
	override public function populate():Void
	{
		super.setUseCount( false );
		_item = new Item( "Not Done Yet", null );
		setItem( _item );
		super.populate();
	}
}
