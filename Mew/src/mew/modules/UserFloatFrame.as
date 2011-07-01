package mew.modules
{
	import com.iabel.core.ALSprite;
	
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	public class UserFloatFrame extends ALSprite
	{
		public var userAvatar:Avatar = null;
		public var nameBox:NameBox = null;
		private var areaText:TextField = null;
		private var fansNumText:TextField = null;
		public function UserFloatFrame()
		{
			super();
		}
		override protected function onAddedToStage(event:Event):void
		{
			super.onAddedToStage(event);
			
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
	}
}