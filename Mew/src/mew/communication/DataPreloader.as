package mew.communication {
	import mew.events.MewEvent;
	import flash.events.EventDispatcher;
	import mew.utils.MewUtils;
	import system.MewSystem;

	import com.sina.microblog.data.MicroBlogComment;
	import com.sina.microblog.data.MicroBlogCount;
	import com.sina.microblog.data.MicroBlogDirectMessage;
	import com.sina.microblog.data.MicroBlogRelationshipDescriptor;
	import com.sina.microblog.data.MicroBlogStatus;
	import com.sina.microblog.data.MicroBlogUser;
	import com.sina.microblog.data.MicroBlogUsersRelationship;
	import com.sina.microblog.events.MicroBlogEvent;

	import flash.net.registerClassAlias;

	public class DataPreloader extends EventDispatcher
	{
		public var count:int = 0;        //total is true
		private var tempArray:Array = null;
		
		public var friendTimlineReadComplete:Boolean = false;
		public var commentsTimelineReadComplete:Boolean = false;
		public var mentionsReadComplete:Boolean = false;
		public var dmReadComplete:Boolean = false;
		public var favoriteListReadComplete:Boolean = false;
		public var userTimelineReadComplete:Boolean = false;
		public var followerInfoReadComplete:Boolean = false;
		public var friendsInfoReadComplete:Boolean = false;
		public function DataPreloader()
		{
			registerClassAlias("microblogstatus", MicroBlogStatus);
			registerClassAlias("microbloguser", MicroBlogUser);
			registerClassAlias("microblogcomment", MicroBlogComment);
			registerClassAlias("microblogrelationshipdescriptor", MicroBlogRelationshipDescriptor);
			registerClassAlias("microblogdirectmessage", MicroBlogDirectMessage);
			registerClassAlias("microblogrelationship", MicroBlogUsersRelationship);
			registerClassAlias("microblogcount", MicroBlogCount);
		}
		public function preload():void
		{
			count = 0;
			preloadFriendTimeline();
			preloadCommentsTimeline();
			preloadMentions();
			preloadDirectMessagesSent();
			preloadDirectMessagesReceived();
			preloadFavoriteList();
			preloadUserTimeline();
			preloadFollowersInfo();
			preloadFriendsInfo();
		}
		
		public function preloadFriendTimeline():void
		{
			friendTimlineReadComplete = false;
			MewSystem.microBlog.addEventListener(MicroBlogEvent.LOAD_FRIENDS_TIMELINE_RESULT, loadFriendTimeLine);
			MewSystem.microBlog.loadFriendsTimeline();
		}
		
		public function preloadCommentsTimeline():void
		{
			commentsTimelineReadComplete = false;
			MewSystem.microBlog.addEventListener(MicroBlogEvent.LOAD_COMMENTS_TIMELINE_RESULT, loadCommentsTimeLineResult);
			MewSystem.microBlog.loadCommentsTimeline();
		}
		
		public function preloadMentions():void
		{
			mentionsReadComplete = false;
			MewSystem.microBlog.addEventListener(MicroBlogEvent.LOAD_MENSIONS_RESULT, loadMentionTimeLine);
			MewSystem.microBlog.loadMentions();
		}
		
		public function preloadDirectMessagesSent():void
		{
			dmReadComplete = false;
			MewSystem.microBlog.addEventListener(MicroBlogEvent.LOAD_DIRECT_MESSAGES_SENT_RESULT, loadDirectMessageSentResult);
			MewSystem.microBlog.loadDirectMessagesSent();
		}
		
		public function preloadDirectMessagesReceived():void
		{
			MewSystem.microBlog.addEventListener(MicroBlogEvent.LOAD_DIRECT_MESSAGES_RECEIVED_RESULT, loadDirectMessageReceivedResult);
			MewSystem.microBlog.loadDirectMessagesReceived();
		}
		
		public function preloadFavoriteList():void
		{
			favoriteListReadComplete = false;
			MewSystem.microBlog.addEventListener(MicroBlogEvent.LOAD_FAVORITE_LIST_RESULT, loadFavoriteListResult);
			MewSystem.microBlog.loadFavoriteList();
		}
		
		public function preloadUserTimeline():void
		{
			userTimelineReadComplete = false;
			MewSystem.microBlog.addEventListener(MicroBlogEvent.LOAD_USER_TIMELINE_RESULT, loadUserTimeLineResult);
			MewSystem.microBlog.loadUserTimeline();
		}
		
		public function preloadFollowersInfo():void
		{
			followerInfoReadComplete = false;
			MewSystem.microBlog.addEventListener(MicroBlogEvent.LOAD_FOLLOWERS_INFO_RESULT, loadFollowersInfoResult);
			MewSystem.microBlog.loadFollowersInfo(null, "0", null, -1, MewSystem.fansNum);
		}
		
		public function preloadFriendsInfo():void
		{
			friendsInfoReadComplete = false;
			MewSystem.microBlog.addEventListener(MicroBlogEvent.LOAD_FRIENDS_INFO_RESULT, loadFriendsInfoResult);
			MewSystem.microBlog.loadFriendsInfo(null, "0", null, -1, MewSystem.followNum);
		}
		
		private function loadFriendTimeLine(event:MicroBlogEvent):void
		{
			MewSystem.microBlog.removeEventListener(MicroBlogEvent.LOAD_FRIENDS_TIMELINE_RESULT, loadFriendTimeLine);
			var result:Array = event.result as Array;
			if(result && result.length){
				MewSystem.setLastId("mew_index", result);
				MewSystem.setFinalId("mew_index", result);
			}
			MewSystem.app.localWriter.writeData(result, "mew_index");
			friendTimlineReadComplete = true;
			var mewEvent:MewEvent = new MewEvent(MewEvent.FRIEND_TIME_LINE_LOADED);
			mewEvent.result = result;
			this.dispatchEvent(mewEvent);
		}
		
		private function loadMentionTimeLine(event:MicroBlogEvent):void
		{
			MewSystem.microBlog.removeEventListener(MicroBlogEvent.LOAD_MENSIONS_RESULT, loadMentionTimeLine);
			var result:Array = event.result as Array;
			if(result && result.length) MewSystem.setLastId("mew_at", result);
			MewSystem.app.localWriter.writeData(result, "mew_at");
			mentionsReadComplete = true;
			var mewEvent:MewEvent = new MewEvent(MewEvent.MENTIONS_LOADED);
			mewEvent.result = result;
			this.dispatchEvent(mewEvent);
		}
		
		private function loadCommentsTimeLineResult(event:MicroBlogEvent):void
		{
			MewSystem.microBlog.removeEventListener(MicroBlogEvent.LOAD_COMMENTS_TIMELINE_RESULT, loadCommentsTimeLineResult);
			var result:Array = event.result as Array;
			if(result && result.length){
				MewSystem.setLastId("mew_comment", result);
				MewSystem.setFinalId("mew_comment", result);
			}
			MewSystem.app.localWriter.writeData(result, "mew_comment");
			commentsTimelineReadComplete = true;
			var mewEvent:MewEvent = new MewEvent(MewEvent.COMMENTS_TIME_LINE_LOADED);
			mewEvent.result = result;
			this.dispatchEvent(mewEvent);
		}
		
		private function loadDirectMessageSentResult(event:MicroBlogEvent):void
		{
			MewSystem.microBlog.removeEventListener(MicroBlogEvent.LOAD_DIRECT_MESSAGES_SENT_RESULT, loadDirectMessageSentResult);
			var result:Array = event.result as Array;
			integrateDirectMessage(result);
		}
		
		private function integrateDirectMessage(arr:Array):void
		{
			if(tempArray){
				arr = arr.concat(tempArray);
				arr.sortOn("id", Array.DESCENDING);
				if(arr && arr.length){
					MewSystem.setLastId("mew_dm", arr);
					MewSystem.setFinalId("mew_dm", arr);
				}
				tempArray = null;
				MewSystem.app.localWriter.writeData(arr, "mew_dm");
				dmReadComplete = true;
				var mewEvent:MewEvent = new MewEvent(MewEvent.DM_LOADED);
				mewEvent.result = arr;
				this.dispatchEvent(mewEvent);
			}else{
				tempArray = arr;
			}
		}
		
		private function loadDirectMessageReceivedResult(event:MicroBlogEvent):void
		{
			dmReadComplete = false;
			MewSystem.microBlog.removeEventListener(MicroBlogEvent.LOAD_DIRECT_MESSAGES_RECEIVED_RESULT, loadDirectMessageReceivedResult);
			var result:Array = event.result as Array;
			integrateDirectMessage(result);
		}
		
		private function loadFavoriteListResult(event:MicroBlogEvent):void
		{
			MewSystem.microBlog.removeEventListener(MicroBlogEvent.LOAD_FAVORITE_LIST_RESULT, loadFavoriteListResult);
			var result:Array = event.result as Array;
			if(result && result.length) MewSystem.setFinalId("mew_collect", result);
			MewSystem.app.localWriter.writeData(result, "mew_collect");
			favoriteListReadComplete = true;
			var mewEvent:MewEvent = new MewEvent(MewEvent.FAVORITE_LOADED);
			mewEvent.result = result;
			this.dispatchEvent(mewEvent);
		}
		
		private function loadUserTimeLineResult(event:MicroBlogEvent):void
		{
			MewSystem.microBlog.removeEventListener(MicroBlogEvent.LOAD_USER_TIMELINE_RESULT, loadUserTimeLineResult);
			var result:Array = event.result as Array;
			if(result && result.length) MewSystem.setFinalId("mew_user", result);
			MewSystem.app.localWriter.writeData(result, "mew_user");
			userTimelineReadComplete = true;
			var mewEvent:MewEvent = new MewEvent(MewEvent.USER_TIME_LINE_LOADED);
			mewEvent.result = result;
			this.dispatchEvent(mewEvent);
		}
		
		private function loadFollowersInfoResult(event:MicroBlogEvent):void
		{
			MewSystem.microBlog.removeEventListener(MicroBlogEvent.LOAD_FOLLOWERS_INFO_RESULT, loadFollowersInfoResult);
			var result:Array = event.result as Array;
			if(result && result.length) MewSystem.setLastId("mew_fans", result);
			MewSystem.app.localWriter.writeData(result, "mew_fans");
			followerInfoReadComplete = true;
			var mewEvent:MewEvent = new MewEvent(MewEvent.FOLLOW_INFO_LOADED);
			mewEvent.result = result;
			this.dispatchEvent(mewEvent);
		}
		
		private function loadFriendsInfoResult(event:MicroBlogEvent):void
		{
			MewSystem.microBlog.removeEventListener(MicroBlogEvent.LOAD_FRIENDS_INFO_RESULT, loadFriendsInfoResult);
			var result:Array = event.result as Array;
			if(result && result.length){
				MewSystem.setLastId("mew_follow", result);
				MewSystem.setFinalId("mew_follow", result);
			}
			MewSystem.app.localWriter.writeData(result, "mew_follow");
			friendsInfoReadComplete = true;
			var mewEvent:MewEvent = new MewEvent(MewEvent.FRIEND_INFO_LOADED);
			mewEvent.result = result;
			this.dispatchEvent(mewEvent);
		}
	}
}