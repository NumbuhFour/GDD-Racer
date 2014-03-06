package  Racer{
	
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.events.Event;
	
	public class GameScreen extends Sprite{

		var carLayer:CarLayer;
		var buildingLayer:BuildingLayer;
		var _player:Player;
		var _backgroundClip:MovieClip;
		var uiLayer:UILayer;
		
		public function GameScreen(backgroundClip:MovieClip) {
			trace("BACKGROUND : " + backgroundClip);
			this._backgroundClip = backgroundClip;
		}
		
		public function init(){
			carLayer = new CarLayer(this);
			addChild(carLayer);
			//buildingLayer = new BuildingLayer(this);

			_player = new Player();
			addChild(_player);
			
			carLayer.init();
			//addChild(BuildingLayer);
			
			//uiLayer = new UILayer(this);
			
			//buildingLayer.init();
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
			carLayer.x = _backgroundClip.x = -_player.position.x + stage.stageWidth/2;
			carLayer.y = _backgroundClip.y = -_player.position.y + stage.stageHeight/2;
			this.x = stage.stageWidth/2;
			this.y = stage.stageHeight/2;
			_player.rotation = _player.rot;
			this.rotation = -_player.rot-90;
		}
		
		public function get player():Player { return _player; }

	}
	
}
