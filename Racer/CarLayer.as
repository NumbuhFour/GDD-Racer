package  Racer{
	
	import flash.display.MovieClip;
	import flash.utils.Dictionary;
	
	public class CarLayer extends AbstractGameLayer{

		var dispatch:Dispatch = new Dispatch();
		var cops:Vector.<Cop>;
		
		public function CarLayer(aGameScreen:GameScreen) {
			super(aGameScreen);
			
		}
		
		public function init(nodes:Dictionary){
			dispatch.createNodes(nodes);
			cops = new Vector.<Cop>();
			initCops();
		}
		
		public function update(){
			for each (var c:Cop in cops){
				c.update();
			}
		}
		
		private function initCops(){
			var cop:Cop = new Cop(this._gameScreen);
			cop.init(_gameScreen.player);
			cops.push(cop);
			addChild(cop);
			
		}

	}
	
}
