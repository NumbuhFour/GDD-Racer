package Racer {
	import flash.geom.Point;
	
	public class MathHelper {
		
		public static function clamp(val:Number, min:Number, max:Number):Number{
			return Math.max(Math.min(val,max),min)
		}
		
		public static function addPoints(p1:Point, p2:Point):Point{
			p1.x += p2.x;
			p1.y += p2.y;
			return p1;
		}
		
		public static function subPoints(p1:Point, p2:Point):Point{
			p1.x -= p2.x;
			p1.y -= p2.y;
			return p1;
		}
		
		public static function scalePoint(point:Point, scalar:Number):Point{
			point.x *= scalar;
			point.y *= scalar;
			return point;
		}

	}
	
}
