package mew.windows {
	import flash.net.navigateToURL;
	import fl.controls.Button;

	import mew.factory.ButtonFactory;

	import system.MewSystem;

	import widget.Widget;

	import com.greensock.TweenLite;

	import flash.display.NativeWindowInitOptions;
	import flash.display.Screen;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.html.HTMLLoader;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	public class ImageViewer extends VideoViewer
	{
		private var originURL:String = null;
		private var midURL:String = null;
		private var wid:int = 0;
		private var hei:int = 0;
		private var loadingText:TextField = null;
		private var realH:int;
		private var downloadButton:Button = null;
		public function ImageViewer(initOptions:NativeWindowInitOptions)
		{
			super(initOptions);
		}
		
		override protected function init():void
		{
			return;
		}
		public function showImage(w:int, h:int, ourl:String, murl:String):void
		{
			wid = w;
			hei = h;
			originURL = ourl;
			midURL = murl;
			initData();
		}
		
		private function initData():void{
			var limitH:int = 460;
			if(Screen.mainScreen.visibleBounds.height > 768) limitH = 600;
			realH = hei > limitH ? limitH : hei;
			if(hei < 100) realH = 100;
			
			var minWidth:int = wid;
			if(wid < 100) minWidth = 100;
			drawBackground(minWidth + 40, realH + 60);
			container.alpha = 0;
			this.stage.nativeWindow.width = wid + 60;
			this.stage.nativeWindow.height = realH + 80;
			this.stage.nativeWindow.x = (Screen.mainScreen.visibleBounds.width - this.stage.nativeWindow.width) / 2;
			this.stage.nativeWindow.y = (Screen.mainScreen.visibleBounds.height - this.stage.nativeWindow.height) / 2;
			
			closeBtn = ButtonFactory.CloseButton();
			addChild(closeBtn);
			closeBtn.visible = false;
			closeBtn.x = this.stage.nativeWindow.width - closeBtn.width - 20;
			closeBtn.y = 20;
			closeBtn.addEventListener(MouseEvent.CLICK, closeVideoWindow);
			
			downloadButton = ButtonFactory.ImageDownloadButton();
			downloadButton.width = 20;
			downloadButton.height = 21;
			addChild(downloadButton);
			downloadButton.x = 20;
			downloadButton.y = 20;
			downloadButton.addEventListener(MouseEvent.CLICK, downloadOriginalImage);
			
			loadingText = new TextField();
			loadingText.autoSize = TextFieldAutoSize.LEFT;
			loadingText.defaultTextFormat = Widget.wbFromFormat;
			loadingText.selectable = false;
			loadingText.mouseEnabled = false;
			loadingText.visible = false;
			
			TweenLite.to(container, .3, {alpha: 1, onComplete: showAllComponents}); 
		}

		private function downloadOriginalImage(event : MouseEvent) : void
		{
			navigateToURL(new URLRequest(originURL));
		}
		
		private function showAllComponents():void
		{
			background.addEventListener(MouseEvent.RIGHT_CLICK, closeVideoWindow);
			closeBtn.visible = true;
			loadingText.visible = true;
			MewSystem.showCycleLoading(container);
			html = new HTMLLoader();
			addChild(html);
			html.paintsDefaultBackground = false;
			html.addEventListener(Event.COMPLETE, htmlLoadComplete);
			html.load(new URLRequest(midURL));
		}
		
		override protected function closeVideoWindow(event:MouseEvent):void
		{
			this.stage.nativeWindow.close();
			MewSystem.app.imageViewer = null;
		}
		
		override protected function htmlLoadComplete(event:Event):void
		{
			MewSystem.removeCycleLoading(container);
			html.removeEventListener(Event.COMPLETE, htmlLoadComplete);
			html.width = wid;
			html.height = realH;
			html.x = (this.stage.nativeWindow.width - html.width) / 2;
			html.y = (this.stage.nativeWindow.height - html.height) / 2 + 10;
		}
		
		override public function showVideo(str:String, title:String):void
		{
			return;
		}
		
		override protected function dealloc(event:Event):void
		{
			super.dealloc(event);
			background.removeEventListener(MouseEvent.RIGHT_CLICK, closeVideoWindow);
			originURL = null;
			loadingText = null;
			midURL = null;
		}
	}
}