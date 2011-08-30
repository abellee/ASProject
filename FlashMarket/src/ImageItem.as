package
{
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	public class ImageItem extends Sprite
	{
		private var targetURL:String = null;
		private var loader:Loader = null;
		private var bitmap:Bitmap = null;
		public function ImageItem()
		{
			super();
			addEventListener(Event.REMOVED_FROM_STAGE, dealloc);
		}
		public function initImage(u:String, path:String):void
		{
			targetURL = u;
			
			if(targetURL){
				this.buttonMode = true;
				addEventListener(MouseEvent.CLICK, gotoTargetPage);
			}
			if(!loader) loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, imageLoaded);
			loader.load(new URLRequest(path));
		}
		private function imageLoaded(event:Event):void
		{
			loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, imageLoaded);
			var bitmap:Bitmap = event.target.content as Bitmap;
			addChild(bitmap);
			loader = null;
		}
		private function gotoTargetPage(event:MouseEvent):void
		{
			navigateToURL(new URLRequest(targetURL));
		}
		private function dealloc(event:Event):void
		{
			removeEventListener(MouseEvent.CLICK, gotoTargetPage);
			removeEventListener(Event.REMOVED_FROM_STAGE, dealloc);
			if(bitmap && this.contains(bitmap)){
				this.removeChild(bitmap);
				bitmap.bitmapData.dispose();
			}
			bitmap = null;
			targetURL = null;
		}
	}
}