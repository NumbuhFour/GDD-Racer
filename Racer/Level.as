package Racer {
	
	import flash.display.MovieClip;
	import flash.display.DisplayObject;
	
	public class Level extends MovieClip {

		protected var _gameScreen:GameScreen;
		protected var _droppoffsLeft: int = 0;
		
		public function Level() {
		}
		
		public function set gameScreen(g:GameScreen){
			this._gameScreen = g;
			
			for(var i:int = 0; i < this.numChildren; i++){
				var o:DisplayObject = this.getChildAt(i);
				if(o is PhysicalClip){
					(o as PhysicalClip).world = _gameScreen.world;
					if(o is DropoffPoint)
					{
						_droppoffsLeft+=1;
					}					
				}
			}
		}
		
		public function get gameScreen():GameScreen{
			return _gameScreen;
		}
		
		public function get droppoffsLeft():int{
			return _droppoffsLeft;
		}
		
		public function set droppoffsLeft(i:int){
			_droppoffsLeft = i;
		}

	}
	
}
