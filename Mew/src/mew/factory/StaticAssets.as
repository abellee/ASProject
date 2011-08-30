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
		public static var DefaultImage:BitmapData = null;
		public static var YellowVIcon:BitmapData = null;
		
		/**
		 * 定时微博发布器资源
		 */
		public static var TimingPointRed:BitmapData = null;
		public static var TimingPointGreen:BitmapData = null;
		public static var TimingPointGray:BitmapData = null;
		public static var TimeLine:BitmapData = null;
		
//		public static var DefaultMusic:BitmapData = null;
//		public static var BlueVIcon:BitmapData = null;
//		public static var RedStarIcon:BitmapData = null;
		/**
		 * 关于界面、更新界面的猫脸
		 */
		public static var MewFace:BitmapData = null;
		/**
		 * 关于界面的MEW字
		 */
		public static var MewFont:BitmapData = null;
		
		public function StaticAssets()
		{
		}
		public static function getDefaultAvatar(size:int):Sprite
		{
			var sp:Sprite = new Sprite();
			sp.graphics.beginFill(0xffffff * Math.random(), 1);
			sp.graphics.drawRect(0, 0, size + 4, size + 4);
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