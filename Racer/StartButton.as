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
		private function startGame(e:Event)
		{
			(parent as UILayer).init();
		}
	}
	
}
