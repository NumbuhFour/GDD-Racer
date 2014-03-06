package  Racer{
	
	import flash.display.MovieClip;
	import flash.geom.Point;
	
	public class Cop extends MovieClip{

		private var player:Player;
		private var velocity:int = 0;
		private var accel:int = 0;
		private var MAX_VEL:int = 8;
		private var vector:Point = new Point;
		
		public function Cop() {
			
		}
		
		public function init(aPlayer:Player){
			this.player = aPlayer;
			this.x = 100;
			this.y = 100;
		}
		
		public function initWithPosition(aPlayer:Player, x:int, y:int){
			this.x = x;
			this.y = y;
			this.player = aPlayer;
		}
		
		public function update(){
			var radians:Number = rotation * Math.PI/180;
			this.vector.x = Math.cos(radians) * velocity;
			this.vector.y = Math.sin(radians) * velocity;
			

			var i:int = angleToPlayer();
			trace(this.vector + "   angle: " + i + "    rotation: " + rotation);
			rotation -= ((i - rotation) * (velocity/MAX_VEL))/20 * signOf(velocity);
			
			if (Math.floor(i - rotation) > 90 && this.velocity > -5){
				this.velocity --;
			}
			else if (this.velocity < this.MAX_VEL)
				this.velocity ++;
			
			this.x += vector.x;
			this.y += vector.y
		}
		
		private function signOf(val:Number):int{
			if (val >= 0)
				return 1;
			else
				return -1;
		}
		
		private function angleToPlayer():Number{
			var angle:Number = Math.atan2(this.player.position.y - this.y, this.player.position.x - this.x);
			angle *= (180 / Math.PI);
			return angle;
		}

	}
	
}
