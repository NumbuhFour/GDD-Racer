package Racer {
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
	
	//Much if not all of this was done with the help of https://www.iforce2d.net/b2dtut/top-down-car
	public class Wheel {
		
		private var _maxForward:Number = 20;
		private var _maxBackward:Number = -10;
		private var _maxDrive:Number = 100;
		private var _damage:Number = 0;
		private var TURN:Number = 20;
		
		private var _maxLateral:Number = 8.5;
		
		private var _world:b2World;
		
		private var _bodyDef:b2BodyDef;
		private var _body:b2Body;
		private var _shape:b2Shape;
		private var _fixtureDef:b2FixtureDef;
		private var _fixture:b2Fixture;
		
		public function Wheel(world:b2World, wid:Number, hei:Number) {
			this._world = world;
			
			_bodyDef = new b2BodyDef();
			_bodyDef.type = b2Body.b2_dynamicBody;
			
			_fixtureDef = new b2FixtureDef();
			_fixtureDef.isSensor = true;
			
			_body = _world.CreateBody(_bodyDef);
			
			_shape = new b2PolygonShape();
			(_shape as b2PolygonShape).SetAsBox(wid / GameScreen.SCALE, hei / GameScreen.SCALE);
			_fixtureDef.shape = _shape;
			_fixtureDef.density = 0.3;
			_fixture = _body.CreateFixture(_fixtureDef);
		}
	
		
		public function setCharacteristics(maxForward:Number, maxBackward:Number, maxDrive:Number, maxLateral:Number, damage:Number){
			this._maxForward = maxForward;
			this._maxBackward = maxBackward;
			this._maxDrive = maxDrive;
			this._maxLateral = maxLateral;
			this._damage = damage;
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
		
		
		public function applyFriction(lateralMult:Number = 0.3):void {
			var impulse:b2Vec2 = getLateralVelocity().GetNegative();

			//Skidding
			if ( impulse.Length() > this._maxLateral )
				impulse.Multiply(this._maxLateral / impulse.Length());
			
			impulse.Multiply(_body.GetMass());
			var mult:b2Vec2 = impulse.Copy();
			mult.Multiply(lateralMult);
			_body.ApplyImpulse(mult, _body.GetWorldCenter());
			_body.ApplyAngularImpulse(0.3 * _body.GetInertia() * - _body.GetAngularVelocity());
			
			//Forward drag
			var currentForwardNormal:b2Vec2 = getForwardVelocity();
			var currentForwardSpeed:Number = currentForwardNormal.Normalize();
			var dragForceMagnitude = (-1 - _damage/35) * currentForwardSpeed;
			currentForwardNormal.Multiply(dragForceMagnitude);
			_body.ApplyForce(currentForwardNormal, _body.GetWorldCenter());
		}
		
		public function eBreak():void {
			//Forward drag
			var currentForwardNormal:b2Vec2 = getForwardVelocity();
			var currentForwardSpeed:Number = currentForwardNormal.Normalize();
			var dragForceMagnitude = -2.1 * currentForwardSpeed;
			currentForwardNormal.Multiply(dragForceMagnitude);
			_body.ApplyForce(currentForwardNormal, _body.GetWorldCenter());
		}
		
		public function frontDrive(){
			var up:Boolean = Keyboarder.keyIsDown(Keyboard.W);
			var down:Boolean = Keyboarder.keyIsDown(Keyboard.S);
			
			if(up || down) {
				var desiredSpeed:Number = 0;
				if(up) desiredSpeed = this._maxForward - _damage/70;
				else if(down) desiredSpeed = this._maxBackward - _damage/70;
				
				var currentForwardNormal:b2Vec2 = _body.GetWorldVector(new b2Vec2(1,0));
				var currentSpeed:Number = b2Math.Dot(getForwardVelocity(), currentForwardNormal);
				
				var force:Number = 0;
				
				if(desiredSpeed > currentSpeed)
					force = this._maxDrive;
				else if (desiredSpeed < currentSpeed)
					force = -this._maxDrive;
				else
					return;
				currentForwardNormal.Multiply(force);
				_body.ApplyForce(currentForwardNormal, _body.GetWorldCenter());
			}
		}
		
		/*public function turnDrive(){
			var left:Boolean = Keyboarder.keyIsDown(Keyboard.A);
			var right:Boolean = Keyboarder.keyIsDown(Keyboard.D);
			
			if(left || right){
				var desiredTorque:Number = 0;
				if(left) desiredTorque = -TURN;
				else if(right) desiredTorque = TURN;
				
				_body.ApplyTorque(desiredTorque);
			}
		}*/
		
		public function setPosition(px:Number, py:Number):void {
			_body.SetPosition(new b2Vec2(px/GameScreen.SCALE,py/GameScreen.SCALE));
		}
		
		public function get body():b2Body { return _body; }
	}
	
}
