package
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	
	public class Item extends Sprite
	{
		public var itemType:int;
		public var itemImage:Bitmap;
		public var isJY:Boolean;
		public function Item(bitmap:Bitmap, type:int, _isJy:Boolean = false)
		{
			super();
			
			itemType = type;
			itemImage = bitmap;
			isJY = _isJy;
			
			addChild(itemImage);
		}
		
		public function dealloc():void
		{
			itemImage.bitmapData.dispose();
			itemImage = null;
		}
	}
}