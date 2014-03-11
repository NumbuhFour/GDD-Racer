package  Racer{
	import flash.geom.Point;
	
	public class Vector2D {

		private var x:Number;
		private var y:Number;

		
		public function Vector2D(x:Number=NaN, y:Number=NaN) {
			// constructor code
		}
		
		public function addVector(v2:Vector2D){
			v2.x = this.x + v2.x;
			v2.y = this.y + v2.y;
			return v2;
		}
		
		public function addPoint(point:Point){
			return new Vector2D(point.x+this.x, point.y+this.y);
		}

		public function minusVector(v2:Vector2D){
			v2.x = this.x - v2.x;
			v2.y = this.y - v2.y;
			return v2;
		}
		
		/*public function multiply(num:Number):Vector2D{
			return new Vector2D(this.x
		}*/
		
		public function get magnitude():Number {
			return Math.sqrt(Math.pow(this.x, 2) + Math.pow(this.y, 2));
		}
		
		public function get X():Number{ return x; }
		public function set X(num:Number){ this.x = num; }
		public function get Y():Number{ return y; }
		public function set Y(num:Number){ this.y = num; }
	}
	
}
