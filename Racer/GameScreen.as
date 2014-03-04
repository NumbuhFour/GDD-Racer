package  Racer{
	
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class GameScreen extends Sprite{

		var carLayer:CarLayer;
		var buildingLayer:BuildingLayer;
		var uiLayer:UILayer;
		
		public function GameScreen() {
			
		}
		
		public function init(){
			carLayer = new CarLayer(this);
			//buildingLayer = new BuildingLayer(this);
			//uiLayer = new UILayer(this);
			carLayer.init();
			//buildingLayer.init();
			//uiLayer.init();
			addChild(carLayer);
			//addChild(BuildingLayer);
			//addChild(uiLayer);
			addEventListener(Event.ENTER_FRAME, update);
		}
		
		private function update(event:Event){
			carLayer.update();
		}
		

	}
	
}
