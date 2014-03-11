package  Racer{
	
	import flash.display.MovieClip;
	import com.as3toolkit.ui.Keyboarder;
	
	public class Main extends MovieClip {
		
		var _background:Level;
		var _gameScreen:GameScreen;
		
		public function Main() {

			_background = new TestLevel();
			_gameScreen = new GameScreen(_background);
			//background = this.getChildByName("background_clip") as MovieClip;
			
			//_gameScreen.init();
			
			
			addChild(_gameScreen);
			new Keyboarder(this); 
		}
	}
	
}
