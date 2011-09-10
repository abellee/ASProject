package mew.modules {
	import mew.data.UserData;
	import mew.data.WeiboData;
	import mew.utils.StringUtils;
	import mew.utils.VideoChecker;

	import system.MewSystem;

	import com.iabel.util.DashLine;
	import com.sina.microblog.data.MicroBlogComment;

	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;

	public class CommentEntry extends WeiboEntry
	{
		protected var id:String = null;
		private var username:String = null;
		public var showRepost:Boolean = true;
		private var repostData:WeiboData = null;
		private var repostUserData:UserData = null;
		private var weiboUser:UserData = null;
		private var commentText:String = null;
		public function CommentEntry()
		{
			super();
		}
		override public function initStatus(obj:Object, xml:XML):void
		{
			var comment:MicroBlogComment = obj as MicroBlogComment;
			
			id = comment.id;
			username = comment.user.name;
			userData = MewSystem.app.dataCache.getUserDataCache(comment.user);
			weiboUser = MewSystem.app.dataCache.getUserDataCache(comment.status.user);
			
			data = MewSystem.app.dataCache.getWeiboDataCache(comment.status);
			
			userAvatar.userData = userData;
			userAvatar.loadAvatar();
			addChild(userAvatar);
			
			nameBox.userData = userData;
			nameBox.create();
			addChild(nameBox);
			nameBox.x = userAvatar.x + userAvatar.width + 10;
			nameBox.y = 0;
			
			commentText = comment.text;
			
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
			
			if(comment.status.repost){
				repostData = MewSystem.app.dataCache.getWeiboDataCache(comment.status.repost);
				repostUserData = MewSystem.app.dataCache.getUserDataCache(comment.status.repost.user);
			}
			
			timeAndFrom.time = comment.createdAt;
			timeAndFrom.from = "";
			timeAndFrom.create();
			
			if(showRepost){
				repostBox = new RepostBox();
				repostBox.setSize(this.width - weiboText.x, 10);
				repostBox.x = weiboText.x;
				repostBox.y = weiboText.y + weiboText.height + 10;
				repostBox.initStatus(comment.status, xml);
				addChild(repostBox);
				repostBox.addEventListener(Event.RESIZE, onResize);
			}
			
			var preChild:DisplayObject = this.getChildAt(this.numChildren - 1);
			timeAndFrom.x = preChild.x;
			timeAndFrom.y = preChild.y + preChild.height + 10;
			addChild(timeAndFrom);
			var h:int = timeAndFrom.y + timeAndFrom.height;
			if(h != this.height) setSize(this.width, Math.max(this.height, h));
			
			var bd:DashLine = new DashLine(this.width, 1);
			bd.drawDashLine(5);
			dashLine = new Bitmap(bd);
			addChild(dashLine);
			dashLine.alpha = .3;
			dashLine.y = timeAndFrom.y + timeAndFrom.height + 10;
			
			addListener();
		}
		override protected function showOperationButton(event : MouseEvent) : void
		{
			MewSystem.operationButton = new OperationGroup();
			if(userData.id == MewSystem.app.userData.id || weiboUser.id == MewSystem.app.userData.id) MewSystem.operationButton.showDeleteButton();
			MewSystem.operationButton.showCommentButton();
			MewSystem.operationButton.calculateSize();
			data.cid = data.id;
			data.username = username;
			data.commentText = commentText;
			MewSystem.operationButton.finalStep = finalStep;
			MewSystem.operationButton.parentBox = this;
			MewSystem.operationButton.parentWin = parentWin;
			MewSystem.operationButton.cid = id;
			MewSystem.operationButton.data = data;
			MewSystem.operationButton.userData = weiboUser;
			MewSystem.operationButton.repostData = repostData;
			MewSystem.operationButton.repostUserData = repostUserData;
			MewSystem.operationButton.sid = data.id;
			addChild(MewSystem.operationButton);
			MewSystem.operationButton.x = this.width - MewSystem.operationButton.width - 5;
		}
		override protected function dealloc(event:Event):void
		{
			super.dealloc(event);
			id = null;
		}
	}
}