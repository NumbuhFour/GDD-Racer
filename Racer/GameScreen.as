package  Racer{
	
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.geom.Point;
	
	public class GameScreen extends Sprite{

		var carLayer:CarLayer;
		var _buildingLayer:BuildingLayer;
		var _player:Player;
		var _backgroundClip:MovieClip;
		var uiLayer:UILayer;
		
		public function GameScreen(backgroundClip:MovieClip) {
			trace("BACKGROUND : " + backgroundClip);
			this._backgroundClip = backgroundClip;
		}
		
		public function init(){
			_buildingLayer = new BuildingLayer(this);
			addChild(_buildingLayer);
			
			carLayer = new CarLayer(this);
			addChild(carLayer);

			_player = new Player();
			addChild(_player);
			

			
			//uiLayer = new UILayer(this);

			
			//buildingLayer.init();

			carLayer.init();
			_buildingLayer.init();

			//uiLayer.init();
			//addChild(BuildingLayer);
			//addChild(uiLayer);
			addEventListener(Event.ENTER_FRAME, update);
		}
		
		private function update(event:Event){
			player.update();
			carLayer.update();
			moveCamera();
		}
		
		private function moveCamera(){
			var camPos:Point = new Point(-_player.position.x + stage.stageWidth/2, -_player.position.y + stage.stageHeight/2);
			_buildingLayer.x = carLayer.x = _backgroundClip.x = camPos.x;
			_buildingLayer.y = carLayer.y = _backgroundClip.y = camPos.y;
			this.x = stage.stageWidth/2;
			this.y = stage.stageHeight/2;
			_player.rotation = _player.rot;
			this.rotation = -_player.rot-90;
		}
		
		public function get player():Player { return _player; }

	}
	
}
