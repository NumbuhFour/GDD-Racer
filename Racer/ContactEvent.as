package Racer {

	import flash.events.Event;
	import Box2D.Dynamics.Contacts.b2Contact;
	import Box2D.Collision.b2Manifold;
	import Box2D.Dynamics.b2ContactImpulse;
	
	public class ContactEvent extends Event{

		public var point:b2Contact;
		public var manifold:b2Manifold;
		public var impulse:b2ContactImpulse
		
		public function ContactEvent(type:String, point:b2Contact, manifold:b2Manifold=null, impulse:b2ContactImpulse=null) {
			super(type);
			this.point = point;
			this.manifold = manifold;
			this.impulse = impulse;
		}

	}
	
}
