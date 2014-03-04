package  Racer{
	
	import flash.display.MovieClip;
	import com.as3toolkit.ui.Keyboarder;
	
	public class Main extends MovieClip {
		
		
		var gameScreen:GameScreen;
		
		public function Main() {
			gameScreen = new GameScreen(background_clip)
			this.removeChild(background_clip);
			gameScreen.addChild(background_clip);
			gameScreen.init();
			addChild(gameScreen);
			new Keyboarder(this);
		}
	}
	
}
