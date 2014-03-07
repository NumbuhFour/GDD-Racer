﻿package  Racer{
	
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
		
		private var _posX:Number = 0;
		private var _posY:Number = 0;
		private var _rot:Number = 0;
		
		var leftPressed:Boolean = false;
		var rightPressed:Boolean = false;
		var upPressed:Boolean = false;
		var downPressed:Boolean = false;		
		
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
			_bodyDef.linearDamping = 2;
			_bodyDef.angularDamping = 2;
			
			_fixtureDef = new b2FixtureDef();
			
			_body = _world.CreateBody(_bodyDef);			
			
			_shape = new b2PolygonShape();
			(_shape as b2PolygonShape).SetAsBox(this.width / 2 / GameScreen.SCALE, this.height / 2 / GameScreen.SCALE);
			_fixtureDef.shape = _shape;
			_fixtureDef.density = 0.3;
			_fixture = _body.CreateFixture(_fixtureDef);
		}
		
		public function update():void {
			
			//Set velX and velY based on forward acceleration
			var rotRad:Number = rotation * (Math.PI/180);
			var vel:Point = new Point(Math.cos(rotRad)*accel,Math.sin(rotRad)*accel);
			
			var space:Boolean = Keyboarder.keyIsDown(Keyboard.SPACE);
			//if(space){
				velocityX = MathHelper.clamp(velocityX + vel.x, -maxVel, maxVel);
				velocityY = MathHelper.clamp(velocityY + vel.y, -maxVel, maxVel);
			//}else{
				//velocityX = MathHelper.clamp(vel.x, -maxVel, maxVel);
				//velocityY = MathHelper.clamp(vel.y, -maxVel, maxVel)
			//}
			/*
			this._posX += this.velocityX;
			this._posY += this.velocityY;
			this._rot += this.velocityR;
			*/
			this._posX = _body.GetPosition().x * GameScreen.SCALE;
			this._posY = _body.GetPosition().y * GameScreen.SCALE;
			this._rot  = _body.GetAngle()*(180/Math.PI);

			/* Moving camera around player effect: Ready to implement, but need background things to see if it works.
			parent.x = -x + stage.stageWidth/2;
			parent.y = -y + stage.stageHeight/2;
			parent.rotation = -rotation;
			*/
			
			velocityX *= 0.8;
			velocityY *= 0.8;
			
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
			
			if(left)
			{
				_body.SetAngularVelocity(10);
				velocityR = MathHelper.clamp(velocityR - rotSpeed, -maxVelR, maxVelR);
			}
			if(right)
			{
				velocityR = MathHelper.clamp(velocityR + rotSpeed, -maxVelR, maxVelR);
			}
			
			if(!space)
			{	
				
				if(up)
				{
					_body.ApplyForce(new b2Vec2(1,0), _body.GetWorldCenter());
					accel = MathHelper.clamp(accel + accelSpeed, -maxAccel, maxAccel);
				}
				if(down)
				{
					_body.ApplyForce(new b2Vec2(-1,0), _body.GetWorldCenter());
					accel = MathHelper.clamp(accel - accelSpeed, -maxAccel, maxAccel);
				}
				
				//if(up == down)
				{
					accel *= 0.95;
				}
			
				//if(left == right)
				{
					velocityR *= 0.86;
				}
			}else{ //Handbreak
				velocityR *= 0.92;
				accel *= 0.96;
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
		
		public function get position():Point { return new Point(_posX,_posY); }		
		public function set position(val:Point):void { this._posX = val.x; this._posY = val.y; }
		public function get rot():Number { return _rot; }
		
		public override function toString():String 
		{
			return "[Player] physpos=" + _body.GetPosition().x +"," + _body.GetPosition().y + " physvel=" + _body.GetLinearVelocity().x + "," + _body.GetLinearVelocity().y + " physr=" + _body.GetAngle();
		}
	}
	
	
}
