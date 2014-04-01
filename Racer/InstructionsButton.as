package Racer {
	
	import flash.display.SimpleButton;
	import flash.events.*;
	import flash.display.MovieClip;
	
	//Button that moves the player to the instructions screen
	public class InstructionsButton extends SimpleButton {
		
		
		public function InstructionsButton() {
			trace(this+" created");
			addEventListener(MouseEvent.CLICK,onClick);
		}
		
		private function onClick(e:Event)
		{
			trace(parent);
			(parent as UILayer).gotoAndStop("Instructions");
		}
	}
	
}