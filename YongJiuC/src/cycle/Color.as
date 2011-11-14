package cycle
{
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.URLRequest;
	
	public class Color extends Sprite
	{
		private var _w:uint;
		private var _h:uint;
		public var value:Number;
		public var price:Number;
		public var pantone:String;
		public function Color(colorValue:Number, priceValue:Number, pantoneValue:String, iconWidth:int = 14, iconHeight:int = 14)
		{
			super();
			
			_w = iconWidth;
			_h = iconHeight;
			value = colorValue;
			price = priceValue;
			pantone = pantoneValue;
			
			drawColor();
		}
		
		private function drawColor():void
		{
			this.graphics.clear();
			this.graphics.beginFill(value);
			this.graphics.drawRoundRect(0, 0, _w, _h, 5, 5);
			this.graphics.endFill();
		}
	}
}