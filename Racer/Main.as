
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
		
		public function Main() {
			instance = this;
			new Keyboarder(this);
			stage.addEventListener(KeyboardEvent.KEY_UP, restartGameKey);
			
			startGame();
		}
		private function restartGameKey(e:KeyboardEvent){
			if(e.keyCode == Keyboard.R){
				trace("Restarting");
				this.win.visible = false;
				this.removeChild(_gameScreen);
				startGame();
			}
		}
		
		private function startGame(){
			
			win.visible = false;

			_background = new TestLevel();
			_gameScreen = new GameScreen(_background)
			//background = this.getChildByName("background_clip") as MovieClip;
			
			_gameScreen = new GameScreen(_background)
			
			
			addChild(_gameScreen);
		}
		
		public function winDerp(){
			trace("derp");
			this.win.visible = !this.win.visible;
		}
	}
	
}
