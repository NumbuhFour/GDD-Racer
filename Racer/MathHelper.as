package Racer {
	
	public class MathHelper {
		
		public static function clamp(val:Number, min:Number, max:Number):Number{
			return Math.max(Math.min(val,max),min)
		}

	}
	
}
