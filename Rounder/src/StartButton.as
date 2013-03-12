package
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	
	public class StartButton extends Sprite
	{
		private var bitmap:Bitmap = new (Resources.StartButton)();
		public function StartButton()
		{
			super();
			
			addChild(bitmap);
		}
		
		public function dealloc():void
		{
			bitmap.bitmapData.dispose();
			bitmap = null;
		}
	}
}