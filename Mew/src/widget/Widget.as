package widget
{
	import flash.display.DisplayObject;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.GlowFilter;
	import flash.text.StyleSheet;
	import flash.text.TextFormat;

	public class Widget
	{
		public static var usernameFormat:TextFormat = new TextFormat("华文黑体", 13, 0x4C4C4C, true);
		public static var wbSentTimeFormat:TextFormat = new TextFormat("华文黑体", 12, 0x4C4C4C);
		public static var wbFromFormat:TextFormat = new TextFormat("华文黑体", 12, 0x4C4C4C);
		public static var wbTextFormat:TextFormat = new TextFormat("华文黑体", 12, 0x4C4C4C, null, null, null, null, null, null, null, null, null, 5);
		public static var atColor:String = "#3FB9F8";
		public static var topicColor:String = "#3FB9F8";
		public static var linkColor:String = "#3FB9F8";
		public static var fromColor:String = "#F6A835";
		public static var linkStyle:StyleSheet = null;
		public function Widget()
		{
		}
		
		public static function widgetGlowFilter(target:DisplayObject):void
		{
			var color:Number = 0x000000;
			var alpha:Number = 0.5;
			var blurX:Number = 10;
			var blurY:Number = 10;
			var strength:Number = 1;
			var inner:Boolean = false;
			var knockout:Boolean = false;
			var quality:Number = BitmapFilterQuality.HIGH;
			
			target.filters = [new GlowFilter(color,
				alpha,
				blurX,
				blurY,
				strength,
				quality,
				inner,
				knockout)];
		}
	}
}