package mew.modules {
	import mew.data.UserData;

	import resource.Resource;

	import widget.Widget;

	import com.iabel.core.UISprite;

	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	public class NameBox extends UISprite
	{
		public var userData:UserData = null;
		private var nameTextField:TextField = null;
		private var vicon:Bitmap = null;
		public function NameBox()
		{
			super();
		}
		public function create(trunck:int = 0):void
		{
			if(!nameTextField) nameTextField = new TextField();
			nameTextField.defaultTextFormat = Widget.usernameFormat;
			nameTextField.autoSize = TextFieldAutoSize.LEFT;
			nameTextField.mouseWheelEnabled = false;
			
			if(!userData) return;
			var nameStr:String = userData.username;
			if(trunck > 0 && nameStr.length > trunck) nameStr = nameStr.substr(0, trunck) + "...";
			nameTextField.text = nameStr;
			nameTextField.width = nameTextField.textWidth;
			nameTextField.height = nameTextField.textHeight;
			addChild(nameTextField);
			
			var w:int = nameTextField.textWidth;
			var h:int = nameTextField.textHeight;
			if(userData.isVerified){
				vicon = new (Resource.VSkin)();
				addChild(vicon);
				vicon.x = nameTextField.textWidth + nameTextField.x + 5;
				w += vicon.width;
				h = Math.max(vicon.height, h);
			}
			setSize(w, h);
		}
		
		override protected function dealloc(event:Event):void
		{
			super.dealloc(event);
			userData = null;
			nameTextField = null;
			vicon = null;
		}
	}
}