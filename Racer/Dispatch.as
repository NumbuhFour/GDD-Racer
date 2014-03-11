package Racer {
	import flash.utils.Dictionary;
	import flash.xml.XMLNode;
	import flash.xml.XMLDocument;
	
	public class Dispatch {
	
		private var xml:XML;
		private var nodes:Dictionary = new Dictionary();
		
		public function Dispatch() {
			this.xml = GameDataStore.sharedInstance.xml;
			
		}
		
		public function createNodes(nodes:Dictionary){
			var xmlList:XMLList = xml.levels.testLevel.children();
			trace(xmlList);
			for each (var node:XMLList in xmlList){
				this.nodes[node.attribute('id')] = nodes[node.attribute('id')];
				trace(node.attribute('id'));
				for (var i:int = 0; i < xmlList.length; i++){
					this.nodes[node.attribute('id')].addAdjacentNode(node[i].text());
					
				}
			}
		}

	}
	
}
