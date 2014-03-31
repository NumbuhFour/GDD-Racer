package  Racer{
	
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.geom.Point;
	import Box2D.Collision.*;
	import Box2D.Dynamics.b2World;
	import flash.utils.Dictionary;
	import Box2D.Common.Math.b2Vec2;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.display.DisplayObject;
	import Box2D.Dynamics.b2DebugDraw;
	import com.as3toolkit.ui.Keyboarder;
	import flash.ui.Keyboard;
	import flash.display.Graphics;
	import Box2D.Dynamics.b2ContactListener;
	import Box2D.Dynamics.b2Body;
	
	public class GameScreen extends Sprite{
		public static const FRICTION:Number = 10;
		public static const SCALE:Number = 17;
		public static var DEBUG:Boolean = false;
		private var _wasQDown:Boolean = false;
		private var dbg:b2DebugDraw;
		private var centerSprite:Sprite;
		private static const XML_PATH:String = "data/gameData.xml";
		
		private static var CAMERA_MODE:int = 0; //Made static so its constant over resets
		private var _wasCDown:Boolean = false;
		
		var _carLayer:CarLayer;
		var _buildingLayer:BuildingLayer;
		var _player:Player;
		var _backgroundClip:MovieClip;
		
		var _buildings:Vector.<Building> = new Vector.<Building>;
		var _translationContainer:MovieClip;
		var _rotationContainer:MovieClip;
		
		private var _world:b2World;
		private var _contactListener:ContactListener;
		private var _stepTime:Number = 0.042;
		private var _stepTimer:Timer;
		
		private var _removalBodies:Vector.<b2Body> = new Vector.<b2Body>();
		
		public function GameScreen(backgroundClip:MovieClip) {
			this._backgroundClip = backgroundClip;
			
			_translationContainer = new MovieClip();
			_rotationContainer = new MovieClip();
			_rotationContainer.addChild(_translationContainer);
			super.addChild(_rotationContainer);
			addChild(_backgroundClip);
			
			centerSprite = new Sprite();
			centerSprite.graphics.beginFill(0xff0000);
			centerSprite.graphics.drawCircle(0,0,20);
			this._rotationContainer.addChild(centerSprite);
			centerSprite.visible = DEBUG;
		}
		
		public function Start()
		{
			addEventListener(Event.ADDED_TO_STAGE, loadXML);
		}
		
		private function loadXML(e:Event){
			removeEventListener(Event.ADDED_TO_STAGE, loadXML);
			GameDataStore.sharedInstance.loadXML(XML_PATH);
			GameDataStore.sharedInstance.addEventListener(GameDataStore.LOAD_COMPLETE, onXMLLoaded);
		}
		
		public function onXMLLoaded(e:Event):void{
			GameDataStore.sharedInstance.removeEventListener(GameDataStore.LOAD_COMPLETE, onXMLLoaded);
			init();
		}
		
		public function init(){
			_world = new b2World(new b2Vec2(),true);
			(_backgroundClip as Level).gameScreen = this;
			
			_contactListener = new ContactListener(this);
			_world.SetContactListener(_contactListener);
			
			this.addEventListener(ContactListener.CONTACT_MADE, onContactMade);
			this.addEventListener(ContactListener.CONTACT_REMOVED, onContactLost);
			this.addEventListener(ContactListener.CONTACT_POSTSOLVE, onContactPostSolve);
			
			_carLayer = new CarLayer(this);
			addChild(_carLayer);

			_player = new Player();
			addChild(_player);
			_player.world = _world;
			var dict:Dictionary = new Dictionary();
			var j:int = 0;
			for (var i:int = 0; i < background.numChildren; i++){
				if(background.getChildAt(i) is Node){
					//trace(background.getChildAt(i).name);
					dict[background.getChildAt(i).name] = background.getChildAt(i);
				}
				else if (background.getChildAt(i) is Building){
					_buildings.push(background.getChildAt(i));
				}
			}
			
			_carLayer.init(dict); 
			_carLayer.initCops(1);
			
			_stepTimer = new Timer(_stepTime);
			_stepTimer.addEventListener(TimerEvent.TIMER, update);
			_stepTimer.start();
			
			//Debugging
			dbg = new b2DebugDraw();
			dbg.SetSprite(new Sprite());
			dbg.SetDrawScale(GameScreen.SCALE);
			dbg.SetFillAlpha(0.3);
			dbg.SetLineThickness(1.0);
			dbg.SetFlags(b2DebugDraw.e_shapeBit | b2DebugDraw.e_centerOfMassBit | b2DebugDraw.e_jointBit | b2DebugDraw.e_aabbBit);
			_world.SetDebugDraw(dbg);
			addChild(dbg.GetSprite());
			
			this.addEventListener(Event.REMOVED_FROM_STAGE, cleanup);
		}
		
		private function update(event:Event){
			//Debug controls
			if(Keyboarder.keyIsDown(Keyboard.Q) && !_wasQDown) {
				DEBUG = !DEBUG;
				centerSprite.visible = DEBUG;
				var g:Graphics = this._translationContainer.graphics;
				if(DEBUG){
					var sqr:Number = 200;
					var size:Number =  50;
					g.lineStyle(1, 0);
					for(var ix:Number = -size; ix < size; ix++){
						g.moveTo(ix*sqr,-size*sqr);
						g.lineTo(ix*sqr,size*sqr);
					}
					
					for(var iy:Number = -size; iy < size; iy++){
						g.moveTo(-size*sqr,iy*sqr);
						g.lineTo(size*sqr,iy*sqr);
					}		
				}else{
					g.clear();
				}
			}
			_wasQDown = Keyboarder.keyIsDown(Keyboard.Q);
			
			if(Keyboarder.keyIsDown(Keyboard.C) && !_wasCDown){
				CAMERA_MODE = (CAMERA_MODE+1)%2;
			}
			_wasCDown = Keyboarder.keyIsDown(Keyboard.C);
			
			for each(var b:b2Body in this._removalBodies){
				_world.DestroyBody(b);
			}
			if(this._removalBodies.length > 0) trace("Removed " + _removalBodies.length + " bodies.");
			_removalBodies = new Vector.<b2Body>();
			
			_world.Step(_stepTime,10,10);
			_world.ClearForces();
			if(DEBUG) _world.DrawDebugData();
			else dbg.GetSprite().graphics.clear();
				
			_player.update();
			_carLayer.update();
			moveCamera();
		}
		
		
		private var lastX:Number = 0;
		private var lastY:Number = 0;
		private var lastR:Number = 0;
		
		private function moveCamera(){
			
			var camX:Number = -_player.position.x;
			var camY:Number = -_player.position.y;
			var camR:Number = -_player.rot;
			var difX:Number = (camX - lastX)*2;
			var difY:Number = (camY - lastY)*2;
			var difR:Number = (camR - lastR)*3.5;
				
			_player.x = _player.position.x;
			_player.y = _player.position.y;
			_player.rotation = _player.rot;
			
			if(CAMERA_MODE == 0){
				_translationContainer.x = camX + difX;
				_translationContainer.y = camY + difY;
				_rotationContainer.rotation = camR + difR -90;
				
			}else if(CAMERA_MODE == 1){
				_translationContainer.x = camX + difX;
				_translationContainer.y = camY + difY;
				_rotationContainer.rotation = 0;
			}
			trace(stage);
			this.x = stage.stageWidth/2;
			this.y = stage.stageHeight/2;
				
			lastX = -_player.position.x;
			lastY = -_player.position.y;
			lastR = -_player.rot;
			
			//_player.x = _player.position.x;
			//_player.y = _player.position.y;
			//_player.rotation = _player.rot;
		}
		
		
		public function onContactMade(e:ContactEvent){
			var o1:Object = e.point.GetFixtureA().GetBody().GetUserData();
			var o2:Object = e.point.GetFixtureB().GetBody().GetUserData();
			if((o1 is Goal && o2 is Player) || (o2 is Goal && o1 is Player)){
				//win();
			}else if((o1 is DropoffPoint && o2 is Player) || (o2 is DropoffPoint && o1 is Player)){
				trace("Dropoff Made");
				if(o1 is DropoffPoint) {
					this._backgroundClip.removeChild(o1 as DisplayObject);
					this.removeBody((o1 as PhysicalClip).body);
				}
				else {
					this._backgroundClip.removeChild(o2 as DisplayObject);
					this.removeBody((o2 as PhysicalClip).body);
				}
				(_backgroundClip as Level).droppoffsLeft --;
				if((_backgroundClip as Level).droppoffsLeft <= 0) win();
				
			}
		}
		
		
		public function onContactLost(e:ContactEvent){
			var o1:Object = e.point.GetFixtureA().GetBody().GetUserData();
			var o2:Object = e.point.GetFixtureB().GetBody().GetUserData();
			if((o1 is Goal && o2 is Player) || (o2 is Goal && o1 is Player)){
				//win();
			}
		}
		
		//Post solve because for some reason this is the only event which gives the force behind a collision
		public function onContactPostSolve(e:ContactEvent){
			var o1:Object = e.point.GetFixtureA().GetBody().GetUserData();
			var o2:Object = e.point.GetFixtureB().GetBody().GetUserData();
			
			if((o1 is Player && !e.point.GetFixtureB().IsSensor()) || (o2 is Player && !e.point.GetFixtureA().IsSensor())){
				_player.takeDamage(e.point, e.impulse);
			}
		}
		
		public function win(){
			trace("WINNNNER!!!!");
			Main.instance.winDerp();
		}
		
		public function get player():Player { return _player; }
		
		public function get background():MovieClip { return _backgroundClip; }
		
		public function get world():b2World { return _world; }
		public function get stepTime():Number { return _stepTime; }
	
		public function get buildings():Vector.<Building> { return _buildings; }
	
		public function removeBody(body:b2Body):void { _removalBodies.push(body); }
		
		public override function addChild(child:DisplayObject):DisplayObject{
			return this._translationContainer.addChild(child);
		}
		
		public function cleanup(e:Event){
			this._stepTimer.stop();
		}
	}
	
}
