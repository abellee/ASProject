package widget
{
	import flash.display.DisplayObject;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.GlowFilter;
	import flash.text.StyleSheet;
	import flash.text.TextFormat;

	public class Widget
	{
		public static var systemFont:String = "华文黑体";
		public static var numberFont:String = "华文黑体";
		public static var atColor:String = "#3FB9F8";
		public static var topicColor:String = "#3FB9F8";
		public static var linkColor:String = "#3FB9F8";
		public static var fromColor:String = "#727272";
		public static var mainTextColor:String = "0x4c4c4c";
		public static var linkStyle:StyleSheet = null;
		public static var mainColor:Number = 0x2d2d2d;
		public static var orangeButtonFontColor:Number = 0x432318;
		
		public static var normalFormat:TextFormat = new TextFormat(systemFont, 12, 0x4C4C4C);
		public static var normalWhiteFormat:TextFormat = new TextFormat(systemFont, 12, 0xFFFFFF);
		public static var normalGrayFormat:TextFormat = new TextFormat(systemFont, 13, 0xc1c1c1);
		public static var mainPanelButtonFormat:TextFormat = new TextFormat(systemFont, 13, 0xc1c1c1, true);
		public static var searchGrayFormat:TextFormat = new TextFormat(systemFont, 12, 0xb9b9b9);
		public static var searchFormat:TextFormat = new TextFormat(systemFont, 12, 0x4C4C4C);
		public static var tipFormat:TextFormat = new TextFormat(systemFont, 12, 0xbdbdbd);
		public static var unreadFormat:TextFormat = new TextFormat(systemFont, 12, 0x7f3c00, true);
		public static var noticeFormat:TextFormat = new TextFormat(systemFont, 12, 0xf4f4f4, null, null, null, null, null, null, null, null, null, 5);
		public static var usernameFormat:TextFormat = new TextFormat(systemFont, 13, 0x4C4C4C, true);
		public static var wbSentTimeFormat:TextFormat = new TextFormat(systemFont, 12, 0x4C4C4C);
		public static var wbFromFormat:TextFormat = new TextFormat(systemFont, 12, 0x4C4C4C);
		public static var alertFormat:TextFormat = new TextFormat(systemFont, 14, 0x4C4C4C, true, null, null, null, null, "center", null, null, null, 5);
		public static var wbTextFormat:TextFormat = new TextFormat(systemFont, 12, 0x4C4C4C, null, null, null, null, null, null, null, null, null, 10);
		public static var videoTitleFormat:TextFormat = new TextFormat(systemFont, 12, 0xFFFFFF);
		public static var descriptionFormat:TextFormat = new TextFormat(systemFont, 12, 0x4C4C4C, null, null, null, null, null, null, null, null, null, 5);
		public function Widget()
		{
		}
		
		public static function widgetGlowFilter(target:DisplayObject, xBlur:Number = 10, yBlur:Number = 10):void
		{
			var color:Number = 0x000000;
			var alpha:Number = 0.5;
			var blurX:Number = xBlur;
			var blurY:Number = yBlur;
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