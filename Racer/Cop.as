package  Racer{
	
	import flash.display.MovieClip;
	import flash.geom.Point;
	
	public class Cop extends MovieClip{

		private var player:Player;
		private var velocity:int = 0;
		private var accel:int = 0;
		private var MAX_VEL:int = 8;
		private var vPos:Point = new Point();
		private var vVel:Point = new Point();
		
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
			this.vVel.x = Math.cos(radians) * velocity;
			this.vVel.y = Math.sin(radians) * velocity;
			this.vPos.x = this.x;
			this.vPos.y = this.y;

			var angle:int = angleToPlayer(calculateInterceptPoint());
			trace(this.vPos + "\tangle: " + angle + "\trotation: " + rotation + "\tIntercept Point: " + calculateInterceptPoint());
			rotation += ((angle) * (velocity/MAX_VEL))/20 * signOf(velocity);
			
			if (Math.abs(angle) > 90 && this.velocity > -5){
				this.velocity --;
			}
			else if (this.velocity < this.MAX_VEL)
				this.velocity ++;
			
			this.x += vVel.x;
			this.y += vVel.y
		}
		
		private function signOf(val:Number):int{
			if (val >= 0)
				return 1;
			else
				return -1;
		}
		
		private function chase(){
			
		}

		private function intercept(){
			
		}
		
		private function calculateInterceptPoint():Point{
			var pos:Point = MathHelper.subPoints(player.position, vPos);
			var vel:Point = MathHelper.subPoints(player.velocity, vVel);
			//trace("Pos: " + pos + "\tVel: " + vel);
			var timeToClose:Number = Math.sqrt(Math.pow(pos.x, 2) + Math.pow(pos.y, 2)) / Math.sqrt(Math.pow(vel.x, 2) + Math.pow(vel.y, 2))
			trace("ttc: " + timeToClose);
			return MathHelper.addPoints(player.position, MathHelper.scalePoint(player.velocity, timeToClose));
		}
		
		private function angleToPlayer(point:Point):Number{
			var angle:Number = Math.atan2(point.y - this.y, point.x - this.x);
			angle *= (180 / Math.PI);
			return angle;
		}

	}
	
}
