package mew.modules
{
	import fl.controls.Button;
	
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.NativeWindowInitOptions;
	import flash.display.NativeWindowType;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	
	import mew.factory.ButtonFactory;
	import mew.factory.StaticAssets;
	import mew.windows.VideoViewer;
	
	import system.MewSystem;

	public class VideoBox extends ImageBox
	{
		protected var playBtn:Button = null;
		public function VideoBox()
		{
			super();
		}
		override protected function init():void
		{
			defaultBK = new Bitmap(StaticAssets.DefaultVideo);
			playBtn = ButtonFactory.PlayButton();
		}
		
		override public function create():void
		{
			addChild(defaultBK);
			if(!data.thumbURL){
				addChild(playBtn);
				playBtn.x = (this.width - playBtn.width) / 2;
				playBtn.y = (this.height - playBtn.height) / 2;
				playBtn.addEventListener(MouseEvent.CLICK, playVideo);
				
				this.width = defaultBK.width;
				this.height = defaultBK.height;
				this.setSize(this.width, this.height);
				return;
			}
			if(!loader) loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, thumbImage_loadCompleteHandler);
			loader.load(new URLRequest(data.thumbURL));
		}
		
		override protected function thumbImage_loadCompleteHandler(event:Event):void
		{
			super.thumbImage_loadCompleteHandler(event);
			addChild(playBtn);
			playBtn.x = (this.width - playBtn.width) / 2;
			playBtn.y = (this.height - playBtn.height) / 2;
			playBtn.addEventListener(MouseEvent.CLICK, playVideo);
			removeEventListener(MouseEvent.CLICK, showOriginalImage);
		}
		
		private function playVideo(event:MouseEvent):void
		{
			if(!MewSystem.app.videoViewer) MewSystem.app.videoViewer = new VideoViewer(getNativeWindowInitOption());
			MewSystem.app.videoViewer.showVideo(data.originURL, data.title);
			MewSystem.app.videoViewer.activate();
		}
		
		private function getNativeWindowInitOption():NativeWindowInitOptions
		{
			var nativeWindowInitOption:NativeWindowInitOptions = new NativeWindowInitOptions();
			nativeWindowInitOption.systemChrome = "none";
			nativeWindowInitOption.transparent = true;
			nativeWindowInitOption.type = NativeWindowType.LIGHTWEIGHT;
			
			return nativeWindowInitOption;
		}
		
		override protected function dealloc(event:Event):void
		{
			super.dealloc(event);
			if(playBtn) playBtn.removeEventListener(MouseEvent.CLICK, playVideo);
			playBtn = null;
		}
	}
}