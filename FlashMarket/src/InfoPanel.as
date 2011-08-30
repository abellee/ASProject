package
{
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	public class InfoPanel extends Sprite
	{
		private var textField:TextField = null;
		private var background:Shape = null;
		public function InfoPanel()
		{
			super();
			
			addEventListener(Event.REMOVED_FROM_STAGE, dealloc);
		}
		
		public function initInfoPanel(content:String, arr:Array):void
		{
			if(!textField) textField = new TextField();
			textField.autoSize = TextFieldAutoSize.LEFT;
			textField.wordWrap = true;
			textField.mouseWheelEnabled = false;
			textField.width = 220;
			textField.htmlText = content;
			addChild(textField);
			
			var len:int = arr.length;
			for(var i:int = 0; i<len; i++){
				var imageItem:ImageItem = new ImageItem();
				imageItem.initImage(arr[i].url, arr[i].path);
				addChild(imageItem);
				imageItem.x = (i % 3) * 70 + 10;
				imageItem.y = int(i / 3) * 70 + textField.y + textField.textHeight + 10;
			}
			
			var line:int = Math.ceil((this.numChildren - 1) / 3);
			line = line < 0 ? 0 : line;
			if(!background) background = new Shape();
			background.graphics.beginFill(0x7800aa);
			background.graphics.drawRect(0, 0, 220, line * 70 + textField.textHeight + (line - 1) * 10);
			background.graphics.endFill();
			addChildAt(background, 0);
		}
		
		private function dealloc(event:Event):void
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, dealloc);
			while(this.numChildren) this.removeChildAt(0);
			this.filters = null;
		}
	}
}