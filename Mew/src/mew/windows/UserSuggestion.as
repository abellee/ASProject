package mew.windows {
	import mew.communication.RemoteConnecting;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFieldType;
	import widget.Widget;
	import system.MewSystem;
	import mew.factory.ButtonFactory;
	import fl.controls.Button;

	import resource.Resource;

	import flash.display.Bitmap;
	import flash.display.NativeWindowInitOptions;
	import flash.display.Screen;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;

	/**
	 * @author Abel Lee
	 */
	public class UserSuggestion extends ALNativeWindow implements IUserSubmmit {
		private var bitmapBackground:Bitmap = null;
		private var closeButton:Button = null;
		private var submitButton:Button = null;
		private var textArea:TextField = null;
		private var titleStr:String = null;
		private var titleField:TextField = null;
		private var remoteConnector:RemoteConnecting = null;
		public function UserSuggestion(initOptions : NativeWindowInitOptions, title:String) {
			titleStr = title;
			super(initOptions);
		}
		
		override protected function init():void
		{
			drawBackground(420, 510);
			this.stage.nativeWindow.alwaysInFront = true;
			this.stage.nativeWindow.width = background.width + 20;
			this.stage.nativeWindow.height = background.height + 20;
			this.stage.nativeWindow.x = (Screen.mainScreen.visibleBounds.width - this.stage.nativeWindow.width) / 2;
			this.stage.nativeWindow.y = (Screen.mainScreen.visibleBounds.height - this.stage.nativeWindow.height) / 2;
			
			bitmapBackground = new (Resource.UserSuggestionBackground)();
			addChild(bitmapBackground);
			bitmapBackground.x = 40;
			bitmapBackground.y = 40;
			Widget.widgetGlowFilter(bitmapBackground, 5, 5);
			
			closeButton = ButtonFactory.CloseButton();
			addChild(closeButton);
			closeButton.x = background.width - closeButton.width;
			closeButton.y = 25;
			closeButton.addEventListener(MouseEvent.CLICK, closeWindow);
			
			submitButton = ButtonFactory.WhiteButton();
			submitButton.setStyle("textFormat", Widget.usernameFormat);
			submitButton.label = "提 交";
			submitButton.width = 60;
			addChild(submitButton);
			submitButton.x = bitmapBackground.x + (bitmapBackground.width - submitButton.width) / 2;
			submitButton.y = bitmapBackground.y + (bitmapBackground.height - submitButton.height - 120);
			submitButton.addEventListener(MouseEvent.CLICK, submitContent);
			
			textArea = new TextField();
			textArea.wordWrap = true;
			textArea.type = TextFieldType.INPUT;
			textArea.defaultTextFormat = new TextFormat(Widget.systemFont, 13, Widget.mainColor, null, null, null, null, null, null, null, null, null, 14);
			textArea.width = bitmapBackground.width - 83;
			textArea.height = bitmapBackground.height - 250;
			textArea.x = bitmapBackground.x + 47;
			textArea.y = bitmapBackground.y + 59;
			addChild(textArea);
			
			titleField = new TextField();
			titleField.autoSize = TextFieldAutoSize.LEFT;
			titleField.defaultTextFormat = new TextFormat(Widget.systemFont, 16, Widget.mainColor, true);
			titleField.selectable = false;
			titleField.mouseEnabled = false;
			titleField.text = titleStr;
			titleField.width = titleField.textWidth;
			titleField.height = titleField.textHeight;
			addChild(titleField);
			titleField.x = bitmapBackground.x + (bitmapBackground.width - titleField.width) / 2;
			titleField.y = bitmapBackground.y + 20;
		}
		
		private function closeWindow(event:MouseEvent):void
		{
			if(titleStr == "Bug提交") MewSystem.app.closeBugSubmitWindow();
			else MewSystem.app.closeUserSuggestionWindow();
		}
		
		override protected function drawBackground(w:int, h:int, position:String = null):void
		{
			super.drawBackground(w, h);
			addChildAt(whiteBackground, 1);
			whiteBackground.addEventListener(MouseEvent.MOUSE_DOWN, dragLoginPanel);
		}
		
		private function submitContent(event:MouseEvent):void
		{
			if(!remoteConnector) remoteConnector = new RemoteConnecting();
			remoteConnector.target = this;
			var str:String = textArea.text;
			str = str.replace(/\s/g, "");
			container.mouseChildren = false;
			MewSystem.showCycleLoading(container);
			if(titleStr == "Bug提交") remoteConnector.submitBugs(str);
			else remoteConnector.submitSuggestion(str);
		}
		
		public function showSubmitResult(str:String):void
		{
			container.mouseChildren = true;
			textArea.text = "";
			MewSystem.removeCycleLoading(container);
			MewSystem.show(str);
		}
		
		private function dragLoginPanel(event:MouseEvent):void
		{
			this.stage.nativeWindow.startMove();
		}
		
		override protected function dealloc(event:Event):void
		{
			whiteBackground.removeEventListener(MouseEvent.MOUSE_DOWN, dragLoginPanel);
			super.dealloc(event);
			if(bitmapBackground) bitmapBackground.bitmapData.dispose();
			bitmapBackground = null;
			if(closeButton) closeButton.removeEventListener(MouseEvent.CLICK, closeWindow);
			closeButton = null;
			if(submitButton) submitButton.removeEventListener(MouseEvent.CLICK, submitContent);
			submitButton = null;
			textArea = null;
			titleStr = null;
			titleField = null;
			if(remoteConnector) remoteConnector.destroy();
			remoteConnector = null;
		}
	}
}
