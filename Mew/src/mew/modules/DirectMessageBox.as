package mew.modules {
	import widget.Widget;
	import flash.display.Sprite;
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
		public var finalStep:Boolean = true;
		
		protected var targetUserData:UserData = null;
		protected var userAvatar:Avatar = null;
		
		protected var nameBox:NameBox = null;
		protected var weiboText:EmotionTextField = null;
		protected var urls:Array = null;
		public var parentWin:ALNativeWindow = null;
		
		private var triangle:Sprite = null;
		private var roundRect:Sprite = null;
		private var skinContainer:Sprite = null;
		
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
			MewSystem.operationButton.calculateSize();
			MewSystem.operationButton.finalStep = finalStep;
			data.cid = "0";
			MewSystem.operationButton.parentWin = parentWin;
			MewSystem.operationButton.data = data;
			MewSystem.operationButton.userData = userData;
			MewSystem.operationButton.parentBox = this;
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
			skinContainer = new Sprite();
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
			
			addChild(userAvatar);
			addChild(nameBox);
			addChild(weiboText);
			
			var textStyle:String = "mainStyle";
			if(userData.id == MewSystem.app.userData.id){
				nameBox.create(0, true, 0xffffff);
				textStyle = "whiteStyle";
				userAvatar.x = this.width - userAvatar.width - 2;
			}else{
				nameBox.create();
				userAvatar.x = 0;
			}
			
			nameBox.x = userAvatar.width + 15;
			nameBox.y = 10;
			var contentStr:String = data.content.replace(/\</g, "&lt;");
			urls = StringUtils.getURLs(contentStr);
			if(urls && urls.length){
				for each(var s:String in urls){
					contentStr = contentStr.replace(new RegExp(s), "<a href=\"" + s + "\">" + s + "</a>");
				}
			}
			weiboText.setText("<span class=\"" + textStyle + "\">" + StringUtils.displayTopicAndAt(contentStr + " (" + StringUtils.transformTime(dm.createdAt) + ")") + "</span>",
			 this.width - userAvatar.width * 2 - 25, xml);
			weiboText.x = nameBox.x;
			weiboText.y = nameBox.y + nameBox.height + 5;
			
			if(userData.id == MewSystem.app.userData.id){
				drawTriangle("right");
				drawRoundRect("right");
				skinContainer.addChild(triangle);
				skinContainer.addChild(roundRect);
				triangle.x = roundRect.width - 5;
				triangle.y = 10;
				skinContainer.x = 63;
			}else{
				drawTriangle("left");
				drawRoundRect("left");
				skinContainer.addChild(triangle);
				skinContainer.addChild(roundRect);
				roundRect.x = 10;
				triangle.y = 10;
				skinContainer.x = userAvatar.width;
			}
			Widget.widgetGlowFilter(skinContainer);
			addChildAt(skinContainer, 0);
			setSize(this.width, this.height + 20);
			addListener();
		}
		
		private function drawTriangle(dir:String):void
		{
			if(!triangle) triangle = new  Sprite();
			triangle.graphics.clear();
			if(dir == "left"){
				triangle.graphics.beginFill(0xFFFFFF, 1.0);
				triangle.graphics.moveTo(20, 0);
				triangle.graphics.lineTo(20, 40);
				triangle.graphics.lineTo(0, 20);
				triangle.graphics.lineTo(20, 0);
			}else{
				triangle.graphics.beginFill(Widget.mainColor, 1.0);
				triangle.graphics.moveTo(0, 0);
				triangle.graphics.lineTo(0, 40);
				triangle.graphics.lineTo(20, 20);
				triangle.graphics.lineTo(0, 0);
			}
			triangle.graphics.endFill();
		}
		
		private function drawRoundRect(dir:String):void
		{
			if(!roundRect) roundRect = new Sprite();
			roundRect.graphics.clear();
			if(dir == "right"){
				roundRect.graphics.beginFill(Widget.mainColor, 1.0);
			}else{
				roundRect.graphics.beginFill(0xFFFFFF, 1.0);
			}
			roundRect.graphics.drawRoundRect(0, 0, this.width - userAvatar.width - 80, this.height + 20, 12);
			roundRect.graphics.endFill();
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
			triangle = null;
			roundRect = null;
			skinContainer = null;
		}
	}
}