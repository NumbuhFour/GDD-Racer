﻿package  Racer{
	
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.geom.Point;
	import Box2D.Collision.*;
	import Box2D.Dynamics.b2World;
	import Box2D.Common.Math.b2Vec2;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.display.DisplayObject;
	
	public class GameScreen extends Sprite{

		public static const FRICTION:Number = 10;
		public static const SCALE:Number = 17;
		
		var carLayer:CarLayer;
		var _buildingLayer:BuildingLayer;
		var _player:Player;
		var _backgroundClip:MovieClip;
		var _translationContainer:MovieClip;
		var _rotationContainer:MovieClip;
		var uiLayer:UILayer;
		
		private var _world:b2World;
		private var _stepTime:Number = 0.042;
		private var _stepTimer:Timer;
		
		public function GameScreen(backgroundClip:MovieClip) {
			trace("BACKGROUND : " + backgroundClip);
			this._backgroundClip = backgroundClip;
			_translationContainer = new MovieClip();
			_rotationContainer = new MovieClip();
			_rotationContainer.addChild(_translationContainer);
			super.addChild(_rotationContainer);
		}
		
		public function init(){
			_world = new b2World(new b2Vec2(),true);
			
			_buildingLayer = new BuildingLayer(this);
			addChild(_buildingLayer);
			
			carLayer = new CarLayer(this);
			addChild(carLayer);

			_player = new Player(_world);
			super.addChild(_player);
			
			//uiLayer = new UILayer(this);
			carLayer.init();
			_buildingLayer.init();
			//uiLayer.init();
			//addChild(BuildingLayer);
			//addChild(uiLayer);
			//addEventListener(Event.ENTER_FRAME, update);
			_stepTimer = new Timer(_stepTime);
			_stepTimer.addEventListener(TimerEvent.TIMER, update);
			_stepTimer.start();
		}
		
		private function update(event:Event){
			//_world.Step(_stepTime,10,10);
			player.update();
			carLayer.update();
			moveCamera();
		}
		
		private function moveCamera(){
			/*var camPos:Point = new Point(-_player.position.x + stage.stageWidth/2, -_player.position.y + stage.stageHeight/2);
			_buildingLayer.x = carLayer.x = camPos.x;
			_buildingLayer.y = carLayer.y = camPos.y;
			if(_backgroundClip){
				_backgroundClip.x = camPos.x;
				_backgroundClip.y = camPos.y;
			}
			this.x = stage.stageWidth/2;
			this.y = stage.stageHeight/2;
			_player.rotation = _player.rot;
			this.rotation = -_player.rot-90;*/
			_translationContainer.x = -_player.position.x;
			_translationContainer.y = -_player.position.y;
			this.x = stage.stageWidth/2;
			this.y = stage.stageHeight/2;
			_rotationContainer.rotation = -_player.rot - 90;
			_player.rotation = -90;
		}
		
		public function get player():Player { return _player; }
		
		public function get world():b2World { return _world; }
		public function get stepTime():Number { return _stepTime; }
	
		public override function addChild(child:DisplayObject):DisplayObject{
			return this._translationContainer.addChild(child);
		}
	}
	
}
