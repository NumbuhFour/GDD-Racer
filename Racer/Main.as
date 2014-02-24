package  Racer{
	
	import flash.display.MovieClip;
	
	
	public class Main extends MovieClip {
		
		
		var gameScreen:GameScreen = new GameScreen();
		
		public function Main() {
			gameScreen.init();
			addChild(gameScreen);
		}
		
		
	}
	
}
