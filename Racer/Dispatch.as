package Racer {
	import flash.utils.Dictionary;
	import flash.xml.XMLNode;
	import flash.xml.XMLDocument;
	import flash.geom.Point;
	
	public class Dispatch {
	
		private var _xml:XML;
		private var _nodes:Dictionary = new Dictionary();
		private var _playerInSight:Boolean;
		private var _playerLoc:Point;
		private var _closedList:Vector.<Node>;
		private var _gameScreen:GameScreen;
		
		public function get PlayerInSight():Boolean { return _playerInSight; }
		public function set PlayerInSight(val:Boolean) { this._playerInSight = val; }
		public function get PlayerLoc():Point { return _playerLoc; }
		public function set PlayerLoc(val:Point) { this._playerLoc = val; }
		public function get Nodes():Dictionary { return this._nodes; }
		
		public function Dispatch(gs:GameScreen) {
			this._xml = GameDataStore.sharedInstance.xml;
			this._gameScreen = gs;
		}
		
		public function createNodes(nodes:Dictionary){
			
			var xmlList:XMLList = _xml.levels.testLevel;
			for (var i:int = 0; i < xmlList.node.length(); i++){
				this._nodes[xmlList.node[i].attribute('id').toString()] = nodes[xmlList.node[i].attribute('id').toString()];	
				for (var j:int = 0; j < xmlList.node[i].nodeID.length(); j++)
					this._nodes[xmlList.node[i].attribute('id').toString()].addAdjacentNode(xmlList.node[i].nodeID[j].toString());
			}
		}
		
		public function manageCops(cops:Vector.<Cop>, playerNodes:Vector.<Node>){
			for each (var c:Cop in cops){
				if (c.LOS){
					
				}
				else{
					if (c.CurrNode == null)
						c.CurrNode = findClosestNode(c);
					if (c.getRect(_gameScreen).intersects(c.CurrNode.getRect(_gameScreen))){
						this._closedList = new Vector.<Node>();
						c.CurrNode = findNextNode(c.CurrNode, playerNodes);
					}
				}
			}
		}
		
		
		
		private function findClosestNode(cop:Cop):Node{
			var viableNodes:Vector.<Node> = new Vector.<Node>();
			var buildings:Vector.<Building> = _gameScreen.buildings;
			for each (var node:Node in this.Nodes){
				var multX:int = (node.X - cop.x)/10;
				var multY:int = (node.Y - cop.y)/10;
				var clear:Boolean = true;
				for (var j = 0; j < Math.abs(node.X - cop.x)/10; j++){
					var i:int = 0;
					while (i < buildings.length && clear == true){
						if (buildings[i++].hitTestPoint(cop.x + (multX * j), cop.y + (multY * j), false)){
							clear = false;
							trace("cop: " + cop.x + ":" + cop.y + "\tNode: " + node.point);
						}
					}
					if (clear == false)
						break;
				}
				if (clear == true)
					viableNodes.push(node);
			}
			if (viableNodes.length == 1)
				return viableNodes[0];
			else{
				var currNode:int;
				var angle:int = int.MAX_VALUE;
				for (i = 0; i < viableNodes.length; i++){
					if (Math.abs(cop.angleToPoint(viableNodes[i].point)) < angle)
						currNode = i;
				}
				return viableNodes[currNode];
			}
		}
		
		private function findNextNode(node:Node, playerNodes:Vector.<Node>):Node{
			//checks to see if the node has already been accessed
			for (var i:int = 0; i < _closedList.length; i++)
				if (node == _closedList[i])
					return null;
			//checks to see if the node is a target node
			for (i = 0; i < playerNodes.length; i++)
				if (node.ID == playerNodes[i].ID)
				 	return node;
			for (i = 0; i < node.Nodes.length; i++){
				var checkNode:Node = findNextNode(node, playerNodes);
				if (checkNode != null)
					return node;
			}
			return null;
			
		}
		
		

	}
	
}
