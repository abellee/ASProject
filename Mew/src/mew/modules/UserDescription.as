package mew.modules
{
	import mew.events.MewEvent;
	import com.iabel.core.UISprite;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	import mew.data.UserData;
	
	import widget.Widget;
	
	public class UserDescription extends UISprite
	{
		public var userData:UserData = null;
		private var nameBox:NameBox = null;
		private var avatar:Avatar = null;
		private var blogText:TextField = null;
		private var blogLinkText:TextField = null;
		private var domainText:TextField = null;
		private var descriptionText:TextField = null;
		private var localAndSex:SexAndLocation = null;
		private var operationButtonGroup:OperationGroup = null;
		private var userCorrelationBtns:UserCorrelationButtons = null;
		public function UserDescription()
		{
			super();
			
			init();
		}
		private function init():void
		{
			domainText = new TextField();
			domainText.wordWrap = true;
			domainText.styleSheet = Widget.linkStyle;
			domainText.autoSize = TextFieldAutoSize.LEFT;
		}
		
		public function showData():void
		{
			if(!nameBox) nameBox = new NameBox();
			if(!avatar) avatar = new Avatar(100);
			if(!localAndSex) localAndSex = new SexAndLocation();
			if(!operationButtonGroup) operationButtonGroup = new OperationGroup();
			if(!userCorrelationBtns) userCorrelationBtns = new UserCorrelationButtons();
			
			avatar.userData = userData;
			avatar.loadAvatar(180);
			addChild(avatar);
			avatar.x = 10;
			
			nameBox.userData = userData;
			addChild(nameBox);
			nameBox.create();
			nameBox.x = avatar.width + avatar.x + 10;
			nameBox.y = avatar.y;
			
			var dir:String = userData.domain;
			if(!dir || dir == "") dir = userData.id;
			domainText.htmlText = "<a href='http://weibo.com/" + dir + "'>http://weibo.com/" + dir + "</a>";
			domainText.x = nameBox.x;
			domainText.y = nameBox.y + nameBox.height + 5;
			domainText.width = this.width - domainText.x;
			domainText.height = domainText.textHeight;
			addChild(domainText);
			
			localAndSex.location = userData.location;
			localAndSex.sex = userData.sex;
			localAndSex.create();
			addChild(localAndSex);
			localAndSex.x = nameBox.x;
			localAndSex.y = domainText.y + domainText.height + 5;
			
			var preChild:DisplayObject = null;
			preChild = avatar;
			if(userData.blogURL){
				if(!blogLinkText) blogLinkText = new TextField();
				blogLinkText.defaultTextFormat = Widget.normalFormat;
				blogLinkText.autoSize = TextFieldAutoSize.LEFT;
				blogLinkText.text = "博客:";
				blogLinkText.width = blogLinkText.textWidth;
				blogLinkText.height = blogLinkText.textHeight;
				
				if(!blogText) blogText = new TextField();
				blogText.styleSheet = Widget.linkStyle;
				blogText.wordWrap = true;
				blogText.autoSize = TextFieldAutoSize.LEFT;
				blogText.htmlText = "<a href='" + userData.blogURL + "'>" + userData.blogURL + "</a>";
				
				addChild(blogLinkText);
				addChild(blogText);
				blogLinkText.x = localAndSex.x;
				blogLinkText.y = localAndSex.y + localAndSex.height + 5;
				
				blogText.x = blogLinkText.x + blogLinkText.width + 5;
				blogText.y = blogLinkText.y;
				blogText.width = this.width - blogText.x;
				blogText.height = blogText.textHeight;
			}
			if(userData.description){
				if(!descriptionText) descriptionText = new TextField();
				descriptionText.defaultTextFormat = Widget.descriptionFormat;
				descriptionText.wordWrap = true;
				descriptionText.autoSize = TextFieldAutoSize.LEFT;
				addChild(descriptionText);
				descriptionText.x = preChild.x;
				descriptionText.y = preChild.y + preChild.height + 10;
				descriptionText.text = userData.description;
				descriptionText.width = this.width - descriptionText.x - 10;
				descriptionText.height = descriptionText.textHeight;
				preChild = descriptionText;
			}
			
			addChild(userCorrelationBtns);
			userCorrelationBtns.x = (this.width - userCorrelationBtns.width) / 2;
			userCorrelationBtns.y = preChild.y + preChild.height + 20;
			
			setSize(this.width, userCorrelationBtns.y + userCorrelationBtns.height);
			
			userCorrelationBtns.addEventListener(MewEvent.USER_FANS, bubbleEvent);
			userCorrelationBtns.addEventListener(MewEvent.USER_FOLLOW, bubbleEvent);
			userCorrelationBtns.addEventListener(MewEvent.USER_HOME, bubbleEvent);
		}

		private function bubbleEvent(event : MewEvent) : void
		{
			this.dispatchEvent(event.clone() as MewEvent);
		}
		
		public function showOperationButtons(operationGroup:OperationGroup):void
		{
			operationButtonGroup = operationGroup;
			addChild(operationButtonGroup);
			operationButtonGroup.x = this.width - operationButtonGroup.width;
			operationButtonGroup.y = nameBox.y;
		}
		
		override protected function dealloc(event:Event):void
		{
			super.dealloc(event);
			userData = null;
			nameBox = null;
			avatar = null;
			blogText = null;
			blogLinkText = null;
			domainText = null;
			descriptionText = null;
			localAndSex = null;
			operationButtonGroup = null;
			if(userCorrelationBtns){
				userCorrelationBtns.removeEventListener(MewEvent.USER_FANS, bubbleEvent);
				userCorrelationBtns.removeEventListener(MewEvent.USER_FOLLOW, bubbleEvent);
				userCorrelationBtns.removeEventListener(MewEvent.USER_HOME, bubbleEvent);
			}
			userCorrelationBtns = null;
		}
	}
}