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
	import flash.utils.Dictionary;
	
	public class GameScreen extends Sprite{
		public static const FRICTION:Number = 10;
		public static const SCALE:Number = 17;
		private static const XML_PATH:String = "data/gameData.xml";
		
		var _carLayer:CarLayer;
		var _buildingLayer:BuildingLayer;
		var _player:Player;
		var _backgroundClip:MovieClip;
		var _uiLayer:UILayer;
		var _translationContainer:MovieClip;
		var _rotationContainer:MovieClip;
		
		private var _world:b2World;
		private var _stepTime:Number = 0.042;
		private var _stepTimer:Timer;
		
		public function GameScreen(backgroundClip:MovieClip) {
			this._backgroundClip = backgroundClip;
			
			_translationContainer = new MovieClip();
			_rotationContainer = new MovieClip();
			_rotationContainer.addChild(_translationContainer);
			super.addChild(_rotationContainer);
			addChild(_backgroundClip);
			GameDataStore.sharedInstance.loadXML(XML_PATH);
			GameDataStore.sharedInstance.addEventListener(GameDataStore.LOAD_COMPLETE, onXMLLoaded);
		}
		
		public function init(){
			_world = new b2World(new b2Vec2(),true);
			var dbg:b2DebugDraw = new b2DebugDraw();
			dbg.SetSprite(new Sprite());
			dbg.SetDrawScale(GameScreen.SCALE);
			dbg.SetFillAlpha(0.3);
			dbg.SetLineThickness(1.0);
			dbg.SetFlags(b2DebugDraw.e_shapeBit | b2DebugDraw.e_centerOfMassBit | b2DebugDraw.e_jointBit);
			_world.SetDebugDraw(dbg);
			addChild(dbg.GetSprite());
			
			this._backgroundClip.gameScreen = this;
			
			//_buildingLayer = new BuildingLayer(this);
			//addChild(_buildingLayer);
			
			_carLayer = new CarLayer(this);
			
			addChild(_carLayer);

			_player = new Player();
			super.addChild(_player);
			_player.world = _world;
			
			//uiLayer = new UILayer(this);
			var dict:Dictionary = new Dictionary();
			var j:int = 0;
			for (var i:int = 0; i < background.numChildren; i++)
				if(background.getChildAt(i) is Node)
					dict[background.getChildAt(i).name] = background.getChildAt(i);			
			_carLayer.init(dict);
			//_buildingLayer.init();
			//uiLayer.init();
			//addChild(BuildingLayer);
			//addChild(uiLayer);
			//addEventListener(Event.ENTER_FRAME, update);
			_stepTimer = new Timer(_stepTime);
			_stepTimer.addEventListener(TimerEvent.TIMER, update);
			_stepTimer.start();
			
		}
		
		public function onXMLLoaded(e:Event):void{
			this.init();
		}
		
		private function update(event:Event){
			_world.Step(_stepTime,10,10);
			_world.ClearForces();
			_player.update();
			_carLayer.update();
			moveCamera();
		}
		
		private function moveCamera(){
			
			_translationContainer.x = -_player.position.x;
			_translationContainer.y = -_player.position.y;
			this.x = stage.stageWidth/2;
			this.y = stage.stageHeight/2;
			_rotationContainer.rotation = -_player.rot - 90;
			_player.rotation = -90;
			
			//_player.x = _player.position.x;
			//_player.y = _player.position.y;
			//_player.rotation = _player.rot;
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
