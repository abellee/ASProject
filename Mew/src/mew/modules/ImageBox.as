package mew.modules
{
	import com.greensock.TweenLite;
	import com.iabel.core.UISprite;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.NativeWindow;
	import flash.display.NativeWindowInitOptions;
	import flash.display.NativeWindowType;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	
	import mew.data.ImageData;
	import mew.data.MediaData;
	import mew.factory.StaticAssets;
	import mew.windows.ImageViewer;
	
	import system.MewSystem;
	
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
			defaultBK = StaticAssets.getDefaultAvatar(50);
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
				defaultBK = null;
			}
			loader.unloadAndStop();
			loader = null;
			this.width = bitmap.width;
			this.height = bitmap.height;
			this.setSize(this.width, this.height);
			addEventListener(MouseEvent.CLICK, showOriginalImage);
			this.dispatchEvent(new Event(Event.RESIZE));
		}
		
		protected function showOriginalImage(event:MouseEvent):void
		{
			if(!(data as ImageData).originWidth){
				(data as ImageData).addEventListener("size_init_complete", showImageViewer);
			}else{
				showImageViewer();
			}
		}
		
		protected function showImageViewer(event:Event = null):void
		{
			(data as ImageData).removeEventListener("size_init_complete", showImageViewer);
			if(MewSystem.app.imageViewer){
				MewSystem.app.imageViewer.close();
				MewSystem.app.imageViewer = null;
			}
			MewSystem.app.imageViewer = new ImageViewer(getNativeWindowInitOption());
			MewSystem.app.imageViewer.showImage((data as ImageData).originWidth, (data as ImageData).originHeight, (data as ImageData).originURL);
			MewSystem.app.imageViewer.activate();
		}
		
		private function getNativeWindowInitOption():NativeWindowInitOptions
		{
			var nativeWindowInitOption:NativeWindowInitOptions = new NativeWindowInitOptions();
			nativeWindowInitOption.systemChrome = "none";
			nativeWindowInitOption.transparent = true;
			nativeWindowInitOption.type = NativeWindowType.LIGHTWEIGHT;
			
			return nativeWindowInitOption;
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
		
		override protected function dealloc(event:Event):void
		{
			super.dealloc(event);
			if(data && (data is ImageData)) (data as ImageData).removeEventListener("size_init_complete", showImageViewer);
			data = null;
			defaultBK = null;
			if(loader) loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, thumbImage_loadCompleteHandler);
			loader = null;
			bitmap = null;
		}
	}
}