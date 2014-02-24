package  Racer{
	
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class GameScreen extends Sprite{

		var carLayer:CarLayer;
		var buildingLayer:BuildingLayer;
		
		public function GameScreen() {
			
		}
		
		public function init(){
			carLayer = new CarLayer(this);
			//buildingLayer = new BuildingLayer(this);
			carLayer.init();
			addChild(carLayer);
			//addChild(BuildingLayer);
			addEventListener(Event.ENTER_FRAME, update);
		}
		
		private function update(event:Event){
			carLayer.update();
		}
		

	}
	
}
