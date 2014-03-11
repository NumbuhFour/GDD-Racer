
﻿package  Racer{
	
	import flash.display.MovieClip;
	import com.as3toolkit.ui.Keyboarder;
	
	public class Main extends MovieClip {
		//Messy messy mess
		public static var instance:Main;
		
		var _background:Level;
		var _gameScreen:GameScreen;
		
		public function Main() {
			new Keyboarder(this);			
			instance = this;
			win.visible = false;

			_background = new TestLevel();
			_gameScreen = new GameScreen(_background)
			//background = this.getChildByName("background_clip") as MovieClip;
			
			//_gameScreen.init();
			
			addChild(_gameScreen);
			
			
			
		}
		public function winDerp(){
			trace("derp");
			this.win.visible = true;
			this.swapChildren(this.win,this._gameScreen);
		}
	}
	
}