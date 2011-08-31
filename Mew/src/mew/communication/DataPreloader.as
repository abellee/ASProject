package mew.communication {
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
			MewSystem.microBlog.addEventListener(MicroBlogEvent.LOAD_FRIENDS_TIMELINE_RESULT, loadFriendTimeLine);
			MewSystem.microBlog.loadFriendsTimeline();
			
			MewSystem.microBlog.addEventListener(MicroBlogEvent.LOAD_MENSIONS_RESULT, loadMesionTimeLine);
			MewSystem.microBlog.loadMentions();
			
			MewSystem.microBlog.addEventListener(MicroBlogEvent.LOAD_COMMENTS_TO_ME_RESULT, loadCommentsToMeResult);
			MewSystem.microBlog.loadCommentsToMe();
			
			MewSystem.microBlog.addEventListener(MicroBlogEvent.LOAD_MY_COMMENTS_RESULT, loadCommentsResult);
			MewSystem.microBlog.loadMyComments();
			
			MewSystem.microBlog.addEventListener(MicroBlogEvent.LOAD_DIRECT_MESSAGES_SENT_RESULT, loadDirectMessageSentResult);
			MewSystem.microBlog.loadDirectMessagesSent();
			
			MewSystem.microBlog.addEventListener(MicroBlogEvent.LOAD_DIRECT_MESSAGES_RECEIVED_RESULT, loadDirectMessageReceivedResult);
			MewSystem.microBlog.loadDirectMessagesReceived();
			
			MewSystem.microBlog.addEventListener(MicroBlogEvent.LOAD_FAVORITE_LIST_RESULT, loadFavoriteListResult);
			MewSystem.microBlog.loadFavoriteList();
			
			MewSystem.microBlog.addEventListener(MicroBlogEvent.LOAD_USER_TIMELINE_RESULT, loadUserTimeLineResult);
			MewSystem.microBlog.loadUserTimeline();
			
			MewSystem.microBlog.addEventListener(MicroBlogEvent.LOAD_FOLLOWERS_INFO_RESULT, loadFollowersInfoResult);
			MewSystem.microBlog.loadFollowersInfo(null, "0", null, -1, 30);
			
			MewSystem.microBlog.addEventListener(MicroBlogEvent.LOAD_FRIENDS_INFO_RESULT, loadFriendsInfoResult);
			MewSystem.microBlog.loadFriendsInfo(null, "0", null, -1, 30);
		}
		
		private function loadFriendTimeLine(event:MicroBlogEvent):void
		{
			MewSystem.microBlog.removeEventListener(MicroBlogEvent.LOAD_FRIENDS_TIMELINE_RESULT, loadFriendTimeLine);
			var result:Array = event.result as Array;
			insertToDB("mew_index", result);
		}
		
		private function loadMesionTimeLine(event:MicroBlogEvent):void
		{
			MewSystem.microBlog.removeEventListener(MicroBlogEvent.LOAD_MENSIONS_RESULT, loadMesionTimeLine);
			var result:Array = event.result as Array;
			insertToDB("mew_at", result);
		}
		
		private function loadCommentsToMeResult(event:MicroBlogEvent):void
		{
			MewSystem.microBlog.removeEventListener(MicroBlogEvent.LOAD_COMMENTS_TO_ME_RESULT, loadCommentsToMeResult);
			var result:Array = event.result as Array;
			insertToDB("mew_commentme", result);
		}
		
		private function loadCommentsResult(event:MicroBlogEvent):void
		{
			MewSystem.microBlog.removeEventListener(MicroBlogEvent.LOAD_MY_COMMENTS_RESULT, loadCommentsResult);
			var result:Array = event.result as Array;
			insertToDB("mew_comment", result);
		}
		
		private function loadDirectMessageSentResult(event:MicroBlogEvent):void
		{
			MewSystem.microBlog.removeEventListener(MicroBlogEvent.LOAD_DIRECT_MESSAGES_SENT_RESULT, loadDirectMessageSentResult);
			var result:Array = event.result as Array;
			insertToDB("mew_dmsent", result);
		}
		
		private function loadDirectMessageReceivedResult(event:MicroBlogEvent):void
		{
			MewSystem.microBlog.removeEventListener(MicroBlogEvent.LOAD_DIRECT_MESSAGES_RECEIVED_RESULT, loadDirectMessageReceivedResult);
			var result:Array = event.result as Array;
			insertToDB("mew_dmreceived", result);
		}
		
		private function loadFavoriteListResult(event:MicroBlogEvent):void
		{
			MewSystem.microBlog.removeEventListener(MicroBlogEvent.LOAD_FAVORITE_LIST_RESULT, loadFavoriteListResult);
			var result:Array = event.result as Array;
			insertToDB("mew_collect", result);
		}
		
		private function loadUserTimeLineResult(event:MicroBlogEvent):void
		{
			MewSystem.microBlog.removeEventListener(MicroBlogEvent.LOAD_USER_TIMELINE_RESULT, loadUserTimeLineResult);
			var result:Array = event.result as Array;
			insertToDB("mew_user", result);
		}
		
		private function loadFollowersInfoResult(event:MicroBlogEvent):void
		{
			MewSystem.microBlog.removeEventListener(MicroBlogEvent.LOAD_FOLLOWERS_INFO_RESULT, loadFollowersInfoResult);
			var result:Array = event.result as Array;
			trace(result.length);
			insertToDB("mew_fans", result);
		}
		
		private function loadFriendsInfoResult(event:MicroBlogEvent):void
		{
			MewSystem.microBlog.removeEventListener(MicroBlogEvent.LOAD_FRIENDS_INFO_RESULT, loadFriendsInfoResult);
			var result:Array = event.result as Array;
			insertToDB("mew_follow", result);
		}
		
		private function insertToDB(table:String, result:Array):void
		{
			if(result && result.length){
				var mainObj:Object = {};
				mainObj["fileName"] = table;
				var obj:Object = {};
				var len:int = result.length;
				for(var i:int = 0; i<len; i++){
					obj[result[i].id] = result[i];
				}
				mainObj["data"] = obj;
				MewSystem.app.localWriter.writeData(mainObj);
			}
		}
	}
}