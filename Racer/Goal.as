package Racer {
	
	import flash.display.MovieClip;
	import Box2D.Dynamics.b2World;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2Body;
	import Box2D.Collision.Shapes.b2Shape;
	import Box2D.Dynamics.b2FixtureDef;
	import Box2D.Dynamics.b2Fixture;
	import Box2D.Collision.Shapes.b2PolygonShape;
	import Box2D.Common.Math.b2Vec2;
	
	
	public class Goal extends PhysicalClip {
		
		
		public function Goal() {
			// constructor code
		}
		
		protected override function setupPhys(){
			_bodyDef = new b2BodyDef();
			_fixtureDef = new b2FixtureDef();
			_fixtureDef.isSensor = true;
			
			_body = _world.CreateBody(_bodyDef);
			
			_shape = new b2PolygonShape();
			(_shape as b2PolygonShape).SetAsBox(this.width / 2 / GameScreen.SCALE, this.height / 2 / GameScreen.SCALE);
			_fixtureDef.shape = _shape;
			_fixture = _body.CreateFixture(_fixtureDef);
			
			_body.SetPosition(new b2Vec2(x/GameScreen.SCALE,y/GameScreen.SCALE));
		}
	}
	
}
