package
{
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.system.LoaderContext;
	
	public class ImageItem extends Sprite
	{
		private var targetURL:String = null;
		private var loader:Loader = null;
		private var bitmap:Bitmap = null;
		//private var maxHeight:Number = 86;
		private var maxWidth:Number = 90;
		private var maxHeight:Number = 90;
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
			var lc:LoaderContext = new LoaderContext();
			lc.checkPolicyFile = true;
			loader.load(new URLRequest(path), lc);
		}
		private function imageLoaded(event:Event):void
		{
			loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, imageLoaded);
			var bitmap:Bitmap = event.target.content as Bitmap;
			addChild(bitmap);
			// 保持所有图片高度一致 所以只作高度上的处理
			var scale:Number = 1;
			if(bitmap.width != maxWidth && bitmap.width >= bitmap.height)
				scale = maxWidth / bitmap.width;
			else if(bitmap.height != maxHeight && bitmap.height >= bitmap.width)
				scale = maxHeight / bitmap.height;
			bitmap.width = scale * bitmap.width;
			bitmap.height = scale * bitmap.height;
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