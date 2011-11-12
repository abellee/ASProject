package
{
	import flash.display.DisplayObject;
	import flash.filters.BitmapFilter;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.GlowFilter;
	import flash.text.TextFormat;

	public class Cache
	{
		public static var normalFormat:TextFormat = new TextFormat("华文黑体", 12, 0xFFFFFF, true, null, null, null, null, "center", null, null, null);
		public static var bitmapDataList:Object = null;
		public function Cache()
		{
		}
		public static function showGlow(displayObject:DisplayObject):void
		{
			var color:Number = 0x000000;
			var alpha:Number = 0.8;
			var blurX:Number = 10;
			var blurY:Number = 10;
			var strength:Number = 1;
			var inner:Boolean = false;
			var knockout:Boolean = false;
			var quality:Number = BitmapFilterQuality.HIGH;
			
			var glow:GlowFilter = new GlowFilter(color,
				alpha,
				blurX,
				blurY,
				strength,
				quality,
				inner,
				knockout);
			
			displayObject.filters = [glow];
		}
	}
}