package mew.modules {
	import fl.controls.Button;

	import mew.data.UserData;
	import mew.factory.ButtonFactory;

	import system.MewSystem;

	import widget.Widget;

	import com.iabel.core.UISprite;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;

	/**
	 * @author abellee
	 */
	public class FloatUserInfo extends UISprite {
		private var avatar : Avatar;
		private var nameBox : NameBox;
		private var desTextField : TextField;
		private var sexAndLocation : SexAndLocation;
		private var followButton : Button;
		private var atButton : Button;
		private var bk : Sprite;
		private var userData : UserData;
		private var weiboCorrelation : TextField;
		public function FloatUserInfo() {
			super();
			
			init();
		}
		private function init():void
		{
			avatar = new Avatar();
			nameBox = new NameBox();
			sexAndLocation = new SexAndLocation();
			followButton = ButtonFactory.FollowButton();
			atButton = ButtonFactory.AtButton();
			
			weiboCorrelation = new TextField();
			weiboCorrelation.defaultTextFormat = Widget.normalFormat;
			weiboCorrelation.wordWrap = true;
			weiboCorrelation.autoSize = TextFieldAutoSize.LEFT;
			
			bk = MewSystem.getRoundRect(300, 150, 0x000000, 0xffffff, 1.0, 1, .5);
			Widget.widgetGlowFilter(bk);
			
			addChild(bk);
		}
		
		public function initData(ud:UserData):void
		{
			userData = ud;
			avatar.userData = ud;
			avatar.loadAvatar(50);
			
			nameBox.userData = ud;
			nameBox.create();
			
			if(!ud) return;
			sexAndLocation.location = ud.location;
			sexAndLocation.sex = ud.sex;
			sexAndLocation.create();
			
			addChild(avatar);
			avatar.x = 10;
			avatar.y = 10;
			
			addChild(nameBox);
			nameBox.x = avatar.x + avatar.width + 5;
			nameBox.y = avatar.y;
			
			addChild(sexAndLocation);
			sexAndLocation.x = nameBox.x;
			sexAndLocation.y = nameBox.y + nameBox.height + 5;
			
			weiboCorrelation.htmlText = "<font color=\"" + Widget.linkColor + "\">关注</font>" + (ud.followNum >= 100000 ? int(ud.followNum / 10000) + "万" : ud.followNum) +
			 "	<font color=\"" + Widget.linkColor +"\">粉丝</font>" + (ud.fansNum >= 100000 ? int(ud.fansNum / 10000) + "万" : ud.fansNum) +
			 "	<font color=\"" + Widget.linkColor + "\">微博</font>" + (ud.tweetsNum >= 100000 ? int(ud.tweetsNum / 10000) + "万" : ud.tweetsNum);
			addChild(weiboCorrelation);
			weiboCorrelation.x = sexAndLocation.x;
			weiboCorrelation.y = sexAndLocation.height + sexAndLocation.y + 5;
			weiboCorrelation.width = 290 - weiboCorrelation.x;
			weiboCorrelation.height = weiboCorrelation.textHeight;
			
			if(ud.description && ud.description != ""){
				var str:String = ud.description.length > 30 ? ud.description.substr(0, 30) + "..." : ud.description;
				desTextField = new TextField();
				desTextField.defaultTextFormat = Widget.descriptionFormat;
				desTextField.autoSize = TextFieldAutoSize.LEFT;
				desTextField.wordWrap = true;
				desTextField.text = str;
				addChild(desTextField);
				desTextField.x = avatar.x;
				desTextField.y = weiboCorrelation.y + weiboCorrelation.height + 5;
				desTextField.width = 280;
				desTextField.height = desTextField.textHeight;
			}
		}
		
		override protected function dealloc(event:Event):void
		{
			super.dealloc(event);
			
			avatar = null;
			nameBox = null;
			desTextField = null;
			sexAndLocation = null;
			followButton = null;
			atButton = null;
			bk = null;
			userData = null;
			weiboCorrelation = null;
		}
	}
}
