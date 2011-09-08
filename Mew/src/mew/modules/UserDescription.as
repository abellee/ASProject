package mew.modules {
	import flash.events.MouseEvent;
	import fl.controls.Button;

	import mew.data.UserData;
	import mew.events.MewEvent;
	import mew.factory.ButtonFactory;

	import system.MewSystem;

	import widget.Widget;

	import com.iabel.core.UISprite;
	import com.iabel.util.DashLine;
	import com.sina.microblog.data.MicroBlogUsersRelationship;
	import com.sina.microblog.events.MicroBlogErrorEvent;
	import com.sina.microblog.events.MicroBlogEvent;

	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
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
		private var dashLine:Bitmap = null;
		private var relationshipButton:Button = null;
		private var isFollow:Boolean = false;
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
			if(!userCorrelationBtns) userCorrelationBtns = new UserCorrelationButtons(userData);
			
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
			
			var bd:DashLine = new DashLine(this.width, 1);
			bd.drawDashLine(3);
			dashLine = new Bitmap(bd);
			dashLine.alpha = .3;
			addChild(dashLine);
			dashLine.y = this.height - 5;
			
			if(userData.id != MewSystem.app.userData.id){
				if(!operationButtonGroup) operationButtonGroup = new OperationGroup();
				addChild(operationButtonGroup);
				operationButtonGroup.userData = userData;
				operationButtonGroup.showAtButton();
//				operationButtonGroup.showMessageButton();
				operationButtonGroup.calculateSize();
				operationButtonGroup.x = this.width - operationButtonGroup.width - 10;
				operationButtonGroup.y = nameBox.y;
				checkRelationShip();
			}
			
			userCorrelationBtns.addEventListener(MewEvent.USER_FANS, bubbleEvent);
			userCorrelationBtns.addEventListener(MewEvent.USER_FOLLOW, bubbleEvent);
			userCorrelationBtns.addEventListener(MewEvent.USER_HOME, bubbleEvent);
		}
		
		private function checkRelationShip():void
		{
			MewSystem.microBlog.addEventListener(MicroBlogEvent.CHECK_IS_FOLLOWING_RESULT, checkIsFollowingResult);
			MewSystem.microBlog.addEventListener(MicroBlogErrorEvent.CHECK_IS_FOLLOWING_ERROR, checkIsFollowingError);
			MewSystem.microBlog.checkIsFollowing(userData.id, userData.username);
		}

		private function checkIsFollowingError(event : MicroBlogErrorEvent) : void
		{
			MewSystem.microBlog.removeEventListener(MicroBlogEvent.CHECK_IS_FOLLOWING_RESULT, checkIsFollowingResult);
			MewSystem.microBlog.removeEventListener(MicroBlogErrorEvent.CHECK_IS_FOLLOWING_ERROR, checkIsFollowingError);
		}

		private function checkIsFollowingResult(event : MicroBlogEvent) : void
		{
			MewSystem.microBlog.removeEventListener(MicroBlogEvent.CHECK_IS_FOLLOWING_RESULT, checkIsFollowingResult);
			MewSystem.microBlog.removeEventListener(MicroBlogErrorEvent.CHECK_IS_FOLLOWING_ERROR, checkIsFollowingError);
			var relation:MicroBlogUsersRelationship = event.result as MicroBlogUsersRelationship;
			if(relation.target.isFollowedBy){
				isFollow = true;
				relationshipButton = ButtonFactory.MinusButton();
			}else{
				isFollow = false;
				relationshipButton = ButtonFactory.FollowButton();
			}
			addChild(relationshipButton);
			relationshipButton.x = operationButtonGroup.x;
			relationshipButton.y = operationButtonGroup.y + operationButtonGroup.height;
			relationshipButton.addEventListener(MouseEvent.CLICK, doFollow);
		}

		private function doFollow(event : MouseEvent) : void
		{
			if(isFollow){
				MewSystem.microBlog.addEventListener(MicroBlogEvent.CANCEL_FOLLOWING_RESULT, onCancelFollowResult);
				MewSystem.microBlog.addEventListener(MicroBlogErrorEvent.CANCEL_FOLLOWING_ERROR, onCancelFollowError);
				MewSystem.microBlog.cancelFollowing(userData.id);
			}else{
				MewSystem.microBlog.addEventListener(MicroBlogEvent.FOLLOW_RESULT, onFollowResult);
				MewSystem.microBlog.addEventListener(MicroBlogErrorEvent.FOLLOW_ERROR, onFollowError);
				MewSystem.microBlog.follow(userData.id);
			}
		}
		private function onCancelFollowError(event : MicroBlogErrorEvent) : void
		{
			MewSystem.microBlog.removeEventListener(MicroBlogEvent.CANCEL_FOLLOWING_RESULT, onCancelFollowResult);
			MewSystem.microBlog.removeEventListener(MicroBlogErrorEvent.CANCEL_FOLLOWING_ERROR, onCancelFollowError);
			MewSystem.showLightAlert("取消关注失败!", this);
		}
		private function onCancelFollowResult(event : MicroBlogEvent) : void
		{
			MewSystem.microBlog.removeEventListener(MicroBlogEvent.CANCEL_FOLLOWING_RESULT, onCancelFollowResult);
			MewSystem.microBlog.removeEventListener(MicroBlogErrorEvent.CANCEL_FOLLOWING_ERROR, onCancelFollowError);
			MewSystem.showLightAlert("取消关注成功!", this);
			MewSystem.app.preloader.preloadFriendsInfo();
			MewSystem.app.preloader.preloadFriendTimeline();
		}
		
		private function onFollowResult(event:MicroBlogEvent):void
		{
			MewSystem.microBlog.removeEventListener(MicroBlogEvent.FOLLOW_RESULT, onFollowResult);
			MewSystem.microBlog.removeEventListener(MicroBlogErrorEvent.FOLLOW_ERROR, onFollowError);
			MewSystem.showLightAlert("关注成功!", this);
			MewSystem.app.preloader.preloadFriendsInfo();
			MewSystem.app.preloader.preloadFriendTimeline();
		}
		
		private function onFollowError(event:MicroBlogErrorEvent):void
		{
			MewSystem.microBlog.removeEventListener(MicroBlogEvent.FOLLOW_RESULT, onFollowResult);
			MewSystem.microBlog.removeEventListener(MicroBlogErrorEvent.FOLLOW_ERROR, onFollowError);
			MewSystem.showLightAlert("关注失败!", this);
		}

		private function bubbleEvent(event : MewEvent) : void
		{
			this.dispatchEvent(event.clone() as MewEvent);
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
			if(operationButtonGroup){
				removeChild(operationButtonGroup);
				operationButtonGroup = null;
			}
			if(dashLine){
				dashLine.bitmapData.dispose();
				dashLine = null;
			}
			if(relationshipButton){
				relationshipButton.removeEventListener(MouseEvent.CLICK, doFollow);
				relationshipButton = null;
			}
		}
	}
}