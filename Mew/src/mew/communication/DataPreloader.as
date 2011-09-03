package mew.communication {
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

	public class DataPreloader
	{
		public var count:int = 0;        //total is true
		private var tempArray:Array = null;
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
			MewSystem.microBlog.addEventListener(MicroBlogEvent.LOAD_FRIENDS_TIMELINE_RESULT, loadFriendTimeLine);
			MewSystem.microBlog.loadFriendsTimeline();
			
			MewSystem.microBlog.addEventListener(MicroBlogEvent.LOAD_COMMENTS_TIMELINE_RESULT, loadCommentsTimeLineResult);
			MewSystem.microBlog.loadCommentsTimeline();
			
			MewSystem.microBlog.addEventListener(MicroBlogEvent.LOAD_MENSIONS_RESULT, loadMentionTimeLine);
			MewSystem.microBlog.loadMentions();
			
			MewSystem.microBlog.addEventListener(MicroBlogEvent.LOAD_DIRECT_MESSAGES_SENT_RESULT, loadDirectMessageSentResult);
			MewSystem.microBlog.loadDirectMessagesSent();
			
			MewSystem.microBlog.addEventListener(MicroBlogEvent.LOAD_DIRECT_MESSAGES_RECEIVED_RESULT, loadDirectMessageReceivedResult);
			MewSystem.microBlog.loadDirectMessagesReceived();
			
			MewSystem.microBlog.addEventListener(MicroBlogEvent.LOAD_FAVORITE_LIST_RESULT, loadFavoriteListResult);
			MewSystem.microBlog.loadFavoriteList();
			
			MewSystem.microBlog.addEventListener(MicroBlogEvent.LOAD_USER_TIMELINE_RESULT, loadUserTimeLineResult);
			MewSystem.microBlog.loadUserTimeline();
			
			MewSystem.microBlog.addEventListener(MicroBlogEvent.LOAD_FOLLOWERS_INFO_RESULT, loadFollowersInfoResult);
			MewSystem.microBlog.loadFollowersInfo(null, "0", null, -1, MewSystem.fansNum);
			
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
		}
		
		private function loadMentionTimeLine(event:MicroBlogEvent):void
		{
			MewSystem.microBlog.removeEventListener(MicroBlogEvent.LOAD_MENSIONS_RESULT, loadMentionTimeLine);
			var result:Array = event.result as Array;
			if(result && result.length) MewSystem.setLastId("mew_at", result);
			MewSystem.app.localWriter.writeData(result, "mew_at");
		}
		
		private function loadCommentsTimeLineResult(event:MicroBlogEvent):void
		{
			MewSystem.microBlog.removeEventListener(MicroBlogEvent.LOAD_COMMENTS_TO_ME_RESULT, loadCommentsTimeLineResult);
			var result:Array = event.result as Array;
			if(result && result.length){
				MewSystem.setLastId("mew_comment", result);
				MewSystem.setFinalId("mew_comment", result);
			}
			MewSystem.app.localWriter.writeData(result, "mew_comment");
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
			}else{
				tempArray = arr;
			}
		}
		
		private function loadDirectMessageReceivedResult(event:MicroBlogEvent):void
		{
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
		}
		
		private function loadUserTimeLineResult(event:MicroBlogEvent):void
		{
			MewSystem.microBlog.removeEventListener(MicroBlogEvent.LOAD_USER_TIMELINE_RESULT, loadUserTimeLineResult);
			var result:Array = event.result as Array;
			if(result && result.length) MewSystem.setFinalId("mew_user", result);
			MewSystem.app.localWriter.writeData(result, "mew_user");
		}
		
		private function loadFollowersInfoResult(event:MicroBlogEvent):void
		{
			MewSystem.microBlog.removeEventListener(MicroBlogEvent.LOAD_FOLLOWERS_INFO_RESULT, loadFollowersInfoResult);
			var result:Array = event.result as Array;
			if(result && result.length) MewSystem.setLastId("mew_fans", result);
			MewSystem.app.localWriter.writeData(result, "mew_fans");
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
		}
	}
}