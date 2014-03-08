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
		
		public function Player(world:b2World) {
			this._world = world;
			//addEventListener(KeyboardEvent.KEY_UP, keyUpHandler);
			//addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
			_bodyDef = new b2BodyDef();
			_bodyDef.type = b2Body.b2_dynamicBody;
			//_bodyDef.linearDamping = 5;
			//_bodyDef.angularDamping = 10;
			
			_fixtureDef = new b2FixtureDef();
			
			_body = _world.CreateBody(_bodyDef);			
			
			_shape = new b2PolygonShape();
			(_shape as b2PolygonShape).SetAsBox(this.width / 2 / GameScreen.SCALE, this.height / 2 / GameScreen.SCALE);
			_fixtureDef.shape = _shape;
			_fixtureDef.density = 0.3;
			_fixture = _body.CreateFixture(_fixtureDef);
			
		}
		
		public function update():void {
			
			this._posX = _body.GetPosition().x * GameScreen.SCALE;
			this._posY = _body.GetPosition().y * GameScreen.SCALE;
			this._rot  = _body.GetAngle()*(180/Math.PI);
			
			takeInput();
			trace(this);
		}
		
		private function takeInput():void {
			var left:Boolean,right:Boolean,up:Boolean,down:Boolean,space:Boolean;
			left = Keyboarder.keyIsDown(Keyboard.A);
			right = Keyboarder.keyIsDown(Keyboard.D);
			up = Keyboarder.keyIsDown(Keyboard.W);
			down = Keyboarder.keyIsDown(Keyboard.S);
			space = Keyboarder.keyIsDown(Keyboard.SPACE);
			
			var temp:Number = 1;
			if(left)
			{
				//_body.SetAngularVelocity(10);
				//_body.ApplyTorque(1);
				_body.SetPosition(new b2Vec2(_body.GetPosition().x - temp,_body.GetPosition().y));
			}
			if(right)
			{
				//_body.ApplyTorque(-1);
				_body.SetPosition(new b2Vec2(_body.GetPosition().x + temp,_body.GetPosition().y));
			}
			
			if(!space)
			{	
				
				if(up)
				{
					//_body.ApplyImpulse(new b2Vec2(1,0), _body.GetWorldCenter());
					_body.SetPosition(new b2Vec2(_body.GetPosition().x,_body.GetPosition().y - temp));
				}
				if(down)
				{
					_body.SetPosition(new b2Vec2(_body.GetPosition().x,_body.GetPosition().y + temp));
					//_body.ApplyImpulse(new b2Vec2(-1,0), _body.GetWorldCenter());
				}
			}else{ //Handbreak
				
			}
			
		}
		
		public function getLateralVelocity():b2Vec2 {
			var currentRightNormal:b2Vec2 = _body.GetWorldVector(new b2Vec2(0,1));
			currentRightNormal.Multiply(b2Math.Dot(currentRightNormal,_body.GetLinearVelocity()))
			return currentRightNormal;
		}
		
		private function applyFriction():void {
			var impulse:b2Vec2 = getLateralVelocity().GetNegative();
			impulse.Multiply(_body.GetMass());
			_body.ApplyImpulse(impulse, _body.GetWorldCenter());
		}
	
		public function get velocity():Point { return new Point(_body.GetLinearVelocity().x, _body.GetLinearVelocity().y); }
		public function set velocity(val:Point):void { _body.SetLinearVelocity(new b2Vec2(val.x,val.y)); }
		
		public function get position():Point { return new Point(_posX,_posY); }		
		public function set position(val:Point):void { this._posX = val.x; this._posY = val.y; }
		public function get rot():Number { return _rot; }
		
		public override function toString():String 
		{
			return "[Player]: \nphyspos=[" + _body.GetPosition().x +", " + _body.GetPosition().y + "] \nphysvel=[" + _body.GetLinearVelocity().x + ", " + _body.GetLinearVelocity().y + "] \nphysrot=" + _body.GetAngle() + ", " + _body.GetAngularVelocity();
		}
	}
	
	
}
