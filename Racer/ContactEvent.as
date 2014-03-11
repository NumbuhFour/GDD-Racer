package Racer {

	import flash.events.Event;
	import Box2D.Dynamics.Contacts.b2Contact;
	
	public class ContactEvent extends Event{

		public var point:b2Contact;
		
		public function ContactEvent(type:String, point:b2Contact) {
			super(type);
			this.point = point;
		}

	}
	
}
