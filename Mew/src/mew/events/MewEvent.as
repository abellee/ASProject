package mew.events
{
	import flash.events.Event;
	
	public class MewEvent extends Event
	{
		public static const USER_HOME:String = "user_home";
		public static const USER_FOLLOW:String = "user_follow";
		public static const USER_FANS:String = "user_fans";
		
		public static const SYSTEM:String = "system";
		public static const ACCOUNT:String = "account";
		public static const NOTICE:String = "notice";
		
		public static const SCREEN_SHOT:String = "screen_shot";
		public static const EMOTION:String = "emotion";
		public static const TOPIC:String = "topic";
		public static const CLEAR_CONTENT:String = "clear_content";
		public static const SHORT_URL:String = "short_url";
		
		public static const SHORTEN_URL_SUCCESS:String = "shorten_url_success";
		
		public static const SUGGESTION_SUCCESS:String = "suggestion_success";
		public static const NO_SUGGESTION:String = "no_suggestion";
		public static const SUGGESTION_FAILED:String = "suggestion_failed";
		
		public static const PLAY_VIDEO:String = "play_video";
		
		public static const SEARCH_USER:String = "search_user";
		public static const SEARCH_USER_ERROR:String = "search_user_error";
		public static const SEARCH_WEIBO:String = "search_weibo";
		public static const SEARCH_WEIBO_ERROR:String = "search_weibo_error";
		
		public static const REPOST_STATUS:String = "repost_status";
		public static const COMMENT_STATUS:String = "comment_status";
		public static const COLLECT_STATUS:String = "collect_status";
		public static const DELETE_STATUS:String = "delete_status";
		public static const DIRECT_MESSAGE:String = "direct_message";
		
		public static const DELETE:String = "delete";
		
		public function MewEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
		override public function clone():Event
		{
			return new MewEvent(type, bubbles, cancelable);
		}
	}
}