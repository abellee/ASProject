package mew.modules {
	import resource.Resource;

	import widget.Widget;

	import com.iabel.core.UISprite;

	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;

	/**
	 * @author Abel Lee
	 */
	public class UnreadTip extends UISprite {
		private var bk:Bitmap = null;
		private var num:TextField = null;
		public function UnreadTip(value:int) {
			super();
			
			this.mouseChildren = false;
			this.mouseEnabled = false;
			num = new TextField();
			num.defaultTextFormat = Widget.unreadFormat;
			num.selectable = false;
			num.autoSize = TextFieldAutoSize.LEFT;
			num.mouseEnabled = false;
			num.width = num.textWidth;
			num.height = num.textHeight;
			num.text = value + "";
			
			bk = new Resource.UnreadSkin();
			addChild(bk);
			
			addChild(num);
			num.x = (bk.width - num.width) / 2 - 1;
			num.y = (bk.height - num.height) / 2 + 1;
		}
		public function set label(str:String):void
		{
			num.text = str;
			num.x = (bk.width - num.width) / 2 - 1;
			num.y = (bk.height - num.height) / 2 + 1;
		}
		public function get label():String
		{
			return num.text;
		}
		
		override protected function dealloc(event:Event):void
		{
			super.dealloc(event);
			
			if(bk && bk.bitmapData) bk.bitmapData.dispose();
			bk = null;
			num = null;
		}
	}
}
