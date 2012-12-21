package com.drinkzage;

import nme.Lib;
import nme.display.Sprite;
import nme.display.Stage;
import nme.display.StageAlign;
import nme.display.StageQuality;
import nme.display.StageScaleMode;

import nme.events.Event;

import com.drinkzage.Globals;
import com.drinkzage.windows.MainWindow;
import com.drinkzage.utils.ItemLibrary;

#if flash
import org.flashdevelop.utils.FlashConnect;
#end

/**
 * @author Robert Flesch
 */
class DrinkingZage extends Sprite 
{
	public function new () {
		
		super ();
		
		Globals.g_app = this;
		
		addEventListener( Event.ADDED_TO_STAGE, addedToStage );
		
		Globals.g_itemLibrary = new ItemLibrary();
	}
	
	private function addedToStage( e:Event ):Void
	{
		removeEventListener( Event.ADDED_TO_STAGE, addedToStage );
		
		Globals.g_stage = stage;
		Lib.current.stage.scaleMode = EXACT_FIT;
#if flash
		stage.showDefaultContextMenu = false;
#end
		
#if android		
		stage.needsSoftKeyboard = true;
#end		
	
		var win:MainWindow = new MainWindow();
		win.populate();
	}
	// Entry point
	public static function main () 
	{
		#if flash
			FlashConnect.redirect();
		#end
		Lib.current.addChild (new DrinkingZage ());
	}
}

