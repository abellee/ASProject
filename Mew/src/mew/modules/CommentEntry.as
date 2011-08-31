package mew.modules {
	import mew.utils.StringUtils;
	import mew.utils.VideoChecker;

	import system.MewSystem;

	import com.sina.microblog.data.MicroBlogComment;

	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;

	public class CommentEntry extends WeiboEntry
	{
		protected var id:String = null;
		public function CommentEntry()
		{
			super();
		}
		override public function initStatus(obj:Object, xml:XML):void
		{
			var comment:MicroBlogComment = obj as MicroBlogComment;
			
			id = comment.id;
			userData = MewSystem.app.dataCache.getUserDataCache(comment.user);
			
			data = MewSystem.app.dataCache.getWeiboDataCache(comment.status);
			
			userAvatar.userData = userData;
			userAvatar.loadAvatar();
			addChild(userAvatar);
			userAvatar.addEventListener(MouseEvent.ROLL_OVER, showFloatFrame);
			userAvatar.addEventListener(MouseEvent.ROLL_OUT, removeFloatFrame);
			
			nameBox.userData = userData;
			nameBox.create();
			addChild(nameBox);
			nameBox.x = userAvatar.x + userAvatar.width + 10;
			nameBox.y = 0;
			nameBox.addEventListener(MouseEvent.ROLL_OVER, showFloatFrame);
			nameBox.addEventListener(MouseEvent.ROLL_OUT, removeFloatFrame);
			
			addChild(weiboText);
			weiboText.x = nameBox.x;
			weiboText.y = nameBox.y + nameBox.height + 10;
			comment.text = comment.text.replace(/\</g, "&lt;");
			weiboText.setText("<span class=\"mainStyle\">" + StringUtils.displayTopicAndAt(comment.text) + "</span>", this.width - weiboText.x, xml);
			urls = StringUtils.getURLs(comment.text);
			if(urls && urls.length){
				for each(var s:String in urls){
					weiboText.replace(new RegExp(s), "<a href=\"" + s + "\">" + s + "</a>");
				}
				videoChecker = new VideoChecker();
				videoChecker.addEventListener(Event.COMPLETE, checkVideoUrlComplete);
				videoChecker.isVideoURL(urls);
			}
			
			timeAndFrom.time = comment.createdAt;
			timeAndFrom.from = "";
			timeAndFrom.create();
			
			repostBox = new RepostBox();
			repostBox.setSize(this.width - weiboText.x, 10);
			repostBox.x = weiboText.x;
			repostBox.y = weiboText.y + weiboText.height + 10;
			repostBox.initStatus(comment.status, xml);
			addChild(repostBox);
			repostBox.addEventListener(Event.RESIZE, onResize);
			
			var preChild:DisplayObject = this.getChildAt(this.numChildren - 1);
			timeAndFrom.x = preChild.x;
			timeAndFrom.y = preChild.y + preChild.height + 10;
			addChild(timeAndFrom);
			var h:int = timeAndFrom.y + timeAndFrom.height;
			if(h != this.height) setSize(this.width, Math.max(this.height, h));
		}
		override protected function dealloc(event:Event):void
		{
			super.dealloc(event);
			id = null;
		}
	}
}