package  Racer{
	
	import flash.display.MovieClip;
	import com.as3toolkit.ui.Keyboarder;
	
	public class Main extends MovieClip {
		
		var _background:MovieClip;
		var _gameScreen:GameScreen;
		
		public function Main() {

			_background = new TestLevel();
			_gameScreen = new GameScreen(_background)
			//background = this.getChildByName("background_clip") as MovieClip;
			
			_gameScreen = new GameScreen(_background)
			if(_background){
				//this.removeChild(background);
				_gameScreen.addChild(_background);
			}
			_gameScreen.init();
			addChild(_gameScreen);
			new Keyboarder(this);
		}
	}
	
}
