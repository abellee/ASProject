package mew.modules {
	import mew.windows.ALNativeWindow;
	import mew.data.UserData;
	import mew.data.WeiboData;
	import mew.utils.StringUtils;

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
		
		protected var targetUserData:UserData = null;
		protected var userAvatar:Avatar = null;
		
		protected var nameBox:NameBox = null;
		protected var weiboText:EmotionTextField = null;
		protected var urls:Array = null;
		
		public function DirectMessageBox()
		{
			super();
			addEventListener(Event.ADDED_TO_STAGE, onAdd);
			init();
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
			userAvatar.addEventListener(MouseEvent.ROLL_OVER, showFloatFrame);
			userAvatar.addEventListener(MouseEvent.ROLL_OUT, removeFloatFrame);
			
			nameBox.userData = userData;
			nameBox.create();
			
			addChild(userAvatar);
			addChild(nameBox);
			addChild(weiboText);
			nameBox.addEventListener(MouseEvent.ROLL_OVER, showFloatFrame);
			nameBox.addEventListener(MouseEvent.ROLL_OUT, removeFloatFrame);
			
			if(userData.id == MewSystem.app.userData.id) userAvatar.x = this.width - userAvatar.width - 2;
			else userAvatar.x = 0;
			
			nameBox.x = userAvatar.width + 5;
			data.content = data.content.replace(/\</g, "&lt;");
			weiboText.setText(StringUtils.displayTopicAndAt(data.content + " (" + StringUtils.transformTime(dm.createdAt) + ")"), this.width - userAvatar.width * 2 - 10, xml);
			weiboText.x = nameBox.x;
			weiboText.y = nameBox.y + nameBox.height + 5;
			urls = StringUtils.getURLs(data.content);
			if(urls && urls.length){
				for each(var s:String in urls){
					weiboText.replace(new RegExp(s), "<a href=\"" + s + "\">" + s + "</a>");
				}
			}
			
			setSize(this.width, this.height);
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
		}
	}
}