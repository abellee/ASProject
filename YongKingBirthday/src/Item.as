package
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	
	public class Item extends Sprite
	{
		public var itemType:String;
		public var itemImage:Bitmap;
		public function Item()
		{
			super();
		}
		
		public function dealloc():void
		{
			itemType = null;
			itemImage.bitmapData.dispose();
			itemImage = null;
		}
	}
}