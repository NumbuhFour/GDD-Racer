package  Racer{
	
	import flash.display.MovieClip;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	import flash.geom.Rectangle;
	
	public class Cop extends MovieClip{

		private var gameScreen:GameScreen;
		private var player:Player;
		private var velocity:int = 0;
		private var accel:int = 0;
		private var MAX_VEL:int = 8;
		private var vPos:Point = new Point();
		private var vVel:Point = new Point();
		private var currAction:String = "patrol";
		private var actions:Dictionary = new Dictionary();
		
		
		public function Cop(gameScreen:GameScreen) {
			this.gameScreen = gameScreen;
		}
		
		public function init(aPlayer:Player){
			initWithPosition(aPlayer, 100, 100);
		}
		
		//initializes officer with a location
		public function initWithPosition(aPlayer:Player, x:int, y:int){
			this.x = x;
			this.y = y;
			this.player = aPlayer;
			actions["stop"] = 0;
			actions["stun"] = 1;
			actions["patrol"] = 2;
			actions["intercept"] = 3;
			actions["chase"] = 4;
			changeState("patrol");
		}
		
		//changes the cop's current objective
		public function changeState(newState:String){
			this.currAction = newState;
			if (this.actions[currAction] > 2){
				if (!this.isPlaying)
					this.play();
				this.MAX_VEL = 10;
			}
			else if (this.actions[currAction] < 3){
				if (this.isPlaying)
					this.gotoAndStop(1);
				this.MAX_VEL = 6;
			}
		}
		
		//updates officer's location and velocity
		public function update(){
			var radians:Number = rotation * Math.PI/180;
			this.vVel.x = Math.cos(radians) * velocity;
			this.vVel.y = Math.sin(radians) * velocity;
			this.vPos.x = this.x;
			this.vPos.y = this.y;
			var angle:Number
			if (this.actions[currAction] > 3){
				angle = angleToPlayer(calculateInterceptPoint());
			}
			if (this.actions[currAction] > 1){
				rotation += ((angle) * (velocity/MAX_VEL))/20 * signOf(velocity);
				if (Math.abs(angle) > 90 && this.velocity > -5)
					this.velocity --;
				else if (this.velocity < this.MAX_VEL)
					this.velocity ++;
				var rightRect:Rectangle = this.getChildByName("rightFeeler").getRect(this);
				var frontRect:Rectangle = this.getChildByName("frontFeeler").getRect(this);
				var leftRect:Rectangle = this.getChildByName("leftFeeler").getRect(this);
				if (!(rightRect.intersects(player.getRect(this)) || 
					frontRect.intersects(player.getRect(this)) || 
					leftRect.intersects(player.getRect(this)))){
					for (var i:int = 0; i < gameScreen.background.numChildren; i++){
						var rect:Rectangle = gameScreen.background.getChildAt(i).getRect(parent.parent);
						if (rect.intersects(rightRect) && !rect.intersects(leftRect)){
							rotation += 10;
							velocity --;
						}
						else if (rect.intersects(leftRect) && !rect.intersects(rightRect)){
							rotation -= 10;
							velocity --;
						}
						else if (rect.intersects(leftRect) && rect.intersects(rightRect) && rect.intersects(frontRect)){
							rotation += 10;							
							velocity --;
						}
					}
				}
			}
	
			
			/*var angle:int = angleToPlayer(calculateInterceptPoint());
			trace(this.vPos + "\tangle: " + angle + "\trotation: " + rotation + "\tIntercept Point: " + calculateInterceptPoint());
			rotation += ((angle) * (velocity/MAX_VEL))/20 * signOf(velocity);
			
			if (Math.abs(angle) > 90 && this.velocity > -5){
				this.velocity --;
			}
			else if (this.velocity < this.MAX_VEL)
				this.velocity ++;
			
			this.x += vVel.x;
			this.y += vVel.y*/
		}
		
		//returns the sign of a number
		private function signOf(val:Number):int{
			if (val >= 0)
				return 1;
			else
				return -1;
		}
		
		//calculates the point at which the cop will reach the player
		private function calculateInterceptPoint():Point{
			var pos:Point = MathHelper.subPoints(player.position, vPos);
			var vel:Point = MathHelper.subPoints(player.velocity, vVel);
			//trace("Pos: " + pos + "\tVel: " + vel);
			var timeToClose:Number = Math.sqrt(Math.pow(pos.x, 2) + Math.pow(pos.y, 2)) / Math.sqrt(Math.pow(vel.x, 2) + Math.pow(vel.y, 2))
			trace("ttc: " + timeToClose);
			return MathHelper.addPoints(player.position, MathHelper.scalePoint(player.velocity, timeToClose));
		}
		
		//calculates the angle to the player
		private function angleToPlayer(point:Point):Number{
			var angle:Number = Math.atan2(point.y - this.y, point.x - this.x);
			angle *= (180 / Math.PI);
			return angle;
		}

	}
	
}
