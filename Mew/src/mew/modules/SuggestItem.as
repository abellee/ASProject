package mew.modules {
	import widget.Widget;

	import com.iabel.core.UISprite;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;

	/**
	 * @author abellee
	 */
	public class SuggestItem extends UISprite {
		private var bk:Sprite = null;
		private var txt:TextField = null;
		public function SuggestItem(str:String) {
			super();
			
			init(str);
		}
		private function init(str:String):void
		{
			drawBK();
			addChild(bk);
			bk.alpha = 0;
			
			txt = new TextField();
			txt.autoSize = TextFieldAutoSize.LEFT;
			txt.width = 140;
			txt.selectable = false;
			txt.mouseEnabled = false;
			txt.defaultTextFormat = Widget.normalFormat;
			txt.text = str;
			txt.height = txt.textHeight;
			addChild(txt);
			txt.y = (30 - txt.height) / 2;
		}
		private function drawBK():void
		{
			bk = new Sprite();
			bk.graphics.beginFill(0x000000, .5);
			bk.graphics.drawRect(0, 0, 140, 30);
			bk.graphics.endFill();
		}
		public function get label():String
		{
			return txt.text;
		}
		public function showBackground():void
		{
			txt.defaultTextFormat = Widget.normalWhiteFormat;
			bk.alpha = 1;
		}
		public function hideBackground():void
		{
			txt.defaultTextFormat = Widget.normalFormat;
			bk.alpha = 0;
		}
		
		override protected function dealloc(event:Event):void
		{
			super.dealloc(event);
			bk = null;
			txt = null;
		}
	}
}
