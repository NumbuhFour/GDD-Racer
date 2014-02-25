package  Racer{
	
	import flash.display.MovieClip;
	
	public class CarLayer extends AbstractGameLayer{

		var gameScreen:GameScreen;
		var player:Player;
		var cops:Vector.<Cop>;
		
		public function CarLayer(aGameScreen:GameScreen) {
			super(aGameScreen);
			
		}
		
		public function init(){
			cops = new Vector.<Cop>();
			player = new Player();
			addChild(player);
			initCops();
		}
		
		public function update(){
			player.update();
			for each (var c:Cop in cops){
				c.update();
			}
		}
		
		private function initCops(){
			var cop:Cop = new Cop();
			cop.init(this.player);
			cops.push(cop);
			addChild(cop);
			
		}

	}
	
}
