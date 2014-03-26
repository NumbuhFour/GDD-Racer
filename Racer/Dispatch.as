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
		private var _closedList:Vector.<Node> = new Vector.<Node>();
		private var _playerAdjNodes:Vector.<Node> = new Vector.<Node>;
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
		
		//manageCops
		public function manageCops(cops:Vector.<Cop>){
			for each (var c:Cop in cops){
				if (c.LOS){
					if (c.State != "chase")
						c.changeState("chase");
				}
				else{
					if (c.State != "intercept")
						c.changeState("intercept");
					if (c.CurrNode == null)
						c.CurrNode = findClosestNode(c);
					if (c.getRect(_gameScreen).intersects(c.CurrNode.getRect(_gameScreen))){
						trace("currNode: " + c.CurrNode.ID);
						getAdjacentPlayerNodes();
						this._closedList.length = 0;
						c.CurrNode = findNextNode(c.CurrNode, c.CurrNode);
						trace("currNode: " + c.CurrNode.ID);
					}
				}
			}
		}
		
		
		//findClosestNode
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
						if (buildings[i++].getRect(_gameScreen._backgroundClip).contains(cop.x + (multX * j), cop.y + (multY * j))){
							clear = false;
							//trace("cop: " + cop.x + ":" + cop.y + "\tNode: " + node.point);
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
			else if (viableNodes.length > 1){
				var currNode:int;
				var angle:int = int.MAX_VALUE;
				for (i = 0; i < viableNodes.length; i++){
					if (Math.abs(cop.angleToPoint(viableNodes[i].point)) < angle)
						currNode = i;
				}
				return viableNodes[currNode];
			}
			return this.Nodes['n0001'];
		}
		
		//findNextNode
		private function findNextNode(orig:Node, node:Node):Node{
			//checks to see if the node has already been accessed
			for (var i:int = 0; i < _closedList.length; i++)
				if (node.ID == _closedList[i].ID)
					return null;
			//checks to see if the node is a target node
			for (i = 0; i < _playerAdjNodes.length; i++)
				if (node.ID == _playerAdjNodes[i].ID){
				 	//trace("found node: " + node.ID);
					return node;
				}
			//node is not on list, crosses it off the list
			_closedList.push(node);
			//checks surrounding nodes 
			for each (var adjNode:Node in _nodes){
				var flag:Boolean = true;
				for (var j:int = 0; j < _closedList.length; j++)
					if (adjNode.ID == _closedList[j].ID)
						flag = false;
				if (flag){
					var checkNode:Node = findNextNode(orig, adjNode);
					if (checkNode != null){
						//trace("returning node: " + checkNode.ID);
						if (node.ID == orig.ID)
							return checkNode;
						return node;
					}
				}
			}
			return null;
			
		}
		
		//getAdjacentPlayerNodes
		private function getAdjacentPlayerNodes(){
			//trace("player node LOS - player parent: " + _gameScreen._player.parent);
			_playerAdjNodes.length = 0;
			for each (var node:Node in _nodes){
				//trace("testing player node " + node.ID + " " + node.parent);
				var multX:int = (node.X - _gameScreen._player.position.x)/10;
				var multY:int = (node.Y - _gameScreen._player.position.y)/10;
				var clear:Boolean = true;
				var buildings:Vector.<Building> = _gameScreen.buildings;
				for (var j = 0; j < Math.abs(node.X - _gameScreen._player.position.x)/10; j++){
					var i:int = 0;
					var checkPoint:Point = _gameScreen._player.position;
					checkPoint.x += (multX * j);
					checkPoint.y += (multY * j);
					while (i < buildings.length && clear == true){
						if (i == 32)
							i++;
						if (buildings[i++].getRect(_gameScreen._backgroundClip).containsPoint(checkPoint)){
							//trace("building obstruct: " + (i-1) + " " + buildings[i-1].x + "," + buildings[i-1].y);
							clear = false;
						}
					}
					if (clear == false)
						break;
				}
				if (clear == true){
					//trace("player node: " + node.ID);
					if (Math.pow(multX, 2) + Math.pow(multY, 2) < 30000){
						//trace("node added");
						this._playerAdjNodes.push(node);
					}
				}
			}
			//trace("end player node LOS\n");
		}
	}
	
}
