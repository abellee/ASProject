package mew.modules
{
	import com.sina.microblog.data.MicroBlogStatus;
	import com.yahoo.astra.fl.containers.BorderPane;
	import com.yahoo.astra.fl.containers.VBoxPane;
	import com.yahoo.astra.layout.modes.BorderConstraints;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.utils.getTimer;
	
	import mew.data.UserData;
	import mew.data.WeiboData;
	import mew.utils.StringUtils;
	import mew.utils.VideoChecker;
	
	import system.MewSystem;
	
	import widget.Widget;
	
	public class WeiboEntry extends RepostBox
	{
		protected var userAvatar:Avatar = null;
		protected var repostBox:RepostBox = null;
		public function WeiboEntry()
		{
			super();
		}
		override protected function init():void
		{
			super.init();
			userAvatar = new Avatar();
		}
//		public function resize():void
//		{
//			if(repostBox){
//				timeAndFrom.x = repostBox.x;
//				timeAndFrom.y = repostBox.y + repostBox.height + 10;
//			}
//			if(timeAndFrom){
//				var h:int = timeAndFrom.y + timeAndFrom.height;
//				if(h != this.height) setSize(this.width, h);
//			}
//		}
		override public function initStatus(obj:Object):void
		{
			var status:MicroBlogStatus = obj as MicroBlogStatus;
			if(!status) return;
			userData = MewSystem.app.dataCache.getUserDataCache(status.user);
			data = MewSystem.app.dataCache.getWeiboDataCache(status);
			
			userAvatar.userData = userData;
			userAvatar.loadAvatar();
			addChild(userAvatar);
			
			nameBox.userData = userData;
			nameBox.create();
			addChild(nameBox);
			nameBox.x = userAvatar.x + userAvatar.width + 10;
			nameBox.y = 0;
			
			weiboText.htmlText = "<span class=\"mainStyle\">" + StringUtils.displayTopicAndAt(data.content) + "</span>";
			urls = StringUtils.getURLs(data.content);
			if(urls && urls.length){
				for each(var s:String in urls){
					var str:String = weiboText.htmlText;
					weiboText.htmlText = str.replace(new RegExp(s), "<a href=\"" + s + "\">" + s + "</a>");
				}
				videoChecker = new VideoChecker();
				videoChecker.addEventListener(Event.COMPLETE, checkVideoUrlComplete);
				videoChecker.isVideoURL(urls);
			}
			
			addChild(weiboText);
			weiboText.x = nameBox.x;
			weiboText.y = nameBox.y + nameBox.height + 10;
			weiboText.width = this.width - weiboText.x;
			weiboText.height = weiboText.textHeight;
			
			timeAndFrom.time = status.createdAt;
			timeAndFrom.from = status.source;
			timeAndFrom.create();
			
			if(data.imageData){
				imageBox = new ImageBox();
				imageBox.setSize(10, 10);
				imageBox.data = data.imageData;
				imageBox.create();
				addChild(imageBox);
				imageBox.x = weiboText.x;
				imageBox.y = weiboText.y + weiboText.height + 10;
				imageBox.addEventListener(Event.RESIZE, onResize);
			}
			
			if(data.repostData){
				repostBox = new RepostBox();
				repostBox.setSize(this.width - weiboText.x, 10);
				repostBox.x = weiboText.x;
				repostBox.y = weiboText.y + weiboText.height + 10;
				repostBox.initStatus(status.repost);
				addChild(repostBox);
				repostBox.addEventListener(Event.RESIZE, onResize);
			}
			
			var preChild:DisplayObject = this.getChildAt(this.numChildren - 1);
			timeAndFrom.x = preChild.x;
			timeAndFrom.y = preChild.y + preChild.height + 10;
			addChild(timeAndFrom);
			setSize(this.width, this.height);
		}
		override protected function onResize(event:Event):void
		{
			var h:int = this.height;
			if(timeAndFrom){
				var index:int = this.getChildIndex(timeAndFrom);
				var preChild:DisplayObject = this.getChildAt(index - 1);
				timeAndFrom.y = preChild.y + preChild.height + 10;
				h = timeAndFrom.y + timeAndFrom.height;
			}
			setSize(this.width, h);
			this.dispatchEvent(new Event(Event.RESIZE));
		}
	}
}