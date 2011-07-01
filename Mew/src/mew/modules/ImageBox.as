package mew.modules
{
	import com.greensock.TweenLite;
	import com.iabel.core.UISprite;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.URLRequest;
	
	import mew.data.ImageData;
	import mew.data.MediaData;
	import mew.factory.StaticAssets;
	
	public class ImageBox extends UISprite
	{
		public var data:MediaData = null;
		protected var defaultBK:DisplayObject = null;
		protected var loader:Loader = null;
		private var bitmap:Bitmap = null;
		public function ImageBox()
		{
			super();
			
			init();
		}
		public function create():void
		{
			addChild(defaultBK);
			
			if(!loader) loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, thumbImage_loadCompleteHandler);
			loader.load(new URLRequest(data.thumbURL));
		}
		protected function init():void
		{
			defaultBK = StaticAssets.getDefaultAvatar();
		}
		protected function thumbImage_loadCompleteHandler(event:Event):void
		{
			loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, thumbImage_loadCompleteHandler);
			bitmap = event.target.content as Bitmap;
			addChild(bitmap);
			if(bitmap.width < 20) bitmap.width = 20;
			bitmap.alpha = 0;
			TweenLite.to(bitmap, .5, {alpha: 1});
			if(defaultBK && this.contains(defaultBK)){
				removeChild(defaultBK);
				defaultBK = null
			}
			loader.unloadAndStop();
			loader = null;
			this.width = bitmap.width;
			this.height = bitmap.height;
			this.setSize(this.width, this.height);
			this.dispatchEvent(new Event(Event.RESIZE));
		}
		
		public function removeBitmap():void
		{
			if(loader){
				loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, thumbImage_loadCompleteHandler);
				loader = null;
			}
			if(bitmap){
				if(this.contains(bitmap)) removeChild(bitmap);
				bitmap.bitmapData.dispose();
				bitmap = null;
			}
		}
		public function reloadBitmap():void
		{
			if(!loader) loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, thumbImage_loadCompleteHandler);
			loader.load(new URLRequest(data.thumbURL));
		}
	}
}