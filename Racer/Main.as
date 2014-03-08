package  Racer{
	
	import flash.display.MovieClip;
	import com.as3toolkit.ui.Keyboarder;
	
	public class Main extends MovieClip {
		
		
		var background:MovieClip;
		var gameScreen:GameScreen;
		
		public function Main() {
			background = this.getChildByName("background_clip") as MovieClip;
			gameScreen = new GameScreen(background)
			if(background){
				this.removeChild(background);
				gameScreen.addChild(background);
			}
			gameScreen.init();
			addChild(gameScreen);
			new Keyboarder(this);
		}
	}
	
}
