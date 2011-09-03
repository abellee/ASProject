package mew.communication
{
	import config.Config;
	
	import flash.net.SharedObject;
	
	import mew.data.SystemSettingData;

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
					SystemSettingData._accessTokenKey = so.data.accessTokenKey;
					SystemSettingData._accessTokenSecret = so.data.accessTokenSecret;
					SystemSettingData._verified = true;
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
		public static function setUserSharedObject(key:String, value:String, name:String):void
		{
			var so:SharedObject = SharedObject.getLocal(Config.MEWCACHE);
			if(!so.data.user) so.data.user = {};
			if(!so.data.userTimes) so.data.userTimes = {};
			if(!so.data.user[key]) so.data.user[key] = {};
			else{
				for(var k:String in so.data.user){
					so.data.user[k]["default"] = false;
				}
			}
			so.data.user[key]["password"] = value;
			so.data.user[key]["username"] = name;
			so.data.user[key]["default"] = true;
			if(!so.data.userTimes[key]) so.data.userTimes[key] = 0;
			else{
				if(so.data.userTimes[key] < 3) so.data.userTimes[key] = so.data.userTimes[key] + 1;
				else{
					if(so.data.userTimes[key] < 4){
						//TODO: 弹出询问框 是否推荐Mew微博 当关闭后再询问 是否关注开发者
					}else{
						so.data.userTimes[key] = 4;
					}
				}
			}
			so.flush();
			so.close();
		}
		public static function getUserAccount():Object
		{
			var so:SharedObject = SharedObject.getLocal(Config.MEWCACHE);
			var obj:Object = so.data.user;
			so.flush();
			so.close();
			return obj;
		}
	}
}