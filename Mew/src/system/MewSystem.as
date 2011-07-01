package system
{
	import com.sina.microblog.MicroBlog;
	
	import config.Config;
	
	import flash.display.DisplayObjectContainer;
	
	import mew.cache.AssetsCache;
	import mew.communication.SQLiteManager;
	import mew.modules.Alert;
	import mew.modules.LightAlert;
	import mew.update.Update;

	public class MewSystem
	{
		public static var microBlog:MicroBlog = null;
		public static var app:Mew = null;
		
		public static var themeRes:Object = null;
		
		public static var lightAlert:LightAlert = null;
		public static var alert:Alert = null;
		
		public static function initMicroBlog():void
		{
			if(!microBlog) microBlog = new MicroBlog();
			microBlog.source = Config.appKey;
			microBlog.consumerKey = Config.appKey;
			microBlog.consumerSecret = Config.appSecret;
			microBlog.isTrustDomain = true;
		}
		
		public static function show(text:String, parent:DisplayObjectContainer):void
		{
			if(!parent.contains(alert)) parent.addChild(alert);
			alert.show(text);
		}
	}
}