package  Racer{
	
	import flash.display.MovieClip;
	import com.as3toolkit.ui.Keyboarder;
	
	public class Main extends MovieClip {
		
		
		var gameScreen:GameScreen = new GameScreen();
		
		public function Main() {
			gameScreen.init();
			addChild(gameScreen);
			new Keyboarder(this);
		}
	}
	
}
