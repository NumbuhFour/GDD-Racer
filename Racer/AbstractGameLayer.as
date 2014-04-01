package Racer {
	
	import flash.display.MovieClip;
	
	public class AbstractGameLayer extends MovieClip{

		public var _gameScreen:GameScreen;
		public function AbstractGameLayer(gameScreen:GameScreen) {
			_gameScreen = gameScreen;
		}

	}
	
}
