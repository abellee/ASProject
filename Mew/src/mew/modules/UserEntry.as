package mew.modules
{
	import com.iabel.core.UISprite;
	import com.sina.microblog.data.MicroBlogUser;
	
	import flash.display.Shape;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	import mew.data.UserData;
	
	import system.MewSystem;
	
	import widget.Widget;
	
	public class UserEntry extends UISprite
	{
		public var userData:UserData = null;
		protected var nameBox:NameBox = null;
		private var userAvatar:Avatar = null;
		private var fansNumText:TextField = null;
		private var sexAndLocation:SexAndLocation = null;
		private var background:Shape = null;
		public function UserEntry()
		{
			super();
		}
		
		public function initStatus(user:MicroBlogUser):void
		{
			userData = MewSystem.app.dataCache.getUserDataCache(user);
			
			userAvatar = new Avatar();
			userAvatar.userData = userData;
			userAvatar.loadAvatar();
			addChild(userAvatar);
			
			nameBox = new NameBox();
			nameBox.userData = userData;
			nameBox.create();
			addChild(nameBox);
			
			sexAndLocation = new SexAndLocation();
			sexAndLocation.location = userData.location;
			sexAndLocation.sex = userData.sex;
			sexAndLocation.create();
			addChild(sexAndLocation);
			
			fansNumText = new TextField();
			fansNumText.defaultTextFormat = Widget.wbSentTimeFormat;
			fansNumText.autoSize = TextFieldAutoSize.LEFT;
			fansNumText.text = "粉丝 " + userData.fansNum;
			fansNumText.selectable = false;
			fansNumText.mouseEnabled = false;
			fansNumText.width = fansNumText.textWidth;
			fansNumText.height = fansNumText.textHeight;
			addChild(fansNumText);
			
			userAvatar.x = (this.width - userAvatar.width) / 2;
			userAvatar.y = 5;
			nameBox.x = (this.width - nameBox.width) / 2;
			nameBox.y = userAvatar.y + userAvatar.height + 5;
			sexAndLocation.x = (this.width - sexAndLocation.width) / 2;
			sexAndLocation.y = nameBox.y + nameBox.height + 5;
			fansNumText.x = (this.width - fansNumText.width) / 2;
			fansNumText.y = sexAndLocation.y + sexAndLocation.height + 5;
			
			setSize(this.width, fansNumText.y + fansNumText.height + 5);
			drawBorder();
		}
		
		private function drawBorder():void
		{
			if(!background) background = new Shape();
			background.graphics.clear();
			background.graphics.lineStyle(1, 0x000000);
			background.graphics.beginFill(0x000000, 0);
			background.graphics.drawRect(0, 0, this.width-1, this.height-1);
			background.graphics.endFill();
		}
	}
}