package  Racer{
	
	import flash.display.MovieClip;
	
	public class Player extends MovieClip {

		private var velocityX:int = 0;
		private var velocityY:int = 0;
		var leftPressed:Boolean = false;
		var rightPressed:Boolean = false;
		var upPressed:Boolean = false;
		var downPressed:Boolean = false;		
		
		public function Player() {
			//addEventListener(KeyboardEvent.KEY_UP, keyUpHandler);
			//addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
			
		}
		
		public function update(){
			this.x += this.velocityX;
			this.y += this.velocityY;
			
		}
		
		private function input(){
			
		}

	}
	
}
