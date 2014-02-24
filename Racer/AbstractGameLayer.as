package Racer {
	
	import flash.display.Sprite;
	
	public class AbstractGameLayer extends Sprite{

		protected var _gameScreen:GameScreen;
		public function AbstractGameLayer(gameScreen:GameScreen) {
			_gameScreen = gameScreen;
		}

	}
	
}
