package Racer {
	
	import flash.display.SimpleButton;
	import flash.events.*;
	
	//Button that moves the player to the game
	public class StartButton extends SimpleButton {
		
		
		public function StartButton() {
			trace(this+" created");
			addEventListener(MouseEvent.CLICK,startGame);
		}
		
		//init() creates the starting hexagon, moves to the UILayer's game frame, and starts the countdown timer
		private static function startGame(e:Event)
		{
			trace("Start button pressed");
			Main.instance.startGame();
		}
	}
	
}
