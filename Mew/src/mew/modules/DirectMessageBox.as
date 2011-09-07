package mew.modules {
	import mew.data.UserData;
	import mew.data.WeiboData;
	import mew.events.MewEvent;
	import mew.utils.StringUtils;
	import mew.windows.ALNativeWindow;

	import system.MewSystem;

	import com.iabel.component.EmotionTextField;
	import com.iabel.core.UISprite;
	import com.sina.microblog.data.MicroBlogDirectMessage;

	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	public class DirectMessageBox extends UISprite
	{
		public var data:WeiboData = null;
		public var userData:UserData = null;
		public var finalStep:Boolean = false;
		
		protected var targetUserData:UserData = null;
		protected var userAvatar:Avatar = null;
		
		protected var nameBox:NameBox = null;
		protected var weiboText:EmotionTextField = null;
		protected var urls:Array = null;
		public var parentWin:ALNativeWindow = null;
		
		public function DirectMessageBox()
		{
			super();
			addEventListener(Event.ADDED_TO_STAGE, onAdd);
			addEventListener(MouseEvent.ROLL_OVER, showOperationButton);
			addEventListener(MouseEvent.ROLL_OUT, removeOperationButton);
			init();
		}

		protected function removeOperationButton(event : MouseEvent) : void
		{
			if(MewSystem.operationButton && this.contains(MewSystem.operationButton)){
				this.removeChild(MewSystem.operationButton);
				MewSystem.operationButton = null;
			}
		}

		protected function showOperationButton(event : MouseEvent) : void
		{
			if(!MewSystem.operationButton) MewSystem.operationButton = new OperationGroup();
			MewSystem.operationButton.showDeleteButton();
			MewSystem.operationButton.showMessageButton();
			MewSystem.operationButton.finalStep = finalStep;
			data.cid = "0";
			MewSystem.operationButton.parentWin = parentWin;
			MewSystem.operationButton.data = data;
			MewSystem.operationButton.userData = userData;
			MewSystem.operationButton.parentBox = this;
			MewSystem.operationButton.calculateSize();
			addChild(MewSystem.operationButton);
			MewSystem.operationButton.sid = data.id;
			if(userData.id == MewSystem.app.userData.id) MewSystem.operationButton.x = 5;
			else MewSystem.operationButton.x = this.width - MewSystem.operationButton.width - 5;
		}
		protected function onAdd(event:Event):void
		{
//			this.stage.addEventListener(Event.RESIZE, onResize);
			removeEventListener(Event.ADDED_TO_STAGE, onAdd);
		}
		
		protected function init():void
		{
			nameBox = new NameBox();
			weiboText = new EmotionTextField();
		}
		
		public function initStatus(obj:Object, xml:XML):void
		{
			var dm:MicroBlogDirectMessage = obj as MicroBlogDirectMessage;
			if(!dm) return;
			
			userData = MewSystem.app.dataCache.getUserDataCache(dm.sender);
			targetUserData = MewSystem.app.dataCache.getUserDataCache(dm.recipient);
			data = new WeiboData();
			data.content = dm.text;
			data.id = dm.id;
			
			userAvatar = new Avatar();
			userAvatar.userData = userData;
			userAvatar.loadAvatar();
			
			nameBox.userData = userData;
			nameBox.create();
			
			addChild(userAvatar);
			addChild(nameBox);
			addChild(weiboText);
			
			if(userData.id == MewSystem.app.userData.id) userAvatar.x = this.width - userAvatar.width - 2;
			else userAvatar.x = 0;
			
			nameBox.x = userAvatar.width + 5;
			var contentStr:String = data.content.replace(/\</g, "&lt;");
			urls = StringUtils.getURLs(contentStr);
			if(urls && urls.length){
				for each(var s:String in urls){
					contentStr = contentStr.replace(new RegExp(s), "<a href=\"" + s + "\">" + s + "</a>");
				}
			}
			weiboText.setText("<span class=\"mainStyle\">" + StringUtils.displayTopicAndAt(contentStr + " (" + StringUtils.transformTime(dm.createdAt) + ")") + "</span>",
			 this.width - userAvatar.width * 2 - 10, xml);
			weiboText.x = nameBox.x;
			weiboText.y = nameBox.y + nameBox.height + 5;
			
			setSize(this.width, this.height);
			addListener();
		}
		
		protected function addListener():void
		{
			if(userAvatar){
				userAvatar.addEventListener(MouseEvent.ROLL_OVER, showFloatFrame);
				userAvatar.addEventListener(MouseEvent.ROLL_OUT, removeFloatFrame);
				userAvatar.addEventListener(MouseEvent.CLICK, showTargetUser);
			}
			if(nameBox){
				nameBox.addEventListener(MouseEvent.ROLL_OVER, showFloatFrame);
				nameBox.addEventListener(MouseEvent.ROLL_OUT, removeFloatFrame);
				nameBox.addEventListener(MouseEvent.CLICK, showTargetUser);
			}
			weiboText.addEventListener(MewEvent.PLAY_VIDEO, playVideoHandler);
		}
		
		protected function playVideoHandler(event:MewEvent):void
		{
			
		}

		protected function showTargetUser(event : MouseEvent) : void
		{
			if(MewSystem.app.currentState == MewSystem.app.MY_WEIBO && userData == MewSystem.app.userData) return;
			MewSystem.app.alternationCenter.loadUserTimeline(userData.id);
		}

		protected function removeFloatFrame(event : MouseEvent) : void
		{
			(this.stage.nativeWindow as ALNativeWindow).removeUserFloat();
		}
		
		protected function showFloatFrame(event : MouseEvent) : void
		{
			if(!userAvatar) return;
			var globalPoint:Point = this.localToGlobal(new Point(userAvatar.x, userAvatar.y));
//			var realPoint:Point = this.stage.nativeWindow.globalToScreen(globalPoint);
			(this.stage.nativeWindow as ALNativeWindow).showUserFloat(globalPoint, userData);
		}
		
		override protected function dealloc(event:Event):void
		{
			super.dealloc(event);
			data = null;
			userData = null;
			targetUserData = null;
			userAvatar = null;
			nameBox = null;
			weiboText = null;
			urls = null;
			parentWin = null;
		}
	}
}