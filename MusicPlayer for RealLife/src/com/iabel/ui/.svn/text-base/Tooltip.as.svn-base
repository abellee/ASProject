package com.iabel.ui
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	public class Tooltip extends Sprite
	{
		private var textField:TextField = new TextField();
		private var background:Sprite = new Sprite();
		public function Tooltip(text:String)
		{
			super();
			
			this.mouseEnabled = false;
			this.mouseChildren = false;
			
			textField.defaultTextFormat = new TextFormat(null, 12, 0x000000, false);
			textField.autoSize = TextFieldAutoSize.LEFT;
			textField.selectable = false;
			textField.mouseEnabled = false;
			textField.mouseWheelEnabled = false;
			textField.text = text;
			
			draw();
			
			addChild(textField);
			textField.x = 2;
			textField.y = 2;
		}
		private function draw():void{
			
			background.graphics.beginFill(0xffffff, 1.0);
			background.graphics.drawRect(0, 0, textField.textWidth + 8, textField.textHeight + 8);
			background.graphics.endFill();
			addChild(background);
			
		}
		public function get toolTip():String{
			
			return textField.text;
			
		}
		public function clearSelf():void{
			
			this.removeEventListener(Event.REMOVED_FROM_STAGE, clearSelf);
			if(textField && this.contains(textField)){
				
				this.removeChild(textField);
				
			}
			if(background && this.contains(background)){
				
				background.graphics.clear();
				removeChild(background);
				
			}
			textField = null;
			background = null;
			
		}
	}
}