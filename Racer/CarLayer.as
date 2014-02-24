package  Racer{
	
	public class CarLayer extends AbstractGameLayer{

		var gameScreen:GameScreen;
		var player:Player;
		var cops:Array;
		
		public function CarLayer(aGameScreen:GameScreen) {
			super(aGameScreen);
			
		}
		
		public function init(){
			player = new Player();
			addChild(player);
		}
		
		public function update(){
			player.update();
		}

	}
	
}
