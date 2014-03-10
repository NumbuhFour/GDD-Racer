package Racer {
	
	import Box2D.Dynamics.b2World;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2Body;
	import Box2D.Collision.Shapes.b2Shape;
	import Box2D.Dynamics.b2FixtureDef;
	import Box2D.Dynamics.b2Fixture;
	import Box2D.Collision.Shapes.b2PolygonShape;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Common.Math.b2Math;
	
	public class Wheel {
		
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
			
			_body = _world.CreateBody(_bodyDef);
			
			_shape = new b2PolygonShape();
			(_shape as b2PolygonShape).SetAsBox(wid / GameScreen.SCALE, hei / GameScreen.SCALE);
			_fixtureDef.shape = _shape;
			_fixtureDef.density = 0.3;
			_fixture = _body.CreateFixture(_fixtureDef);
		}
	
		
		public function setPosition(px:Number, py:Number):void {
			_body.SetPosition(new b2Vec2(px/GameScreen.SCALE,py/GameScreen.SCALE));
		}
		
		public function get body():b2Body { return _body; }
	}
	
}
