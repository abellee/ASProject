package mew.modules
{
	import com.iabel.core.UISprite;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	import widget.Widget;
	
	public class ToolTip extends UISprite
	{
		private var label:TextField = null;
		private var bk:Sprite = null;
		public function ToolTip()
		{
			super();
		}
		
		public function show():void
		{
			addChild(label);
			label.x = 5;
			label.y = 5;
		}
		
		public function set text(str:String):void
		{
			if(!label) label = new TextField();
			label.autoSize = TextFieldAutoSize.LEFT;
			label.defaultTextFormat = Widget.normalFormat;
			label.text = str;
			label.width = label.textWidth;
			label.height = label.textHeight;
			label.mouseEnabled = false;
			label.selectable = false;
			label.mouseWheelEnabled = false;
			drawBorder();
		}
		
		public function get text():String
		{
			if(!label) return "";
			return label.text;
		}
		
		private function drawBorder():void
		{
			if(!bk) bk = new Sprite();
			bk.graphics.clear();
			bk.graphics.beginFill(0xffffff, 1.0);
			bk.graphics.drawRect(0, 0, label.width + 10, label.height + 10);
			bk.graphics.endFill();
			Widget.widgetGlowFilter(bk, 5, 5);
			addChildAt(bk, 0);
		}
		
		override protected function dealloc(event:Event):void
		{
			super.dealloc(event);
			label = null;
			bk = null;
		}
	}
}