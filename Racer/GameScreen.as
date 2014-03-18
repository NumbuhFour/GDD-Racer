package  Racer{
	
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.geom.Point;
	import Box2D.Collision.*;
	import Box2D.Dynamics.b2World;
	import Box2D.Common.Math.b2Vec2;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.display.DisplayObject;
	import Box2D.Dynamics.b2DebugDraw;
	import com.as3toolkit.ui.Keyboarder;
	import flash.ui.Keyboard;
	import flash.display.Graphics;
	import Box2D.Dynamics.b2ContactListener;
	
	public class GameScreen extends Sprite{
		public static const FRICTION:Number = 10;
		public static const SCALE:Number = 17;
		public static var DEBUG:Boolean = false;
		private var _wasQDown:Boolean = false;
		private var dbg:b2DebugDraw;
		private var centerSprite:Sprite;
		
		private var _cameraMode:int = 0;
		private var _wasCDown:Boolean = false;
		
		var _carLayer:CarLayer;
		var _buildingLayer:BuildingLayer;
		var _player:Player;
		var _backgroundClip:MovieClip;
		var _uiLayer:UILayer;
		var _translationContainer:MovieClip;
		var _rotationContainer:MovieClip;
		
		private var _world:b2World;
		private var _contactListener:ContactListener;
		private var _stepTime:Number = 0.042;
		private var _stepTimer:Timer;
		
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
		
		public function init(){
			_world = new b2World(new b2Vec2(),true);
			(_backgroundClip as Level).gameScreen = this;
			
			_contactListener = new ContactListener(this);
			_world.SetContactListener(_contactListener);
			
			this.addEventListener(ContactListener.CONTACT_MADE, onContactMade);
			this.addEventListener(ContactListener.CONTACT_REMOVED, onContactLost);
			
			_carLayer = new CarLayer(this);
			addChild(_carLayer);

			_player = new Player();
			addChild(_player);
			_player.world = _world;
			
			_carLayer.init(); 
			
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
				this._cameraMode = (this._cameraMode+1)%2;
			}
			_wasCDown = Keyboarder.keyIsDown(Keyboard.C);
			
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
			var difR:Number = (camR - lastR)*2;
			if(this._cameraMode == 0){
				_translationContainer.x = camX + difX;//(camX + lastX) / 2;
				_translationContainer.y = camY + difY;//(camY + lastY) / 2;
				_rotationContainer.rotation = camR + difR -90;//(camR + lastR) / 2 - 90;
				//_player.rotation = -90;
				
				//var r:Number = Math.atan(camR - lastR);
				//_player.x = r * (camY - lastY);
				//_player.y = (1/r) * (camX - lastX);
				
				lastX = -_player.position.x;
				lastY = -_player.position.y;
				lastR = -_player.rot;
				
				_player.x = _player.position.x;
				_player.y = _player.position.y;
				_player.rotation = _player.rot;
			}else if(this._cameraMode == 1){
				/*
				_translationContainer.x = -_player.position.x;
				_translationContainer.y = -_player.position.y;
				_rotationContainer.rotation = 0;
				_player.rotation = _player.rot;*/
				
				_translationContainer.x = camX + difX;//(camX + lastX) / 2;
				_translationContainer.y = camY + difY;//(camY + lastY) / 2;
				_rotationContainer.rotation = 0;//camR + difR -90;//(camR + lastR) / 2 - 90;
				//_player.rotation = -90;
				
				//var r:Number = Math.atan(camR - lastR);
				//_player.x = r * (camY - lastY);
				//_player.y = (1/r) * (camX - lastX);
				
				lastX = -_player.position.x;
				lastY = -_player.position.y;
				lastR = -_player.rot;
				
				_player.x = _player.position.x;
				_player.y = _player.position.y;
				_player.rotation = _player.rot;
				
			}
			
			this.x = stage.stageWidth/2;
			this.y = stage.stageHeight/2;
			
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
				try{
					if(o1 is DropoffPoint) this._backgroundClip.removeChild(o1 as DisplayObject);
					else this._backgroundClip.removeChild(o2 as DisplayObject);
					(_backgroundClip as Level).droppoffsLeft --;
					if((_backgroundClip as Level).droppoffsLeft <= 0) win();
				}catch(e:Error){}
			}else if(o1 is Player || o2 is Player){
				_player.takeDamage(e.point);
			}
		}
		
		
		public function onContactLost(e:ContactEvent){
			var o1:Object = e.point.GetFixtureA().GetBody().GetUserData();
			var o2:Object = e.point.GetFixtureB().GetBody().GetUserData();
			if((o1 is Goal && o2 is Player) || (o2 is Goal && o1 is Player)){
				//win();
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
	
		public override function addChild(child:DisplayObject):DisplayObject{
			return this._translationContainer.addChild(child);
		}
	}
	
}
