package mew.communication {
	import com.sina.microblog.data.MicroBlogStatus;
	import config.SQLConfig;
	import com.sina.microblog.data.MicroBlogUser;
	import com.sina.microblog.data.MicroBlogUnread;
	import com.sina.microblog.events.MicroBlogErrorEvent;
	import com.sina.microblog.events.MicroBlogEvent;
	import system.MewSystem;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	/**
	 * @author Abel Lee
	 */
	public class WeiboChecker {
		private var timer:Timer = new Timer(40000);
		private var unread:MicroBlogUnread = null;
		private var count:int = 0;
		private var totalCount:int = 0;
		public function WeiboChecker(){
		}
		public function startRunning():void
		{
			trace("start running!");
			timer.addEventListener(TimerEvent.TIMER, onTimerEvent);
			timer.start();
		}
		public function stopRunning():void
		{
			timer.stop();
			timer.removeEventListener(TimerEvent.TIMER, onTimerEvent);
		}
		private function onTimerEvent(event:TimerEvent):void
		{
			MewSystem.microBlog.addEventListener(MicroBlogEvent.LOAD_STATUS_UNREAD_RESULT, onLoadStatusUnreadResult);
			MewSystem.microBlog.addEventListener(MicroBlogErrorEvent.LOAD_STATUS_UNREAD_ERROR, onLoadStatusUnreadError);
			MewSystem.microBlog.loadStatusUnread(1);
		}

		private function onLoadStatusUnreadError(event : MicroBlogErrorEvent) : void
		{
			MewSystem.microBlog.removeEventListener(MicroBlogEvent.LOAD_STATUS_UNREAD_RESULT, onLoadStatusUnreadResult);
			MewSystem.microBlog.removeEventListener(MicroBlogErrorEvent.LOAD_STATUS_UNREAD_ERROR, onLoadStatusUnreadError);
			timer.reset();
			timer.start();
		}

		private function onLoadStatusUnreadResult(event : MicroBlogEvent) : void
		{
			MewSystem.microBlog.removeEventListener(MicroBlogEvent.LOAD_STATUS_UNREAD_RESULT, onLoadStatusUnreadResult);
			MewSystem.microBlog.removeEventListener(MicroBlogErrorEvent.LOAD_STATUS_UNREAD_ERROR, onLoadStatusUnreadError);
			var unreadData:MicroBlogUnread = event.result as MicroBlogUnread;
			if(unreadData){
				trace("unread checking: (status:" + unreadData.new_status + ")...(followers:" + unreadData.followers
				 + ")...(comments:" + unreadData.comments + ")...(dm:" + unreadData.dm + ")...(metions:" + unreadData.mentions + ")");
				if(unreadData.new_status){
					loadNewStatus(unreadData.new_status);
					addTotalCount();
				}
				if(unreadData.followers){
					loadNewFans(unreadData.followers);
					addTotalCount();
				}
				if(unreadData.comments){
					loadNewComment(unreadData.comments);
					addTotalCount();
				}
				if(unreadData.dm){
					loadNewDM(unreadData.dm);
					addTotalCount();
				}
				if(unreadData.mentions){
					loadNewAt(unreadData.mentions);
					addTotalCount();
				}
				trace("unread checking and totalCount is:" + totalCount);
				if(totalCount) unread = unreadData;
			}
			timer.reset();
			timer.start();
		}

		private function loadNewAt(mentions : int) : void
		{
			if(mentions){
				MewSystem.microBlog.addEventListener(MicroBlogEvent.LOAD_MENSIONS_RESULT, loadMentionsResult);
				MewSystem.microBlog.loadMentions("0", "0", mentions, 1);
			}
		}
		
		private function addTotalCount():void
		{
			totalCount ++;
			trace("totalCount is:" + totalCount);
		}
		
		private function addCount():void
		{
			count ++;
			trace("count:" + count);
			if(count >= totalCount){
				trace("show notice window");
				MewSystem.showNoticeWindow(unread);
				unread = null;
				count = 0;
				totalCount = 0;
			}
		}

		private function loadMentionsResult(event : MicroBlogEvent) : void
		{
			MewSystem.microBlog.removeEventListener(MicroBlogEvent.LOAD_MENSIONS_RESULT, loadMentionsResult);
			var arr:Array = event.result as Array;
			addCount();
			if(arr && arr.length){
				if(MewSystem.checkLastId(SQLConfig.MEW_AT, arr)) return;
				MewSystem.app.localWriter.prefixData(arr, SQLConfig.MEW_AT, MewSystem.atNum);
				MewSystem.atNotice(arr.length);
				MewSystem.microBlog.resetCount(2);
			}
		}

		private function loadNewDM(dm : int) : void
		{
			if(dm){
				MewSystem.microBlog.addEventListener(MicroBlogEvent.LOAD_DIRECT_MESSAGES_RECEIVED_RESULT, loadDirectMessagesReceivedResult);
				MewSystem.microBlog.loadDirectMessagesReceived("0", "0", dm, 1);
			}
		}

		private function loadDirectMessagesReceivedResult(event : MicroBlogEvent) : void
		{
			MewSystem.microBlog.removeEventListener(MicroBlogEvent.LOAD_DIRECT_MESSAGES_RECEIVED_RESULT, loadDirectMessagesReceivedResult);
			var arr:Array = event.result as Array;
			addCount();
			if(arr && arr.length){
				if(MewSystem.checkLastId(SQLConfig.MEW_DIRECT, arr)) return;
				MewSystem.app.localWriter.prefixData(arr, SQLConfig.MEW_DIRECT, MewSystem.directMessageNum);
				MewSystem.dmNotice(arr.length);
				MewSystem.microBlog.resetCount(3);
			}
		}

		private function loadNewComment(comments : int) : void
		{
			if(comments){
				MewSystem.microBlog.addEventListener(MicroBlogEvent.LOAD_COMMENTS_TIMELINE_RESULT, loadCommentsTimeLine);
				MewSystem.microBlog.loadCommentsTimeline("0", "0", comments, 1);
			}
		}

		private function loadCommentsTimeLine(event : MicroBlogEvent) : void
		{
			MewSystem.microBlog.removeEventListener(MicroBlogEvent.LOAD_COMMENTS_TIMELINE_RESULT, loadCommentsTimeLine);
			var arr:Array = event.result as Array;
			addCount();
			if(arr && arr.length){
				if(MewSystem.checkLastId(SQLConfig.MEW_COMMENT, arr)) return;
				MewSystem.app.localWriter.prefixData(arr, SQLConfig.MEW_COMMENT, MewSystem.commentNum);
				MewSystem.commentNotice(arr.length);
				MewSystem.microBlog.resetCount(1);
			}
		}
		
		private function loadNewStatus(new_status : int) : void
		{
			if(new_status){
				MewSystem.microBlog.addEventListener(MicroBlogEvent.LOAD_FRIENDS_TIMELINE_RESULT, loadFriendTimeLine);
				MewSystem.microBlog.loadFriendsTimeline("0", "0", new_status, 1);
			}
		}

		private function loadFriendTimeLine(event : MicroBlogEvent) : void
		{
			MewSystem.microBlog.removeEventListener(MicroBlogEvent.LOAD_FRIENDS_TIMELINE_RESULT, loadFriendTimeLine);
			var arr:Array = event.result as Array;
			addCount();
			if(arr && arr.length){
				if(MewSystem.checkLastId(SQLConfig.MEW_INDEX, arr)) return;
				MewSystem.app.localWriter.prefixData(arr, SQLConfig.MEW_INDEX, MewSystem.statusNum);
				MewSystem.statusNotice(arr.length);
				var userStatus:Array = [];
				for each(var status:MicroBlogStatus in arr){
					if(status.id == MewSystem.app.userData.id) userStatus.push(status);
				}
				if(userStatus.length){
					MewSystem.app.localWriter.prefixData(userStatus, SQLConfig.MEW_MY_WEIBO, MewSystem.userStatusNum);
					//TODO: 检测当前容器 处于激活状态的是否为用户首页界面 如果是 则将新微博添加至显示列表
				}
			}
		}
		
		private function loadNewFans(followers : int):void
		{
			if(followers){
				MewSystem.microBlog.addEventListener(MicroBlogEvent.LOAD_FOLLOWERS_INFO_RESULT, loadFollowersInfoResult);
				MewSystem.microBlog.loadFollowersInfo(null, "0", null, -1, followers);
			}
		}
		
		private function loadFollowersInfoResult(event:MicroBlogEvent):void
		{
			MewSystem.microBlog.removeEventListener(MicroBlogEvent.LOAD_FOLLOWERS_INFO_RESULT, loadFollowersInfoResult);
			var arr:Array = event.result as Array;
			addCount();
			if(arr && arr.length){
				if(MewSystem.checkLastId(SQLConfig.MEW_FANS, arr)) return;
				MewSystem.app.localWriter.prefixData(arr, SQLConfig.MEW_FANS, MewSystem.fansNum);
				MewSystem.fansNotice(arr.length);
				MewSystem.microBlog.resetCount(4);
			}
		}
	}
}
