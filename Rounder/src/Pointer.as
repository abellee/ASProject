package
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	
	public class Pointer extends Sprite
	{
		private var bitmap:Bitmap;
		public function Pointer()
		{
			super();
			
			var tempBitmap:Bitmap = new (Resources.Pointer)();
			var bd:BitmapData = new BitmapData(tempBitmap.width, tempBitmap.height, true, 0x00000000);
			bd.draw(tempBitmap, null, null, null, new Rectangle(0, 0, tempBitmap.width, tempBitmap.height), true);
			bitmap = new Bitmap(bd, "auto", true);
			addChild(bitmap);
			bitmap.x = -68;
			bitmap.y = -152;
		}
		
		public function dealloc():void
		{
			bitmap.bitmapData.dispose();
			bitmap = null;
		}
	}
}