package
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	
	public class Round extends Sprite
	{
		private var bitmap:Bitmap;
		public function Round()
		{
			super();
			
			var tempBitmap:Bitmap = new (Resources.Round)();
			var bd:BitmapData = new BitmapData(tempBitmap.width, tempBitmap.height, true, 0x00000000);
			bd.draw(tempBitmap, null, null, null, new Rectangle(0, 0, tempBitmap.width, tempBitmap.height), true);
			bitmap = new Bitmap(bd, "auto", true);
			addChild(bitmap);
			bitmap.x = -bitmap.width / 2;
			bitmap.y = -bitmap.height / 2;
		}
		
		public function dealloc():void
		{
			bitmap.bitmapData.dispose();
			bitmap = null;
		}
	}
}