package  Racer{
	
	import flash.display.MovieClip;
	import flash.utils.Dictionary;
	
	public class CarLayer extends AbstractGameLayer{

		var dispatch:Dispatch;
		var cops:Vector.<Cop>;
		
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
			for each (var c:Cop in cops){
				c.update();
				if (c.canSeePlayer(this._gameScreen.buildings)){
					dispatch.PlayerInSight = true;
					dispatch.PlayerLoc = this._gameScreen._player.position;
				}
			}
			dispatch.manageCops(this.cops);
		}
		
		public function initCops(numCops:int){
					
				var cop:Cop = new Cop(this._gameScreen);
				cop.world = this._gameScreen.world;
				cop.initWithPosition(_gameScreen.player, 3088, 64, dispatch);
				cops.push(cop);
				addChild(cop);
				cop = new Cop(this._gameScreen);
				cop.world = this._gameScreen.world;
				cop.initWithPosition(_gameScreen.player, 3104, 2612, dispatch);
				cops.push(cop);
				addChild(cop);
				cop = new Cop(this._gameScreen);
				cop.world = this._gameScreen.world;
				cop.initWithPosition(_gameScreen.player, -257, 2612, dispatch);
				cops.push(cop);
				addChild(cop);
			
		}
		

	}
	
}
