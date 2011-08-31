package mew.modules {
	import widget.Widget;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextField;
	import flash.display.Sprite;
	import com.iabel.core.UISprite;

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
			txt.width = 100;
			txt.selectable = false;
			txt.mouseEnabled = false;
			txt.defaultTextFormat = Widget.normalFormat;
			txt.text = str;
			txt.height = txt.textHeight;
			addChild(txt);
			txt.x = 10;
			txt.y = (30 - txt.height) / 2;
		}
		private function drawBK():void
		{
			bk = new Sprite();
			bk.graphics.beginFill(0x000000, .5);
			bk.graphics.drawRect(0, 0, 100, 30);
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
	}
}
