package  Racer{
	
	import flash.display.MovieClip;
	import flash.ui.Keyboard;
	import com.as3toolkit.ui.Keyboarder;
	import flash.geom.Point;
	import Box2D.Dynamics.b2World;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2Body;
	import Box2D.Collision.Shapes.b2Shape;
	import Box2D.Dynamics.b2FixtureDef;
	import Box2D.Dynamics.b2Fixture;
	import Box2D.Collision.Shapes.b2PolygonShape;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Common.Math.b2Math;
	import flash.utils.Dictionary;
	import Box2D.Dynamics.Joints.b2RevoluteJoint;
	import Box2D.Dynamics.Joints.b2RevoluteJointDef;
	import Box2D.Dynamics.Joints.b2PrismaticJointDef;
	import Box2D.Dynamics.b2DebugDraw;
	import flash.display.Sprite;
	
	public class Player extends MovieClip {
		
		private var maxVel:Number = 30;
		private var maxAccel:Number = 8;
		private var maxVelR:Number = 8.5;
		
		private var accelSpeed:Number = 0.9; //Speed acceleration increases
		private var rotSpeed:Number = 0.65; //Speed rotation velocity increases;
		
		private var _posX:Number = 0;
		private var _posY:Number = 0;
		private var _rot:Number = 0;	
		
		private var _world:b2World;
		
		private var _bodyDef:b2BodyDef;
		private var _body:b2Body;
		private var _shape:b2Shape;
		private var _fixtureDef:b2FixtureDef;
		private var _fixture:b2Fixture;
		
		private var _wheels:Dictionary;
		private var _joints:Dictionary;
		
		public function Player(world:b2World) {
			this._world = world;
			
			
			_bodyDef = new b2BodyDef();
			_bodyDef.type = b2Body.b2_dynamicBody;
			
			_fixtureDef = new b2FixtureDef();
			
			_body = _world.CreateBody(_bodyDef);			
			
			_shape = new b2PolygonShape();
			(_shape as b2PolygonShape).SetAsBox(this.width / 2 / GameScreen.SCALE, this.height / 2 / GameScreen.SCALE);
			_fixtureDef.shape = _shape;
			_fixtureDef.density = 0.3;
			_fixture = _body.CreateFixture(_fixtureDef);
			
			
			_wheels = new Dictionary();
			_joints = new Dictionary();
			var fWheel:Wheel = new Wheel(world,this.width/6, this.height/6);
			var bWheel:Wheel = new Wheel(world,this.width/6, this.height/6);
			
			fWheel.setPosition(this.x+this.width/2, this.y);
			bWheel.setPosition(this.x-this.width/2, this.y);
			
			_wheels[0] = fWheel;
			_wheels[1] = bWheel;
			
			//Joints
			var frontJointDef:b2RevoluteJointDef = new b2RevoluteJointDef();
			frontJointDef.Initialize(_body,fWheel.body, fWheel.body.GetWorldCenter());
			frontJointDef.enableMotor = true;
			frontJointDef.maxMotorTorque = 100;
			
			var backJointDef:b2RevoluteJointDef = new b2RevoluteJointDef();
			backJointDef.Initialize(_body,bWheel.body, bWheel.body.GetWorldCenter());
			backJointDef.enableMotor = true;
			backJointDef.maxMotorTorque = 100;
			
			var fJoint:b2RevoluteJoint = _world.CreateJoint(frontJointDef) as b2RevoluteJoint;
			var bJoint:b2RevoluteJoint = _world.CreateJoint(frontJointDef) as b2RevoluteJoint;
			
			_joints[0] = fJoint;
			_joints[1] = bJoint;
		}
		
		public function update():void {
			
			this._posX = _body.GetPosition().x * GameScreen.SCALE;
			this._posY = _body.GetPosition().y * GameScreen.SCALE;
			this._rot  = _body.GetAngle()*(180/Math.PI);
			
			applyFriction();
			turnDrive();
			frontDrive();
			//trace(this);
		}
		
		private function frontDrive(){
			var up:Boolean = Keyboarder.keyIsDown(Keyboard.W);
			var down:Boolean = Keyboarder.keyIsDown(Keyboard.S);
			
			if(up || down) {
				var desiredSpeed:Number = 0;
				if(up) desiredSpeed = 16;
				else if(down) desiredSpeed = -12;
				
				var currentForwardNormal:b2Vec2 = _body.GetWorldVector(new b2Vec2(1,0));
				var currentSpeed:Number = b2Math.Dot(getForwardVelocity(), currentForwardNormal);
				
				var force:Number = 0;
				
				if(desiredSpeed > currentSpeed)
					force = 100;
				else if (desiredSpeed < currentSpeed)
					force = -100;
				else
					return;
				currentForwardNormal.Multiply(force);
				_body.ApplyForce(currentForwardNormal, _body.GetWorldCenter());
			}
		}
		
		private function turnDrive(){
			var left:Boolean = Keyboarder.keyIsDown(Keyboard.A);
			var right:Boolean = Keyboarder.keyIsDown(Keyboard.D);
			
			if(left || right){
				var desiredTorque:Number = 0;
				if(left) desiredTorque = -11;
				else if(right) desiredTorque = 11;
				
				_body.ApplyTorque(desiredTorque);
			}
		}
		
		public function getLateralVelocity():b2Vec2 {
			var currentRightNormal:b2Vec2 = _body.GetWorldVector(new b2Vec2(0,1));
			currentRightNormal.Multiply(b2Math.Dot(currentRightNormal,_body.GetLinearVelocity()))
			return currentRightNormal;
		}
		
		public function getForwardVelocity():b2Vec2 {
			var currentFrontNormal:b2Vec2 = _body.GetWorldVector(new b2Vec2(1,0));
			currentFrontNormal.Multiply(b2Math.Dot(currentFrontNormal,_body.GetLinearVelocity()))
			return currentFrontNormal;
		}
		
		private function applyFriction():void {
			var impulse:b2Vec2 = getLateralVelocity().GetNegative();
			impulse.Multiply(_body.GetMass());
			_body.ApplyImpulse(impulse, _body.GetWorldCenter());
			_body.ApplyAngularImpulse(0.1 * _body.GetInertia() * - _body.GetAngularVelocity());
			
			//Forward drag
			var currentForwardNormal:b2Vec2 = getForwardVelocity();
			var currentForwardSpeed:Number = currentForwardNormal.Normalize();
			var dragForceMagnitude = -1 * currentForwardSpeed;
			currentForwardNormal.Multiply(dragForceMagnitude);
			_body.ApplyForce(currentForwardNormal, _body.GetWorldCenter());
		}
	
		public function get velocity():Point { return new Point(_body.GetLinearVelocity().x, _body.GetLinearVelocity().y); }
		public function set velocity(val:Point):void { _body.SetLinearVelocity(new b2Vec2(val.x,val.y)); }
		
		public function get position():Point { return new Point(_posX,_posY); }		
		public function set position(val:Point):void { this._posX = val.x; this._posY = val.y; }
		public function get rot():Number { return _rot; }
		
		public override function toString():String 
		{
			return "[Player]: \nphyspos=[" + _body.GetPosition().x +", " + _body.GetPosition().y + "] \nderp=[" + position.x + ", " + position.y + "] \nphysvel=[" + _body.GetLinearVelocity().x + ", " + _body.GetLinearVelocity().y + "] \nphysrot=" + _body.GetAngle() + ", " + _body.GetAngularVelocity();
		}
	}
	
	
}
