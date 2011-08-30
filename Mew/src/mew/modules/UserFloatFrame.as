package mew.modules
{
	import com.iabel.core.UISprite;
	
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	public class UserFloatFrame extends UISprite
	{
		public var userAvatar:Avatar = null;
		public var nameBox:NameBox = null;
		private var areaText:TextField = null;
		private var fansNumText:TextField = null;
		public function UserFloatFrame()
		{
			super();
		}
		override protected function onAdded(event:Event):void
		{
			super.onAdded(event);
			addChild(areaText);
			addChild(fansNumText);
		}
		public function init():void
		{
			areaText = new TextField();
			areaText.defaultTextFormat = null; // 待定
			areaText.autoSize = TextFieldAutoSize.LEFT;
			areaText.mouseWheelEnabled = false;
			
			fansNumText = new TextField();
			fansNumText.defaultTextFormat = null; // 待定
			fansNumText.autoSize = TextFieldAutoSize.LEFT;
			fansNumText.mouseWheelEnabled = false;
		}
		override protected function dealloc(event:Event):void
		{
			super.dealloc(event);
			userAvatar = null;
			nameBox = null;
			areaText = null;
			fansNumText = null;
		}
	}
}