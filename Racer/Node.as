package Racer {
	import flash.geom.Point;
	import flash.utils.Dictionary;
	import flash.display.MovieClip;
	
	public class Node extends MovieClip{

		private var id:String;
		private var nodes:Vector.<String> = new Vector.<String>();
		
		public function get X():Number{ return x; }
		
		public function get Y():Number{ return y; }
		
		public function get ID():String{ return id; }
		
		public function set ID(id:String){ this.id = id; }
		
		public function get point():Point{ return new Point(this.x, this.y); }
		
		public function get Nodes():Vector.<String>{ return this.nodes; }
		
		public function Node(){
			this.id = name;
		}
		
		public function addAdjacentNode(id:String){
			this.nodes.push(id);
		}

	}
	
}
