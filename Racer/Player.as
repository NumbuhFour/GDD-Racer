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
	import Box2D.Dynamics.Joints.b2Joint;
	import Box2D.Dynamics.Contacts.b2Contact;
	import Box2D.Collision.b2ManifoldPoint;
	import Box2D.Collision.b2Manifold;
	import Box2D.Dynamics.b2ContactImpulse;
	
	public class Player extends PhysicalClip {
		
		private var _posX:Number = 0;
		private var _posY:Number = 0;
		private var _rot:Number = 0;	
		
		private var _wheels:Vector.<Wheel>;
		private var _flJoint:b2RevoluteJoint;
		private var _frJoint:b2RevoluteJoint;
		
		private var _wheelDamage:Vector.<Number>;
		private var _totalDamage:Number = 0;
		
		var maxForwardLeftSpeed:Number = 150;
		var maxForwardRightSpeed:Number = 150;
		var maxBackwardLeftSpeed:Number = -40;
		var maxBackwardRightSpeed:Number = -40;
		var frontLeftTireMaxDrive:Number = 40;
		var frontRightTireMaxDrive:Number = 40;
		var backLeftTireMaxDrive:Number = 10;
		var backRightTireMaxDrive:Number = 10;
		var frontLateral:Number = 8.5;
		var backLateral:Number = 7.5;
		
		//var testSprite:Sprite;
		
		public function Player() {
			//testSprite = new Sprite();
			//this.addChild(testSprite);
		}
		
		protected override function setupPhys() {
			_bodyDef = new b2BodyDef();
			_bodyDef.type = b2Body.b2_dynamicBody;
			
			_fixtureDef = new b2FixtureDef();
			
			_body = _world.CreateBody(_bodyDef);			
			
			_shape = new b2PolygonShape();
			(_shape as b2PolygonShape).SetAsBox(this.width / 2 / GameScreen.SCALE, this.height / 2 / GameScreen.SCALE);
			_fixtureDef.shape = _shape;
			_fixtureDef.density = 0.3;
			_fixture = _body.CreateFixture(_fixtureDef);
			
			
			_wheels = new Vector.<Wheel>();
			_wheelDamage = new Vector.<Number>();
			var flWheel:Wheel = new Wheel(_world,this.width/6, this.height/6);
			var frWheel:Wheel = new Wheel(_world,this.width/6, this.height/6);
			var blWheel:Wheel = new Wheel(_world,this.width/6, this.height/6);
			var brWheel:Wheel = new Wheel(_world,this.width/6, this.height/6);
			
			_wheels[0] = flWheel;
			_wheels[1] = frWheel;
			_wheels[2] = blWheel;
			_wheels[3] = brWheel;
			for(var i:int = 0; i < 4; i++)
				_wheelDamage[i] = 0;
			this.updateWheelProperties();
			
			flWheel.setPosition(this.x+this.width/2, this.y-this.height/2);
			frWheel.setPosition(this.x+this.width/2, this.y+this.height/2);
			blWheel.setPosition(this.x-this.width/2, this.y-this.height/2);
			brWheel.setPosition(this.x-this.width/2, this.y+this.height/2);
			
			var jointDef:b2RevoluteJointDef = new b2RevoluteJointDef();
			jointDef.bodyA = _body;
			jointDef.enableLimit = true;
			jointDef.lowerAngle = 0;//with both these at zero...
			jointDef.upperAngle = 0;//...the joint will not move
			jointDef.localAnchorB.SetZero();//joint anchor in tire is always center
			
			jointDef.localAnchorA.Set(this.width/2/GameScreen.SCALE, -this.height/2/GameScreen.SCALE); //Front left
			jointDef.bodyB = _wheels[0].body;
			_flJoint = _world.CreateJoint(jointDef) as b2RevoluteJoint;
			
			jointDef.localAnchorA.Set(this.width/2/GameScreen.SCALE, this.height/2/GameScreen.SCALE); //Front right
			jointDef.bodyB = _wheels[1].body;
			_frJoint = _world.CreateJoint(jointDef) as b2RevoluteJoint;
			
			jointDef.localAnchorA.Set(-this.width/2/GameScreen.SCALE, -this.height/2/GameScreen.SCALE); //Back left
			jointDef.bodyB = _wheels[2].body;
			_world.CreateJoint(jointDef);
			jointDef.localAnchorA.Set(-this.width/2/GameScreen.SCALE, this.height/2/GameScreen.SCALE); //Back right
			jointDef.bodyB = _wheels[3].body;
			_world.CreateJoint(jointDef);
			
			/*var fWheel:Wheel = new Wheel(_world,this.width/6, this.height/6);
			var bWheel:Wheel = new Wheel(_world,this.width/6, this.height/6);
			
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
			_joints[1] = bJoint;*/
		}
		
		private function updateWheelProperties():void{
			_wheels[0].setCharacteristics(maxForwardLeftSpeed, maxBackwardLeftSpeed, frontLeftTireMaxDrive, frontLateral,_wheelDamage[0]);
			_wheels[1].setCharacteristics(maxForwardRightSpeed, maxBackwardRightSpeed, frontRightTireMaxDrive, frontLateral,_wheelDamage[1]);
			_wheels[2].setCharacteristics(maxForwardLeftSpeed, maxBackwardLeftSpeed, backLeftTireMaxDrive, backLateral,_wheelDamage[2]);
			_wheels[3].setCharacteristics(maxForwardRightSpeed, maxBackwardRightSpeed, backRightTireMaxDrive, backLateral,_wheelDamage[3]);
		}
		
		public function update():void {
			
			this._posX = _body.GetPosition().x * GameScreen.SCALE;
			this._posY = _body.GetPosition().y * GameScreen.SCALE;
			this._rot  = _body.GetAngle()*(180/Math.PI);
			
			var space:Boolean = Keyboarder.keyIsDown(Keyboard.SPACE);
			
			for(var i:int = 0; i < 4; i++){
				(_wheels[i] as Wheel).applyFriction(!space ? 1:i > 2 ? 0.21:0.02);
				if(i < 2){
					(_wheels[i] as Wheel).frontDrive();
					//(_wheels[i] as Wheel).turnDrive();
				}
			}
			turnDrive();
			
			if(Keyboarder.keyIsDown(Keyboard.SPACE)){ //Emergency Break
				(_wheels[2] as Wheel).eBreak();
				(_wheels[3] as Wheel).eBreak();
			}
			
			//applyFriction();
			//turnDrive();
			//frontDrive();
			//trace(this);
		}
		
		private function turnDrive(){
			var left:Boolean = Keyboarder.keyIsDown(Keyboard.A);
			var right:Boolean = Keyboarder.keyIsDown(Keyboard.D);

			var max:Number = (this.maxForwardLeftSpeed + this.maxForwardRightSpeed)/2-12;
			max *= max;
			var velRatio:Number = 1 / (this._body.GetLinearVelocity().LengthSquared() / max);
			//trace("Velocity: " + velRatio);
			
			var lockAngle = (55-this._body.GetLinearVelocity().Length()*1.8) * MathHelper.DEGTORAD;
			var turnSpeedPerSec:Number = 90 * MathHelper.DEGTORAD;
			var turnPerTimeStep:Number = turnSpeedPerSec / 24; //Framerate
			var desiredAngle:Number = 0;
			
			if(left) desiredAngle = -lockAngle;
			if(right) desiredAngle = lockAngle;
			
			var angleNow:Number = this._flJoint.GetJointAngle();
			var angleToTurn:Number = desiredAngle - angleNow;
			angleToTurn = MathHelper.clamp(angleToTurn,-turnPerTimeStep, turnPerTimeStep);
			var newAngle = angleNow + angleToTurn;
			_flJoint.SetLimits(newAngle,newAngle);
			_frJoint.SetLimits(newAngle,newAngle);
			
			//cheatAlign();
			
			//Aligning wheel sprites
			var wRot:Number = newAngle * MathHelper.RADTODEG;
			this.leftWheelClip.rotation = wRot;
			this.rightWheelClip.rotation = wRot;
		}
		
		private function cheatAlign(){
			var tol:Number = 10;
			var rot = _body.GetAngle()*MathHelper.RADTODEG;
			
			if(Math.abs(rot%90) > tol && Math.abs(rot%90) < 90-tol){
				var dir:Number = 1;
				if(this.rotation%90 < tol) dir = -1;
				_body.SetAngle(_body.GetAngle() + dir*2*MathHelper.DEGTORAD*(this.getForwardVelocity().Length()/10));
			}
		}
		
		public function takeDamage(hit:b2Contact, impulse:b2ContactImpulse){
			var other:b2Body;

			if(hit.GetFixtureA().GetBody() == this._body) other = hit.GetFixtureB().GetBody();
			if(hit.GetFixtureB().GetBody() == this._body) other = hit.GetFixtureA().GetBody();
			
			var pos:b2Vec2 = other.GetPosition();/*new b2Vec2();
			var manifold:b2Manifold = hit.GetManifold();
			for(var i:int = 0; i < manifold.m_pointCount; i++){
				var point:b2ManifoldPoint = hit.GetManifold().m_points[i];
				pos.Add(point.m_localPoint);
			}
			pos.Multiply(1/manifold.m_pointCount);*/
			
			var relRot:Number = Math.atan2((pos.y - _body.GetPosition().y) , (pos.x - _body.GetPosition().x)) * MathHelper.RADTODEG;
			relRot -= this.rot%360;
			//relRot %= 360;
			
			var collisionImpulse:Number = 0;
			var impulseAmt:Number = 0;
			var hitAverage:b2Vec2 = new b2Vec2();
			for each(var p:b2ManifoldPoint in hit.GetManifold().m_points){
				var hitPoint:b2Vec2 =  p.m_localPoint;
				if(Math.abs(hitPoint.x) > 3 || Math.abs(hitPoint.y) > 3) continue;
				impulseAmt++;
				collisionImpulse += p.m_normalImpulse;
				//trace("HIT " + relRot + " [" + hitPoint.x + ", " + hitPoint.y + "] " + p.m_normalImpulse + " " + p.m_tangentImpulse);
				
				hitAverage.Add(hitPoint);
			}
			collisionImpulse /= impulseAmt;
			if(collisionImpulse < 1.2) collisionImpulse = 0;
			if(collisionImpulse > 0) {
				trace("IMPULSE: " + collisionImpulse);			
				hitAverage.Multiply(1/impulseAmt);
				if(hitAverage.x > 0){ //Front
					if(hitAverage.y < 0){ //Left
						this._wheelDamage[0] += collisionImpulse;
					}else { //Right
						this._wheelDamage[1] += collisionImpulse;
					}
				}else{ //Back
					if(hitAverage.y < 0){ //Left
						this._wheelDamage[2] += collisionImpulse;
					}else { //Right
						this._wheelDamage[3] += collisionImpulse;
					}
				}
				this._totalDamage += collisionImpulse;
				for(var i:int = 0; i < 4; i++) 
					if(_wheelDamage[i] == NaN) _wheelDamage[i] = 0; //Ignore the warning, its happened and caused crashes.
				trace("DAMS : fl" + _wheelDamage[0] + " fr" + _wheelDamage[1] + " bl" + _wheelDamage[2] + " br" + _wheelDamage[3] + " tot" + this._totalDamage);
			}
			
			//testSprite.graphics.beginFill(Math.random()*0xffffff);
			//testSprite.graphics.drawCircle(hitAverage.x*GameScreen.SCALE, hitAverage.y*GameScreen.SCALE, 4);
			//testSprite.graphics.drawCircle(0,0, 3);
			
			this.updateWheelProperties();
			
			if(collisionImpulse > 2){ //Damage sprites
				if(relRot < 45 && relRot > -45) {
					this.front.gotoAndStop(2);
				}
				if(relRot < 135 && relRot > 45) {
					this.right.gotoAndStop(2);
				}
				if(relRot < -45 && relRot > -135) {
					this.left.gotoAndStop(2);
				}
				if((relRot > 135 && relRot < 225) || (relRot < - 135 && relRot > -225)) {
					this.back.gotoAndStop(2);
				}
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
