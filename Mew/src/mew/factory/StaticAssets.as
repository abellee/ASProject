package mew.factory
{
	import flash.display.BitmapData;
	import flash.display.Sprite;

	public class StaticAssets
	{
		public static var DefaultAvatar50:BitmapData = null;
		public static var DefaultAvatar180:BitmapData = null;
		public static var SexIcon0:BitmapData = null;
		public static var SexIcon1:BitmapData = null;
		public static var DefaultVideo:BitmapData = null;
		public static var DefaultMusic:BitmapData = null;
		public static var DefaultImage:BitmapData = null;
		public static var YellowVIcon:BitmapData = null;
		public static var BlueVIcon:BitmapData = null;
		public static var RedStarIcon:BitmapData = null;
		public function StaticAssets()
		{
		}
		public static function getDefaultAvatar():Sprite
		{
			var sp:Sprite = new Sprite();
			sp.graphics.beginFill(0xffffff * Math.random(), 1);
			sp.graphics.drawRect(0, 0, 54, 54);
			sp.graphics.endFill();
			
			return sp;
		}
		
		public static function getSexIcon():Sprite
		{
			var sp:Sprite = new Sprite();
			sp.graphics.beginFill(0xffffff * Math.random(), 1);
			sp.graphics.drawRect(0, 0, 10, 10);
			sp.graphics.endFill();
			
			return sp;
		}
	}
}