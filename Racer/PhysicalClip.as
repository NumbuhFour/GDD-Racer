package Racer {

	import flash.display.MovieClip;
	import Box2D.Dynamics.*;
	import Box2D.Collision.Shapes.b2Shape;
	
	public class PhysicalClip extends MovieClip {

		
		protected var _world:b2World = null;
		
		protected var _bodyDef:b2BodyDef;
		protected var _body:b2Body;
		protected var _shape:b2Shape;
		protected var _fixtureDef:b2FixtureDef;
		protected var _fixture:b2Fixture;
		
		public function PhysicalClip() {
			// constructor code
		}
		
		public function set world(w:b2World){
			var doSetup:Boolean = (w != _world);
			this._world = w;
			setupPhys();
			_body.SetUserData(this);
		}
		
		protected virtual function setupPhys(){}
		
		public function get body():b2Body { return _body; }

	}
	
}
