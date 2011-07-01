package mew.communication
{
	import config.Config;
	
	import flash.net.SharedObject;

	public class LocalManager
	{
		public function LocalManager()
		{
		}
		
		public static function settingsBySharedObject():void
		{
			var so:SharedObject = SharedObject.getLocal(Config.MEWCACHE);
			if(so.data){
				if(so.data.accessTokenKey && so.data.accessTokenSecret){
					Config._accessTokenKey = so.data.accessTokenKey;
					Config._accessTokenSecret = so.data.accessTokenSecret;
					Config._verified = true;
				}
			}
			so.close();
		}
		public static function getSettingsInSharedObject(key:String):Object
		{
			var so:SharedObject = SharedObject.getLocal(Config.MEWCACHE);
			if(so.data && so.data[key]){
				var res:Object = so.data[key];
				so.close();
				return res;
			}else{
				so.close();
				return null;
			}
		}
		public static function setSettingsInSharedObject(key:String, value:Object):void
		{
			var so:SharedObject = SharedObject.getLocal(Config.MEWCACHE);
			so.data[key] = value;
			so.flush();
			so.close();
		}
	}
}