package Racer {
	
	import flash.display.MovieClip;
	import flash.display.DisplayObject;
	
	public class Level extends MovieClip {

		protected var _gameScreen:GameScreen;
		
		public function Level() {
		}
		
		public function set gameScreen(g:GameScreen){
			this._gameScreen = g;
			
			for(var i:int = 0; i < this.numChildren; i++){
				var o:DisplayObject = this.getChildAt(i);
				if(o is PhysicalClip){
					(o as PhysicalClip).world = _gameScreen.world;
				}
			}
		}

	}
	
}
