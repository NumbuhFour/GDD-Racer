package  Racer{
	
	import flash.display.MovieClip;
	import flash.ui.Keyboard;
	import com.as3toolkit.ui.Keyboarder;
	import flash.geom.Point;
	
	public class Player extends MovieClip {

		private var velocityX:Number = 0;
		private var velocityY:Number = 0;
		
		private var velocityR:Number = 0; //Rotational velocity.
		private var accel:Number = 0; //Forward accelleration
		
		private var maxVel:Number = 30;
		private var maxAccel:Number = 8;
		private var maxVelR:Number = 8.5;
		
		private var accelSpeed:Number = 0.9; //Speed acceleration increases
		private var rotSpeed:Number = 0.65; //Speed rotation velocity increases;
		
		private var posX:Number = 0;
		private var posY:Number = 0;
		private var _rot:Number = 0;
		
		var leftPressed:Boolean = false;
		var rightPressed:Boolean = false;
		var upPressed:Boolean = false;
		var downPressed:Boolean = false;		
		
		public function Player() {
			//addEventListener(KeyboardEvent.KEY_UP, keyUpHandler);
			//addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
		}
		
		public function update():void {
			
			//Set velX and velY based on forward acceleration
			var rotRad:Number = rotation * (Math.PI/180);
			var vel:Point = new Point(Math.cos(rotRad)*accel,Math.sin(rotRad)*accel);
			
			var space:Boolean = Keyboarder.keyIsDown(Keyboard.SPACE);
			if(space){
				velocityX = MathHelper.clamp(velocityX + vel.x, -maxVel, maxVel);
				velocityY = MathHelper.clamp(velocityY + vel.y, -maxVel, maxVel);
			}else{
				velocityX = MathHelper.clamp(vel.x, -maxVel, maxVel);
				velocityY = MathHelper.clamp(vel.y, -maxVel, maxVel)
			}
			
			this.posX += this.velocityX;
			this.posY += this.velocityY;
			this._rot += this.velocityR;

			/* Moving camera around player effect: Ready to implement, but need background things to see if it works.
			parent.x = -x + stage.stageWidth/2;
			parent.y = -y + stage.stageHeight/2;
			parent.rotation = -rotation;
			*/
			
			velocityX *= 0.8;
			velocityY *= 0.8;
			
			takeInput();
		}
		
		private function takeInput():void {
			var left:Boolean,right:Boolean,up:Boolean,down:Boolean,space:Boolean;
			left = Keyboarder.keyIsDown(Keyboard.A);
			right = Keyboarder.keyIsDown(Keyboard.D);
			up = Keyboarder.keyIsDown(Keyboard.W);
			down = Keyboarder.keyIsDown(Keyboard.S);
			space = Keyboarder.keyIsDown(Keyboard.SPACE);
			
			if(left)
			{
				velocityR = MathHelper.clamp(velocityR - rotSpeed, -maxVelR, maxVelR);
			}
			if(right)
			{
				velocityR = MathHelper.clamp(velocityR + rotSpeed, -maxVelR, maxVelR);
			}
			
			if(left == right){
				velocityR *= 0.85;
			}
			
			if(!space)
			{
				if(up)
				{
					accel = MathHelper.clamp(accel + accelSpeed, -maxAccel, maxAccel);
				}
				if(down)
				{
					accel = MathHelper.clamp(accel - accelSpeed, -maxAccel, maxAccel);
				}
				
				if(up == down){
					accel *= 0.95;
				}
			}else{ //Handbreak
				velocityR *= 0.86;
				accel *= 0.92;
			}
			
			
			//Basing rotation speed on acceleration
			var accelPerc:Number =  MathHelper.clamp(Math.abs(accel)/(maxAccel/3),0,1);
			velocityR *= accelPerc;
			
			
			// Drifing float cleanup
			if(Math.abs(accel) < 0.5) accel = 0;
			if(Math.abs(velocityR) < 0.5) velocityR = 0;
			
		}
	
		public function get velocity():Point { return new Point(velocityX, velocityY); }
		public function set velocity(val:Point):void { velocityX = val.x; velocityY = val.y; }
		
		public function get position():Point { return new Point(posX,posY); }		
		public function set position(val:Point):void { this.posX = val.x; this.posY = val.y; }
		public function get rot():Number { return _rot; }
	}
	
}
