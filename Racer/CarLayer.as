package  Racer{
	
	import flash.display.MovieClip;
	import flash.utils.Dictionary;
	
	public class CarLayer extends AbstractGameLayer{

		var dispatch:Dispatch;
		var cops:Vector.<Cop>;
		var playerAdjNodes:Vector.<Node> = new Vector.<Node>;
		
		public function CarLayer(aGameScreen:GameScreen) {
			super(aGameScreen);
			dispatch = new Dispatch(aGameScreen);
		}
		
		public function init(nodes:Dictionary){
			//trace(nodes);
			dispatch.createNodes(nodes);
			cops = new Vector.<Cop>();
		}
		
		public function update(){
			if (dispatch.PlayerInSight){
				getAdjacentPlayerNodes();
			}
			for each (var c:Cop in cops){
				c.update();
				if (c.canSeePlayer(this._gameScreen.buildings)){
					dispatch.PlayerInSight = true;
					dispatch.PlayerLoc = this._gameScreen._player.position;
				}
			}
			dispatch.manageCops(this.cops, this.playerAdjNodes);
		}
		
		public function initCops(numCops:int){
			for (var i:int = 0; i < numCops; i++){ 			
				var cop:Cop = new Cop(this._gameScreen);
				cop.world = this._gameScreen.world;
				cop.initWithPosition(_gameScreen.player, i*100, 100, dispatch);
				cops.push(cop);
				addChild(cop);
			}
			
		}
		
		private function getAdjacentPlayerNodes(){
			for each (var node:Node in dispatch.Nodes){
				var multX:int = (node.X - _gameScreen._player.position.x)/10;
				var multY:int = (node.Y - _gameScreen._player.position.y)/10;
				var clear:Boolean = true;
				var buildings:Vector.<Building> = _gameScreen.buildings;
				for (var j = 0; j < Math.abs(node.X - _gameScreen._player.position.x)/10; j++){
					var i:int = 0;
					while (i < buildings.length && clear == true){
						if (buildings[i++].hitTestPoint(_gameScreen._player.position.x + (multX * j), _gameScreen._player.position.y + (multY * j), false)){
							clear = false;
						}
					}
					if (clear == false)
						break;
				}
				if (clear == true)
					this.playerAdjNodes.push(node);
			}

		}
		

	}
	
}
