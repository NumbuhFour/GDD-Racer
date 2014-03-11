package Racer {
	import flash.utils.Dictionary;
	
	public class Dispatch {
	
		private var xml:XML;
		private var nodes:Dictionary = new Dictionary();
		
		public function Dispatch() {
			this.xml = GameDataStore.sharedInstance.xml;
			
		}
		
		public function createNodes(nodes:Dictionary){
			for each (var list:XMLList in xml.levels[0].childNodes){
				this.nodes[list.id] = nodes[list.id];
				for (var i:int = 0; i < list.length; i++){
					this.nodes[list.id].addAdjacentNode(list[i].text());
				}
			}
		}

	}
	
}
