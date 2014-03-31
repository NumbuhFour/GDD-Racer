
﻿package  Racer{
	
	import flash.display.MovieClip;
	import com.as3toolkit.ui.Keyboarder;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	
	public class Main extends MovieClip {
		//Messy messy mess
		public static var instance:Main;
		
		var _background:Level;
		var _gameScreen:GameScreen;
		var _uiLayer:UILayer;
		
		public function Main() {
			instance = this;
			new Keyboarder(this);
			stage.addEventListener(KeyboardEvent.KEY_UP, restartGameKey);
			//make game screen
			_uiLayer = new UILayer(null);
			addChildAt(_uiLayer,1);
			
			//startGame();
		}
		private function restartGameKey(e:KeyboardEvent){
			if(e.keyCode == Keyboard.R){
				trace("Restarting");
				this.win.visible = false;
				this.removeChild(_gameScreen);
				startGame();
			}
		}
		
		public function startGame(){
			
			win.visible = false;

			_background = new TestLevel();
			_gameScreen = new GameScreen(_background)
			_uiLayer._gameScreen = _gameScreen;
			//background = this.getChildByName("background_clip") as MovieClip;
			addChildAt(_gameScreen,0);
			_gameScreen.Start();
		}
		
		public function winDerp(){
			trace("derp");
			this.win.visible = !this.win.visible;
		}
	}
	
}
