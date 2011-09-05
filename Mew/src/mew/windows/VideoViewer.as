package mew.windows {
	import mew.factory.ButtonFactory;
	import widget.Widget;
	import fl.controls.Button;

	import mew.data.SystemSettingData;

	import system.MewSystem;

	import com.iabel.system.GC;

	import flash.desktop.NativeApplication;
	import flash.display.NativeWindow;
	import flash.display.NativeWindowInitOptions;
	import flash.display.Screen;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.html.HTMLLoader;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	public class VideoViewer extends ALNativeWindow
	{
		protected var html:HTMLLoader = null;
		protected var titleTextField:TextField = null;
		protected var closeBtn:Button = null;
		private var bool:Boolean = true;
		public function VideoViewer(initOptions:NativeWindowInitOptions)
		{
			super(initOptions);
		}
		
		override protected function init():void
		{
			drawBackground(500, 440);
			super.init();
			this.stage.nativeWindow.x = (Screen.mainScreen.visibleBounds.width - this.stage.nativeWindow.width) / 2;
			this.stage.nativeWindow.y = (Screen.mainScreen.visibleBounds.height - this.stage.nativeWindow.height) / 2;
			html = new HTMLLoader();
			html.paintsDefaultBackground = false;
			titleTextField = new TextField();
			titleTextField.styleSheet = Widget.linkStyle;
			titleTextField.autoSize = TextFieldAutoSize.LEFT;
			
			closeBtn = ButtonFactory.CloseButton();
			addChild(closeBtn);
			closeBtn.x = this.stage.nativeWindow.width - closeBtn.width - 20;
			closeBtn.y = 20;
			closeBtn.addEventListener(MouseEvent.CLICK, closeVideoWindow);
		}
		
		private function detectApplication(event:Event):void
		{
			trace("detecting");
			if(SystemSettingData.alwaysInfront){
				if(bool){
					if(Screen.mainScreen.visibleBounds.height >= Screen.mainScreen.bounds.height) setAllWindows(false, false);
				}else{
					if(Screen.mainScreen.visibleBounds.height < Screen.mainScreen.bounds.height) setAllWindows(SystemSettingData.alwaysInfront, true);
					if((MewSystem.app.stage.nativeWindow.y + MewSystem.app.stage.nativeWindow.height) <= 30 && Screen.mainScreen.visibleBounds.y > 0){
						MewSystem.app.stage.nativeWindow.y = Screen.mainScreen.visibleBounds.y - MewSystem.app.stage.nativeWindow.height + 30;
					}
				}
			}
		}
		
		private function setAllWindows(alwaysInFront:Boolean = true, bvalue:Boolean = true):void
		{
			var arr:Array = NativeApplication.nativeApplication.openedWindows;
			for each(var win:NativeWindow in arr){
				win.alwaysInFront = alwaysInFront;
			}
			bool = bvalue;
		}
		
		protected function closeVideoWindow(event:MouseEvent):void
		{
			this.stage.nativeWindow.close();
			MewSystem.app.videoViewer = null;
			this.stage.removeEventListener(Event.ENTER_FRAME, detectApplication);
			GC.gc();
		}
		
		public function showVideo(str:String, title:String):void
		{
			if(title){
				if(title.length > 20) title = title.substr(0, 20) + "...";
				titleTextField.htmlText = "<span class=\"mainStyle\"><a href='" + str + "'>" + title + "</a></span>";
				titleTextField.width = titleTextField.textWidth;
				titleTextField.height = titleTextField.textHeight;
				addChild(titleTextField);
				titleTextField.x = 20;
				titleTextField.y = 20;
			}
			addChild(html);
			html.addEventListener(Event.COMPLETE, htmlLoadComplete);
			html.loadString("<object type=\"application/x-shockwave-flash\" width=\"480\" height=\"400\"> <param name=\"movie\" value=\"" + str +
			 "\" /> <param name=\"wmode\" value=\"transparent\" /><param name=\"allowScriptAccess\" value=\"sameDomain\" /> <param name=\"allowFullScreen\" value=\"true\" /></object>");
		}
		
		protected function htmlLoadComplete(event:Event):void
		{
			html.removeEventListener(Event.COMPLETE, htmlLoadComplete);
			html.width = 480;
			html.height = 400;
			html.x = (this.stage.nativeWindow.width - html.width) / 2;
			html.y = (this.stage.nativeWindow.height - html.height) / 2 + 10;
			this.stage.addEventListener(Event.ENTER_FRAME, detectApplication);
		}
		
		override protected function drawBackground(w:int, h:int, position:String = null):void
		{
			super.drawBackground(w, h);
			background.addEventListener(MouseEvent.MOUSE_DOWN, dragLoginPanel);
		}
		
		protected function dragLoginPanel(event:MouseEvent):void
		{
			this.stage.nativeWindow.startMove();
		}
		
		override protected function dealloc(event:Event):void
		{
			super.dealloc(event);
			this.stage.removeEventListener(Event.ENTER_FRAME, detectApplication);
			closeBtn.removeEventListener(MouseEvent.CLICK, closeVideoWindow);
			closeBtn = null;
			if(html) html.removeEventListener(Event.COMPLETE, htmlLoadComplete);
			html = null;
			titleTextField = null;
		}
	}
}