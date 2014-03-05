package  Racer{
	
	public class BuildingLayer extends AbstractGameLayer{

		var mapGrid:Array;
		var mapHeight:int; //width and height of map, including outer loop
		var mapWidth:int;
		
		public function BuildingLayer(aGameScreen:GameScreen) {
			super(aGameScreen);
			mapGrid = new Array(mapWidth,mapHeight);
		}
		
		/*public function init(){
			//populate the mapGrid based on chosen roads
			var i:int,j:int;
			for(i=0;i<mapWitdh;i++)
			{
				for(j=0;j<mapHeight;j++)
				{
					if (!(i==1||i==mapWidth-1||j==1||j==mapHeight-1)) //NOT cases in which we get null
					{
						//create a building
						var b:Building = new Building();
						b.x=i*b.width;//TODO
						b.y=j*b.height;//TODO
						addChild(b);
					}
				}
			}
		}*/
		
		public function update(){


		}

	}
	
}
