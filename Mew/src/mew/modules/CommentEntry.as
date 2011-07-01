package mew.modules
{
	import com.sina.microblog.data.MicroBlogComment;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	
	import mew.data.UserData;
	import mew.utils.StringUtils;
	import mew.utils.VideoChecker;
	
	import system.MewSystem;

	public class CommentEntry extends WeiboEntry
	{
		protected var id:String = null;
		public function CommentEntry()
		{
			super();
		}
		override public function initStatus(obj:Object):void
		{
			var comment:MicroBlogComment = obj as MicroBlogComment;
			
			id = comment.id;
			userData = MewSystem.app.dataCache.getUserDataCache(comment.user);
			
			var commentUserData:UserData = MewSystem.app.dataCache.getUserDataCache(comment.status.user);
			
			userAvatar.userData = userData;
			userAvatar.loadAvatar();
			addChild(userAvatar);
			
			nameBox.userData = userData;
			nameBox.create();
			addChild(nameBox);
			nameBox.x = userAvatar.x + userAvatar.width + 10;
			nameBox.y = 0;
			
			weiboText.htmlText = "<span class=\"mainStyle\">" + StringUtils.displayTopicAndAt(comment.text) + "</span>";
			urls = StringUtils.getURLs(comment.text);
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
			
			timeAndFrom.time = comment.createdAt;
			timeAndFrom.from = "";
			timeAndFrom.create();
			
			repostBox = new RepostBox();
			repostBox.setSize(this.width - weiboText.x, 10);
			repostBox.x = weiboText.x;
			repostBox.y = weiboText.y + weiboText.height + 10;
			repostBox.initStatus(comment.status);
			addChild(repostBox);
			repostBox.addEventListener(Event.RESIZE, onResize);
			
			var preChild:DisplayObject = this.getChildAt(this.numChildren - 1);
			timeAndFrom.x = preChild.x;
			timeAndFrom.y = preChild.y + preChild.height + 10;
			addChild(timeAndFrom);
			var h:int = timeAndFrom.y + timeAndFrom.height;
			if(h != this.height) setSize(this.width, Math.max(this.height, h));
		}
	}
}