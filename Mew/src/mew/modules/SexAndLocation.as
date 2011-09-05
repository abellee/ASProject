package mew.modules {
	import resource.Resource;

	import widget.Widget;

	import com.iabel.core.UISprite;

	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	public class SexAndLocation extends UISprite
	{
		public var location:String = null;
		private var sexIcon:DisplayObject = null;
		private var localText:TextField = null;
		public function SexAndLocation()
		{
			super();
		}
		public function set sex(str:String):void
		{
			if(str == "f") sexIcon = new (Resource.FemaleSkin)();
			else if(str == "m") sexIcon = new (Resource.MaleSkin)();
		}
		public function create():void
		{
			location = location.length > 6 ? location.substr(0, 6) + "..." : location;
			localText = new TextField();
			localText.defaultTextFormat = Widget.wbSentTimeFormat;
			localText.autoSize = TextFieldAutoSize.LEFT;
			localText.text = location == "" ? "未知" : location;
			localText.selectable = false;
			localText.mouseEnabled = false;
			localText.width = localText.textWidth;
			localText.height = localText.textHeight;
			
			addChild(sexIcon);
			addChild(localText);
			
			localText.x = sexIcon.x + sexIcon.width + 2;
			var h:int = this.height;
			if(localText.height > sexIcon.height){
				h = localText.height;
				sexIcon.y = (localText.height - sexIcon.height) / 2;
			}else{
				h = sexIcon.height;
				localText.y = (sexIcon.height - localText.height) / 2;
			}
			
			setSize(this.width, h);
		}
		
		override protected function dealloc(event:Event):void
		{
			super.dealloc(event);
			location = null;
			sexIcon = null;
			localText = null;
		}
	}
}