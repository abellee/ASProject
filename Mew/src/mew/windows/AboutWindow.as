package mew.windows {
	import resource.Resource;
	import fl.controls.Button;

	import mew.factory.ButtonFactory;
	import mew.factory.StaticAssets;

	import system.MewSystem;

	import widget.Widget;

	import com.greensock.TweenLite;

	import flash.desktop.NativeApplication;
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.NativeWindowInitOptions;
	import flash.display.Screen;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	public class AboutWindow extends ALNativeWindow
	{
		private var mewFace:DisplayObject = null;
		private var mewFont:DisplayObject = null;
		private var mewVersion:TextField = null;
		private var descriptionText:TextField = null;
		private var closeButton:Button = null;
		private var bk:Sprite = null;
		public function AboutWindow(initOptions:NativeWindowInitOptions)
		{
			super(initOptions);
			
		}
		override protected function init():void
		{
			drawBackground(400, 300);
			this.stage.nativeWindow.alwaysInFront = true;
			this.stage.nativeWindow.width = background.width + 20;
			this.stage.nativeWindow.height = background.height + 20;
			this.stage.nativeWindow.x = (Screen.mainScreen.visibleBounds.width - this.stage.nativeWindow.width) / 2;
			this.stage.nativeWindow.y = (Screen.mainScreen.visibleBounds.height - this.stage.nativeWindow.height) / 2;
			
			closeButton = ButtonFactory.CloseButton();
			
			mewFace = new (Resource.MewFace)();
			mewFont = new (Resource.MewFont)();
			
			var appDescription:XML = NativeApplication.nativeApplication.applicationDescriptor;
			var ns:Namespace = appDescription.namespace();
			mewVersion = new TextField();
			mewVersion.defaultTextFormat = new TextFormat(Widget.systemFont, 12, 0x3FB9F8, true);
			mewVersion.autoSize = TextFieldAutoSize.LEFT;
			mewVersion.text = "微博" + appDescription.ns::versionNumber;
			mewVersion.width = mewVersion.textWidth;
			mewVersion.height = mewVersion.textHeight;
			mewVersion.selectable = false;
			mewVersion.mouseEnabled = false;
			
			drawDescriptionBackground();
			
			descriptionText = new TextField();
			descriptionText.wordWrap = true;
			descriptionText.multiline = true;
			descriptionText.defaultTextFormat = new TextFormat(Widget.systemFont, 12, 0x4C4C4C, null, null, null, null, null, null, null, null, null, 8);
			var des:String = '<p align="center"><b>版权归Abel Lee所有<br>Copyright © 2011 All Rights Reserved.</p><b><font color="#3FB9F8"><a href="http://mew.iabel.com">Mew微博官方网站</a></font><br>Developer: </b><font color="#3FB9F8"><a href="http://weibo.com/abellee"><b>Abel Lee</b></a></font><br><b>Designer: </b><font color="#3FB9F8"><a href="http://weibo.com/sll1004"><b>沈-叉叉</b></a></font>';
			descriptionText.htmlText = des;
			descriptionText.autoSize = TextFieldAutoSize.LEFT;
			descriptionText.width = bk.width - 20;
			descriptionText.height = descriptionText.textHeight;
			descriptionText.mouseWheelEnabled = false;
			
			bk.addChild(descriptionText);
			descriptionText.x = 8;
			descriptionText.y = 8;
			addChild(bk);
			
			addChild(mewFace);
			addChild(mewFont);
			addChild(mewVersion);
			addChild(closeButton);
			
			closeButton.x = this.width - closeButton.width - 20;
			closeButton.y = 20;
			mewFace.x = (this.width - mewFace.width) / 2;
			mewFace.y = 40;
			mewFont.x = (this.width - mewFont.width) / 2 - mewVersion.width / 2 - 2;
			mewFont.y = mewFace.y + mewFace.height + 10;
			mewVersion.x = mewFont.x + mewFont.width + 2;
			mewVersion.y = mewFont.y + mewFont.height - mewVersion.height;
			bk.x = (this.width - bk.width) / 2;
			bk.y = mewVersion.y + mewVersion.height + 10;
			
			closeButton.addEventListener(MouseEvent.CLICK, closeWindow);
		}
		
		private function closeWindow(event:MouseEvent):void
		{
			this.stage.nativeWindow.close();
			MewSystem.app.aboutWindow = null;
		}
		
		override protected function drawBackground(w:int, h:int, position:String = null):void
		{
			super.drawBackground(w, h);
			addChildAt(whiteBackground, 1);
			whiteBackground.addEventListener(MouseEvent.MOUSE_DOWN, dragLoginPanel);
		}
		
		private function dragLoginPanel(event:MouseEvent):void
		{
			this.stage.nativeWindow.startMove();
		}
		
		private function drawDescriptionBackground():void
		{
			if(!bk) bk = new Sprite();
			bk.graphics.clear();
			bk.graphics.lineStyle(1, 0x000000, .5);
			bk.graphics.beginFill(0xFFFFFF, 1.0);
			bk.graphics.drawRoundRect(0, 0, 250, 120, 12, 12);
			bk.graphics.endFill();
			bk.scrollRect = new Rectangle(0, 0, bk.width, bk.height);
		}
		
		override protected function dealloc(event:Event):void
		{
			whiteBackground.removeEventListener(MouseEvent.MOUSE_DOWN, dragLoginPanel);
			super.dealloc(event);
			closeButton.removeEventListener(MouseEvent.CLICK, closeWindow);
			bk = null;
			mewFace = null;
			mewFont = null;
			mewVersion = null;
			descriptionText = null;
			closeButton = null;
		}
	}
}