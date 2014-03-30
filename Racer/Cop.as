package  Racer{
	
	import flash.display.MovieClip;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	import flash.geom.Rectangle;
	import Box2D.Dynamics.b2World;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2Body;
	import Box2D.Collision.Shapes.b2Shape;
	import Box2D.Dynamics.b2FixtureDef;
	import Box2D.Dynamics.b2Fixture;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Collision.Shapes.b2PolygonShape;
	
	public class Cop extends PhysicalClip{

		private var gameScreen:GameScreen;
		private var player:Player;
		private var velocity:Number = 0;
		private var accel:int = 0;
		private var MAX_VEL:int = 5;
		private var los:Boolean =false;
		private var vPos:Point = new Point();
		private var vVel:Point = new Point();
		private var utilPoint:Point = new Point();
		private var path:Vector.<Node>;
		private var node:Node;
		private var dispatch:Dispatch;
		private var currAction:String;
		private var actions:Dictionary = new Dictionary();
		
		public function get LOS():Boolean { return this.los; }
		public function get State():String { return this.currAction; }
		public function get CurrNode():Node { return this.node; }
		public function set CurrNode(node:Node) { this.node = node; }
		public function get Path():Vector.<Node> { return this.path; }
		public function set Path(path:Vector.<Node>) { 
			this.path = path; 
			this.node = this.path.pop(); }
		
		public function Cop(gameScreen:GameScreen) {
			this.gameScreen = gameScreen;
		}
		
		protected override function setupPhys() {
			_bodyDef = new b2BodyDef();
			_bodyDef.type = b2Body.b2_dynamicBody;
			
			_fixtureDef = new b2FixtureDef();
			
			_body = _world.CreateBody(_bodyDef);			
			
			_shape = new b2PolygonShape();
			var wid:Number = 88;
			var hei:Number = 45;
			(_shape as b2PolygonShape).SetAsBox(wid / 2 / GameScreen.SCALE, hei / 2 / GameScreen.SCALE);
			_fixtureDef.shape = _shape;
			_fixtureDef.density = 0.3;
			_fixture = _body.CreateFixture(_fixtureDef);
			
		}
		
		public function init(aPlayer:Player, dispatch:Dispatch){
			initWithPosition(aPlayer, 100, 100, dispatch);
		}
		
		//initializes officer with a location
		public function initWithPosition(aPlayer:Player, x:int, y:int, dispatch:Dispatch){
			//this.x = x;
			//this.y = y;
			_body.SetPosition(new b2Vec2(x / GameScreen.SCALE, y / GameScreen.SCALE));
			this.player = aPlayer;
			this.dispatch = dispatch;
			actions["stop"] = 0;
			actions["stun"] = 1;
			actions["patrol"] = 2;
			actions["intercept"] = 3;
			actions["chase"] = 4;
			changeState("chase");
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
			var deltaRot:Number = 0;
			this.x = _body.GetPosition().x * GameScreen.SCALE;
			this.y = _body.GetPosition().y * GameScreen.SCALE;
			super.rotation  = _body.GetAngle()*MathHelper.RADTODEG;

			_body.SetAngularVelocity(0);
			_body.SetLinearVelocity(new b2Vec2());
			
			
			var angle:Number;
			if (this.actions[currAction] == 4){
				angle = angleToPoint(calculateInterceptPoint());
			}
			else if (this.actions[currAction] == 3){
				if (node != null)
					angle = angleToPoint(node.point);
				else
					angle = 0;
			}
			if (this.actions[currAction] > 1){
				//fix this
				angle = angle % 360;
				/*if (angle > 180)
					angle -= 360;
				else if (angle < -180)
					angle += 360;*/
				if (angle > 180)
					deltaRot = -((angle) *  Math.abs(velocity/MAX_VEL))/20;
				else
					deltaRot = ((angle) * Math.abs(velocity/MAX_VEL))/20;
				if ((Math.abs(angle) > 80 && Math.abs(angle) < 280) && this.velocity > -5){
					//trace("back up\t" + angle + "\n");
					this.velocity -= .3;
				}
				else if (this.velocity < this.MAX_VEL){
					this.velocity += .3;
					//trace("chase\t" + angle + "\n");
				}
				var xComp:Number = Math.cos(MathHelper.DEGTORAD * rotation) * 83;
				var yComp:Number = Math.sin(MathHelper.DEGTORAD * rotation) * 83;
				var dX:Number = xComp;
				var dY:Number = yComp; 
				var leftFront:int = 6;
				var midFront:int = 6;
				var rightFront:int =6;
				var leftBack:int = 6;
				var midBack:int = 6;
				var rightBack:int = 6;
				var checkPoint:Point;
				var counter:int = 0;
				//check to see if there is anything directly in front
				while (counter < 5 && (leftFront == 6 || rightFront == 6 || midFront == 6 || leftBack == 6 || rightBack == 6 || midBack == 6)){
					counter++;
					dX += xComp/2;
					dY += yComp/2;
					for each (var building:Building in this.gameScreen._buildings){
						if (midFront == 6 && building.getRect(gameScreen._backgroundClip).contains(this.x + dX, this.y + dY))
							midFront = counter;
						if (midBack == 6 && building.getRect(gameScreen._backgroundClip).contains(this.x - dX, this.y - dY))
							midBack = counter;
						checkPoint = rotatePoint(dX, dY, -30);
						if (leftFront == 6 && building.getRect(gameScreen._backgroundClip).contains(this.x + checkPoint.x, this.y + checkPoint.y))
							leftFront = counter;
						if (rightBack == 6 && building.getRect(gameScreen._backgroundClip).contains(this.x - checkPoint.x, this.y - checkPoint.y))
							rightBack = counter;
						checkPoint = rotatePoint(dX, dY, 30);
						if (rightFront == 6 && building.getRect(gameScreen._backgroundClip).contains(this.x + checkPoint.x, this.y + checkPoint.y))
							rightFront = counter;
						if (leftBack == 6 && building.getRect(gameScreen._backgroundClip).contains(this.x - checkPoint.x, this.y - checkPoint.y))
							leftBack = counter;						
					}
				}
				var vel = this.velocity;
				velocity += .2*(midFront-midBack);
				if (midFront < 6)
					deltaRot += (rightFront-leftFront) * (velocity/MAX_VEL);
				if (midBack < 6)
					deltaRot += (leftBack-rightBack) * (velocity/MAX_VEL);
			}
			
			rotation += MathHelper.clamp(deltaRot, -7, 7);
			velocity = MathHelper.clamp(velocity, -MAX_VEL/2, MAX_VEL);
			
			var radians:Number = rotation * Math.PI/180;
			this.vVel.x = Math.cos(radians) * velocity;
			this.vVel.y = Math.sin(radians) * velocity;
			this.vPos.x = this.getX();
			this.vPos.y = this.getY();
			this._body.SetLinearVelocity(new b2Vec2(vVel.x, vVel.y));
			//trace("Linear Velocity: " + this._body.GetLinearVelocity().x + "\t" + this._body.GetLinearVelocity().y);
			//this.x += vVel.x;
			//this.y += vVel.y
		}
		
		//checks if there are buildings between player and cop
		public function canSeePlayer(buildings:Vector.<Building>):Boolean{
			var multX:int = (player.position.x - this.x)/10;
			var multY:int = (player.position.y - this.y)/10;
			for (var j:int = 0; j < 10; j++){
				for (var i:int = 0; i < buildings.length; i++){
					//trace(j + " " + buildings[i].x + "  " + buildings[i].y + "\tcop: " + (x+multX*j) + "  " + (y+multY*j) + "\tplayer: " + player.position);
					if (i != 32){
						if (buildings[i].getRect(gameScreen._backgroundClip).contains(this.x + (multX * j), this.y + (multY * j)) && i != 32){
							/*if (this.los)
								trace("Lost the player...");*/
							this.los = false;
							return false;
						}
					}
				}
			}
			/*if (!this.los)
				trace("PLAYER!!!!!!;");*/
			this.los = true;
			return true;
		}
		
		private function rotatePoint(a:Number, b:Number, c:Number):Point{
			utilPoint.x = Math.cos(c) * a + -Math.sin(c) * b;
			utilPoint.y = Math.sin(c) * a + Math.cos(c) * b;
			return utilPoint;
			
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
			//trace("Pos: " + pos+ "\nVel: " + vel + "\nRot: " + rotation + "\n\n");
			
			var timeToClose:Number = 1;
			if (vel.x != 0 || vel.y != 0)
				timeToClose = Math.sqrt(Math.pow(pos.x, 2) + Math.pow(pos.y, 2)) / Math.sqrt(Math.pow(vel.x, 2) + Math.pow(vel.y, 2))/2;
			
			//trace("ttc: " + timeToClose);
			return MathHelper.addPoints(player.position, MathHelper.scalePoint(player.velocity, timeToClose));
		}
		
		//calculates the angle to the player
		public function angleToPoint(point:Point):Number{
			var angle:Number = Math.atan2(point.y - this.y, point.x - this.x);
			angle *= (180 / Math.PI);
			if (angle > 360)
				angle = 360;
			if (angle < 0)
				angle += 360;
			//trace("Angle: " + angle + "\tRotation: " + rotation + "\tDiff: " + (angle-rotation))
			return angle-rotation;
		}

		public function getX():Number { return _body.GetPosition().x * GameScreen.SCALE; }
		public function getY():Number { return _body.GetPosition().y * GameScreen.SCALE; }
		
		//rotation override
		public override function set rotation(val:Number):void {
			_body.SetAngle(val * MathHelper.DEGTORAD);
			super.rotation = val;
		}
	}
	
}
