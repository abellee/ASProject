package mew.windows {
	import system.MewSystem;
	import fl.controls.Button;

	import mew.factory.ButtonFactory;

	import widget.Widget;

	import flash.display.NativeWindowInitOptions;
	import flash.display.Screen;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;

	/**
	 * @author Abel Lee
	 */
	public class Alert extends ALNativeWindow {
		private var confirmButton:Button = null;
		private var textField:TextField = null;
		public function Alert(initOptions : NativeWindowInitOptions) {
			super(initOptions);
		}
		
		override protected function init():void
		{
			drawBackground(240, 140);
			this.stage.nativeWindow.alwaysInFront = true;
			this.stage.nativeWindow.width = background.width + 20;
			this.stage.nativeWindow.height = background.height + 20;
			this.stage.nativeWindow.x = (Screen.mainScreen.visibleBounds.width - this.stage.nativeWindow.width) / 2;
			this.stage.nativeWindow.y = (Screen.mainScreen.visibleBounds.height - this.stage.nativeWindow.height) / 2;
			
			textField = new TextField();
			textField.defaultTextFormat = Widget.alertFormat;
			textField.autoSize = TextFieldAutoSize.LEFT;
			textField.wordWrap = true;
			textField.selectable = false;
			textField.mouseEnabled = false;
			
			confirmButton = ButtonFactory.WhiteButton();
			confirmButton.label = "确 定";
			confirmButton.setStyle("textFormat", Widget.normalFormat);
			confirmButton.width = 60;
			confirmButton.addEventListener(MouseEvent.CLICK, closeAlert);
		}
		
		private function closeAlert(event:MouseEvent):void
		{
			MewSystem.closeAlert();
		}
		
		public function show(str:String):void
		{
			textField.text = str;
			textField.width = 200;
			textField.height = textField.textHeight;
			addChild(textField);
			textField.x = (background.width - textField.width) / 2 + 10;
			textField.y = (background.height - textField.height) / 2 - 5;
			addChild(confirmButton);
			confirmButton.x = (background.width - confirmButton.width) / 2 + 10;
			confirmButton.y = background.height - confirmButton.height - 5;
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
		
		override protected function dealloc(event:Event):void
		{
			whiteBackground.removeEventListener(MouseEvent.MOUSE_DOWN, dragLoginPanel);
			super.dealloc(event);
			confirmButton.removeEventListener(MouseEvent.CLICK, closeAlert);
			confirmButton = null;
			textField = null;
		}
	}
}
