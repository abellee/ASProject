package mew.windows {
	import fl.controls.Button;
	import fl.controls.UIScrollBar;

	import mew.factory.ButtonFactory;
	import mew.factory.StaticAssets;

	import system.MewSystem;

	import widget.Widget;

	import com.greensock.TweenLite;

	import flash.desktop.NativeApplication;
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.NativeWindowInitOptions;
	import flash.display.Screen;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	public class UpdateWindow extends ALNativeWindow
	{
		private var closeButton:Button = null;
		private var cancelButton:Button = null;
		private var updateButton:Button = null;
		private var skipButton:Button = null;
		
		private var mewFace:DisplayObject = null;
		private var noticeText:TextField = null;
		private var desTextField:TextField = null;
		private var bk:Sprite = null;
		private var uiScroll:UIScrollBar = null;
		
		private var loadingBar:MovieClip = null;
		
		private var newVersion:Number = NaN;
		
		public function UpdateWindow(initOptions:NativeWindowInitOptions)
		{
			super(initOptions);
		}
		
		override protected function init():void
		{
			drawBackground(500, 500);
			background.alpha = 0;
			this.stage.nativeWindow.alwaysInFront = true;
			super.init();
			this.stage.nativeWindow.x = (Screen.mainScreen.visibleBounds.width - this.stage.nativeWindow.width) / 2;
			this.stage.nativeWindow.y = (Screen.mainScreen.visibleBounds.height - this.stage.nativeWindow.height) / 2;
			TweenLite.to(background, .5, {alpha: 1});
			
			closeButton = ButtonFactory.CloseButton();
			addChild(closeButton);
			closeButton.x = background.x + background.width - closeButton.width;
			closeButton.y = 20;
			
			mewFace = new Bitmap(StaticAssets.MewFace());
			addChild(mewFace);
			mewFace.x = 30;
			mewFace.y = 30;
			
			noticeText = new TextField();
			noticeText.defaultTextFormat = new TextFormat(Widget.systemFont, 12, 0x3FB9F8, null, null, null, null, null, null, null, null, null, 8);
			noticeText.autoSize = TextFieldAutoSize.LEFT;
			noticeText.wordWrap = true;
			noticeText.width = background.width - (mewFace.x + mewFace.width + 20);
			noticeText.selectable = false;
			noticeText.mouseEnabled = false;
			noticeText.mouseWheelEnabled = false;
			addChild(noticeText);
			noticeText.x = mewFace.x + mewFace.width + 10;
			
			drawDescriptionBackground();
			
			desTextField = new TextField();
			desTextField.defaultTextFormat = new TextFormat(Widget.systemFont, 12, 0x4C4C4C, null, null, null, null, null, null, null, null, null, 8);
			desTextField.wordWrap = true;
			desTextField.multiline = true;
			desTextField.width = 418;
			
			cancelButton = ButtonFactory.WhiteButton();
			updateButton = ButtonFactory.UpdateButton();
			skipButton = ButtonFactory.SkipButton();
			
			closeButton.addEventListener(MouseEvent.CLICK, closeWindow);
			cancelButton.addEventListener(MouseEvent.CLICK, closeWindow);
			skipButton.addEventListener(MouseEvent.CLICK, closeWindow);
		}
		
		private function closeWindow(event:MouseEvent):void
		{
			if(event.target == skipButton){
				if(!isNaN(newVersion)){
					// 缓存记录新的版本号 下次不再提示更新
				}
			}
			this.stage.nativeWindow.close();
			MewSystem.app.updateWindow = null;
		}
		
		public function showData(version:Number, descriptionText:String):void
		{
			newVersion = version;
			var appDescription:XML = NativeApplication.nativeApplication.applicationDescriptor;
			var ns:Namespace = appDescription.namespace();
			noticeText.htmlText = "<font color=\"#3FB9F8\" size=\"16\"><b>Mew微博有新版本啦！</b></font>\n<font color=\"#3FB9F8\" size=\"13\">您当前的版本号为"
			 + appDescription.ns::versionNumber + "版本，是否更新到最新的" + version + "版本?</font>";
			noticeText.height = noticeText.textHeight;
			noticeText.y = mewFace.y + (mewFace.height - noticeText.height) / 2;
			
			addChild(bk);
			bk.x = (this.width - bk.width) / 2;
			bk.y = mewFace.y + mewFace.height + 15;
			
			desTextField.htmlText = descriptionText;
			desTextField.height = 300;
			addChild(desTextField);
			desTextField.x = bk.x + 5;
			desTextField.y = bk.y + 5;
			if(desTextField.maxScrollV > 1){
				uiScroll = new UIScrollBar();
				addChild(uiScroll);
				uiScroll.setSize(440, 300);
				uiScroll.x = desTextField.x + desTextField.width + 5;
				uiScroll.y = desTextField.y;
				uiScroll.scrollTarget = desTextField;
			}
			
			addChild(skipButton);
			addChild(cancelButton);
			addChild(updateButton);
			skipButton.x = bk.x;
			skipButton.y = bk.y + bk.height + 10;
			cancelButton.x = bk.x + bk.width - cancelButton.width;
			cancelButton.y = skipButton.y;
			updateButton.x = cancelButton.x - cancelButton.width - 10;
			updateButton.y = cancelButton.y;
		}
		
		override protected function drawBackground(w:int, h:int, position:String = null):void
		{
			super.drawBackground(w, h);
			background.addEventListener(MouseEvent.MOUSE_DOWN, dragLoginPanel);
		}
		
		private function dragLoginPanel(event:MouseEvent):void
		{
			this.stage.nativeWindow.startMove();
		}
		
		private function drawDescriptionBackground():void
		{
			if(!bk) bk = new Sprite();
			bk.graphics.clear();
			bk.graphics.lineStyle(1, 0x000000, .3);
			bk.graphics.beginFill(0xFFFFFF, 1.0);
			bk.graphics.drawRoundRect(0, 0, 450, 310, 12, 12);
			bk.graphics.endFill();
			bk.scrollRect = new Rectangle(0, 0, bk.width, bk.height);
		}
		
		override protected function dealloc(event:Event):void
		{
			if(uiScroll) uiScroll.scrollTarget = null;
			super.dealloc(event);
			closeButton.removeEventListener(MouseEvent.CLICK, closeWindow);
			cancelButton.removeEventListener(MouseEvent.CLICK, closeWindow);
			skipButton.removeEventListener(MouseEvent.CLICK, closeWindow);
			closeButton = null;
			cancelButton = null;
			skipButton = null;
			mewFace = null;
			noticeText = null;
			desTextField = null;
			bk = null;
			uiScroll = null;
			loadingBar = null;
		}
	}
}