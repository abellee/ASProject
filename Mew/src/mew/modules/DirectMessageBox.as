package mew.modules
{
	import com.iabel.core.UISprite;
	import com.sina.microblog.data.MicroBlogDirectMessage;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.StyleSheet;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	import mew.data.UserData;
	import mew.data.WeiboData;
	import mew.utils.StringUtils;
	
	import system.MewSystem;
	
	import widget.Widget;
	
	public class DirectMessageBox extends UISprite
	{
		public var data:WeiboData = null;
		public var userData:UserData = null;
		
		private var targetUserData:UserData = null;
		private var userAvatar:Avatar = null;
		
		protected var nameBox:NameBox = null;
		protected var weiboText:TextField = null;
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
			weiboText = new TextField();
			
			if(!Widget.linkStyle){
				Widget.linkStyle = new StyleSheet();
				Widget.linkStyle.setStyle(".mainStyle",{color: "0x4C4C4C", fontFamily: "华文黑体", fontSize: "12", leading: "5"});
				Widget.linkStyle.setStyle("a:link", {color: Widget.linkColor});
				Widget.linkStyle.setStyle("a:hover", {color: Widget.linkColor});
				Widget.linkStyle.setStyle("a:visited", {color: Widget.linkColor});
				Widget.linkStyle.setStyle("a:active", {color: Widget.linkColor});
			}
			weiboText.styleSheet = Widget.linkStyle;
			weiboText.autoSize = TextFieldAutoSize.LEFT;
//			weiboText.defaultTextFormat = Widget.wbTextFormat;
			weiboText.mouseWheelEnabled = false;
			weiboText.wordWrap = true;
			weiboText.addEventListener(MouseEvent.MOUSE_WHEEL, stopMouseWheel);
			weiboText.addEventListener(Event.SCROLL, stopScroll);
		}
		protected function stopMouseWheel(event:MouseEvent):void
		{
			weiboText.scrollV = 1;
		}
		protected function stopScroll(event:Event):void
		{
			weiboText.scrollV = 1;
		}
		
		public function initStatus(obj:Object):void
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
			
			weiboText.htmlText = StringUtils.displayTopicAndAt(data.content + " (" + StringUtils.transformTime(dm.createdAt) + ")");
			urls = StringUtils.getURLs(data.content);
			addChild(userAvatar);
			addChild(nameBox);
			addChild(weiboText);
			
			if(userData.id == MewSystem.app.userData.id) userAvatar.x = this.width - userAvatar.width - 2;
			else userAvatar.x = 0;
			
			nameBox.x = userAvatar.width + 5;
			weiboText.width = this.width - userAvatar.width * 2 - 10;
			weiboText.height = weiboText.textHeight;
			weiboText.x = nameBox.x;
			weiboText.y = nameBox.y + nameBox.height + 5;
			
			setSize(this.width, this.height);
		}
	}
}