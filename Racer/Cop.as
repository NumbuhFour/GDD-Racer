package  Racer{
	
	import flash.display.MovieClip;
	import flash.geom.Point;
	
	public class Cop extends MovieClip{

		private var player:Player;
		private var velocity:int = 0;
		private var accel:int = 0;
		private var MAX_VEL:int = 10;
		private var vector:Point = new Point;
		
		public function Cop() {
			
		}
		
		public function init(aPlayer:Player){
			this.player = aPlayer;
			this.x = 100;
			this.y = 200;
		}
		
		public function initWithPosition(aPlayer:Player, x:int, y:int){
			this.x = x;
			this.y = y;
			this.player = aPlayer;
		}
		
		public function update(){
			this.vector.x = Math.sin(rotation) * velocity;
			this.vector.y = Math.cos(rotation) * velocity;
			if (this.velocity < this.MAX_VEL)
				this.velocity ++;
			var i:Number = angleToPlayer();
			trace(i);
			//rotation = i;
			if (i > rotation){
				rotation += 5;
			}
			else if (i < rotation){
				rotation -= 5;
			}
			this.x += vector.x;
			this.y += vector.y
		}
		
		private function angleToPlayer():Number{
			var angle:Number = Math.atan2(this.player.y - this.y, this.player.x - this.x);
			angle *= (180 / Math.PI);
			return angle;
		}

	}
	
}
