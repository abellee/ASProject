package mew.windows
{
	import com.greensock.TweenLite;
	
	import fl.containers.ScrollPane;
	import fl.controls.Button;
	
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.NativeMenu;
	import flash.display.NativeMenuItem;
	import flash.display.NativeWindow;
	import flash.display.NativeWindowInitOptions;
	import flash.display.NativeWindowType;
	import flash.display.Screen;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.html.HTMLLoader;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	
	import system.MewSystem;
	
	import widget.Widget;
	
	public class ImageViewer extends VideoViewer
	{
		private var originURL:String = null;
		private var wid:int = 0;
		private var hei:int = 0;
		private var loadingText:TextField = null;
		private var realH:int;
		public function ImageViewer(initOptions:NativeWindowInitOptions)
		{
			super(initOptions);
		}
		
		override protected function init():void
		{
			return;
		}
		public function showImage(w:int, h:int, ourl:String):void
		{
			wid = w;
			hei = h;
			originURL = ourl;
			initData();
		}
		
		private function initData():void{
			var limitH:int = 460;
			if(Screen.mainScreen.visibleBounds.height > 768) limitH = 600;
			realH = hei > limitH ? limitH : hei;
			
			drawBackground(wid + 40, realH + 60);
			background.alpha = 0;
			this.stage.nativeWindow.width = wid + 60;
			this.stage.nativeWindow.height = realH + 80;
			this.stage.nativeWindow.x = (Screen.mainScreen.visibleBounds.width - this.stage.nativeWindow.width) / 2;
			this.stage.nativeWindow.y = (Screen.mainScreen.visibleBounds.height - this.stage.nativeWindow.height) / 2;
			
			closeBtn = new Button();
			closeBtn.label = "close";
			addChild(closeBtn);
			closeBtn.visible = false;
			closeBtn.x = this.stage.nativeWindow.width - closeBtn.width - 15;
			closeBtn.y = 15;
			closeBtn.addEventListener(MouseEvent.CLICK, closeVideoWindow);
			
			loadingText = new TextField();
			loadingText.autoSize = TextFieldAutoSize.LEFT;
			loadingText.defaultTextFormat = Widget.wbFromFormat;
			loadingText.selectable = false;
			loadingText.mouseEnabled = false;
			loadingText.visible = false;
			
			TweenLite.to(background, .3, {alpha: 1, onComplete: showAllComponents}); 
		}
		
		private function showAllComponents():void
		{
			background.addEventListener(MouseEvent.RIGHT_CLICK, closeVideoWindow);
			closeBtn.visible = true;
			loadingText.visible = true;
			html = new HTMLLoader();
			addChild(html);
			html.paintsDefaultBackground = false;
			html.addEventListener(Event.COMPLETE, htmlLoadComplete);
			html.load(new URLRequest(originURL));
		}
		
		override protected function closeVideoWindow(event:MouseEvent):void
		{
			this.stage.nativeWindow.close();
			MewSystem.app.imageViewer = null;
		}
		
		override protected function htmlLoadComplete(event:Event):void
		{
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
			originURL = null;
			loadingText = null;
		}
	}
}