package mew.modules
{
	import com.iabel.core.UISprite;
	import com.yahoo.astra.fl.containers.HBoxPane;
	import com.yahoo.astra.layout.modes.VerticalAlignment;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	import mew.data.UserData;
	import mew.factory.StaticAssets;
	
	import widget.Widget;
	
	public class NameBox extends UISprite
	{
		public var userData:UserData = null;
		private var nameTextField:TextField = null;
		private var vicon:Bitmap = null;
		public function NameBox()
		{
			super();
		}
		public function create():void
		{
			if(!nameTextField) nameTextField = new TextField();
			nameTextField.defaultTextFormat = Widget.usernameFormat;
			nameTextField.autoSize = TextFieldAutoSize.LEFT;
			nameTextField.mouseWheelEnabled = false;
			
			nameTextField.text = userData.username;
			nameTextField.width = nameTextField.textWidth;
			nameTextField.height = nameTextField.textHeight;
			addChild(nameTextField);
			
			var w:int = nameTextField.textWidth;
			var h:int = nameTextField.textHeight;
			if(userData.isVerified){
				vicon = new Bitmap(StaticAssets.YellowVIcon);
				addChild(vicon);
				vicon.x = nameTextField.textWidth + nameTextField.x + 10;
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