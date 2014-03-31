package Racer {
	
	import flash.display.SimpleButton;
	import flash.events.*;
	
	//Button that moves the player to the credits screen
	public class CreditsButton extends SimpleButton {
		
		
		public function CreditsButton() {
			trace(this+" created");
			addEventListener(MouseEvent.CLICK,onClick);
		}
		
		private function onClick(e:Event)
		{
			//(parent as UILayer).gotoAndStop('credits');
		}
	}
	
}
