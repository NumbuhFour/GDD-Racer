package  Racer {

	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import Box2D.Dynamics.b2ContactListener;
	import Box2D.Collision.b2ContactPoint;
	import Box2D.Dynamics.Contacts.b2ContactResult;
	import flash.display.Sprite;
	import Box2D.Collision.b2Manifold;
	import Box2D.Dynamics.b2ContactImpulse;
	import Box2D.Dynamics.Contacts.b2Contact;
	
	public class ContactListener extends b2ContactListener {
		public static const CONTACT_MADE:String = "b2ContactAdd";
		//public static const CONTACT_PERSIST:String = "b2ContactPersist";
		public static const CONTACT_REMOVED:String = "b2ContactRemoved";
		public static const CONTACT_PRESOLVE:String = "b2ContactPreSolve";
		public static const CONTACT_POSTSOLVE:String = "b2ContactPostSolve";
		
		private var _clip:Sprite;
		
		public function ContactListener(clip:Sprite) {
			this._clip = clip;
		}
		
		public override function BeginContact(point:b2Contact):void {
			this._clip.dispatchEvent(new ContactEvent(CONTACT_MADE,point));
        }
 
        /// Called when a contact point is removed. This includes the last
        /// computed geometry and forces.
        public override function EndContact(point:b2Contact):void {
			this._clip.dispatchEvent(new ContactEvent(CONTACT_REMOVED,point));
        }
 
        public override function PreSolve(contact:b2Contact, oldManifold:b2Manifold):void {
			this._clip.dispatchEvent(new ContactEvent(CONTACT_PRESOLVE,contact,oldManifold));
        }
 
        /// Called after a contact point is solved.
        public override function PostSolve(contact:b2Contact, impulse:b2ContactImpulse):void {
			this._clip.dispatchEvent(new ContactEvent(CONTACT_POSTSOLVE,contact, null, impulse));
			
        }

	}
	
}
