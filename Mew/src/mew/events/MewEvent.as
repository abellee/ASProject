package mew.events
{
	import flash.events.Event;
	
	public class MewEvent extends Event
	{
		public static const USER_HOME:String = "user_home";
		public static const USER_PROFILE:String = "user_profile";
		public static const USER_FOLLOW:String = "user_follow";
		public static const USER_FANS:String = "user_fans";
		public static const USER_COLLECT:String = "user_collect";
		
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
		public static const SUGGESTION_FAILED:String = "suggestion_failed";
		
		public function MewEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}