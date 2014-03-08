package Racer {
	
	import flash.display.SimpleButton;
	import flash.events.*;
	
	//Button that moves the player to the title screen
	public class MainButton extends SimpleButton {
		
		
		public function MainButton() {
			trace(this+" created");
			addEventListener(MouseEvent.CLICK,onClick);
		}
		
		private function onClick(e:Event)
		{
			(parent as UILayer).gotoAndStop('main');
		}
	}
	
}