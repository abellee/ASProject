package mew.modules
{
	import com.iabel.component.EmotionTextField;
	import com.iabel.core.UISprite;
	import com.sina.microblog.data.MicroBlogDirectMessage;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	import flash.text.StyleSheet;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	import mew.data.UserData;
	import mew.data.WeiboData;
	import mew.utils.StringUtils;
	
	import org.bytearray.gif.player.GIFPlayer;
	
	import system.MewSystem;
	
	import widget.Widget;
	
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
			
			nameBox.userData = userData;
			nameBox.create();
			
			addChild(userAvatar);
			addChild(nameBox);
			addChild(weiboText);
			
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