package mew.modules
{
	import com.iabel.core.UISprite;
	import com.yahoo.astra.fl.containers.HBoxPane;
	import com.yahoo.astra.layout.modes.VerticalAlignment;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	import mew.utils.StringUtils;
	
	import widget.Widget;
	
	public class TimeAndFrom extends UISprite
	{
		public var time:Date = null;
		public var from:String = null;
		private var timeTextField:TextField = null;
		private var fromTextField:TextField = null;
		public function TimeAndFrom()
		{
			super();
		}
		public function create():void
		{
			timeTextField = new TextField();
			timeTextField.autoSize = TextFieldAutoSize.LEFT;
			timeTextField.defaultTextFormat = Widget.wbSentTimeFormat;
			timeTextField.mouseWheelEnabled = false;
			timeTextField.mouseEnabled = false;
			
			fromTextField = new TextField();
			fromTextField.autoSize = TextFieldAutoSize.LEFT;
			fromTextField.defaultTextFormat = Widget.wbFromFormat;
			fromTextField.mouseWheelEnabled = false;
			
			timeTextField.text = StringUtils.transformTime(time);
			timeTextField.width = timeTextField.textWidth;
			timeTextField.height = timeTextField.textHeight;
			fromTextField.htmlText = "来自 <font color=\"" + Widget.fromColor + "\">" + from + "</font>";
			fromTextField.width = fromTextField.textWidth;
			fromTextField.height = fromTextField.textHeight;
			
			addChild(timeTextField);
			addChild(fromTextField);
			
			fromTextField.x = timeTextField.x + timeTextField.width + 5;
			
			var w:int = fromTextField.x + fromTextField.textWidth;
			var h:int = Math.max(timeTextField.height, fromTextField.height);
			setSize(w, h);
		}
		override protected function dealloc(event:Event):void
		{
			super.dealloc(event);
			time = null;
			from = null;
			timeTextField = null;
			fromTextField = null;
		}
	}
}