package  Racer{
	
	public class BuildingLayer extends AbstractGameLayer{

		var _mapGrid:Array;
		var _mapHeight:int=10; //width and height of map, including outer loop
		var _mapWidth:int=10;
		
		public function BuildingLayer(aGameScreen:GameScreen) {
			super(aGameScreen);
			_mapGrid = new Array(_mapWidth,_mapHeight);
		}
		
		public function init(){
			//populate the mapGrid based on chosen roads
			var i:int,j:int;
			for(i=0;i<_mapWidth;i++)
			{
				for(j=0;j<_mapHeight;j++)
				{
					//if (!(i==1||i==_mapWidth-1||j==1||j==_mapHeight-1)) //NOT cases in which we get null
					{
						//create a building
						var b:Building = new Building();
						b.x=i*(b.width + 600) - 150;//TODO
						b.y=j*(b.height + 600) - 150;//TODO
						addChild(b);
						b.world = _gameScreen.world;
					}
				}
			}
		}
		
		public function update(){

		}

	}
	
}
