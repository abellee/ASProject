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
				if(so.data.autoLogin != undefined) SystemSettingData.autoLogin = so.data.autoLogin;
				if(so.data.hideDirection != undefined) SystemSettingData.hideDirection = so.data.hideDirection;
				if(so.data.autoRun != undefined) SystemSettingData.autoRun = so.data.autoRun;
				if(so.data.checkUpdateDelay != undefined) SystemSettingData.checkUpdateDelay = so.data.checkUpdateDelay;
				if(so.data.autoHide != undefined) SystemSettingData.autoHide = so.data.autoHide;
				if(so.data.alwaysInfront != undefined) SystemSettingData.alwaysInfront = so.data.alwaysInfront;
				if(so.data.isVoice != undefined) SystemSettingData.isVoice = so.data.isVoice;
				if(so.data.atNotice != undefined) SystemSettingData.atNotice = so.data.atNotice;
				if(so.data.dmNotice != undefined) SystemSettingData.dmNotice = so.data.dmNotice;
				if(so.data.fansNotice != undefined) SystemSettingData.fansNotice = so.data.fansNotice;
				if(so.data.weiboNotice != undefined) SystemSettingData.weiboNotice = so.data.weiboNotice;
				if(so.data.commentNotice != undefined) SystemSettingData.commentNotice = so.data.commentNotice;
				if(so.data.skipVersionNumber != undefined) SystemSettingData.skipVersionNumber = so.data.skipVersionNumber;
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
		public static function setUserSharedObject(key:String, value:String, name:String, id:String):void
		{
			var so:SharedObject = SharedObject.getLocal(Config.MEWCACHE);
			so.data.accessTokenKey = key;
			so.data.accessTokenSecret = value;
			if(!so.data.user) so.data.user = {};
			if(!so.data.userTimes) so.data.userTimes = {};
			if(!so.data.user[key]) so.data.user[key] = {};
			for(var k:String in so.data.user) so.data.user[k]["default"] = false;
			so.data.user[key]["password"] = value;
			so.data.user[key]["username"] = name;
			so.data.user[key]["default"] = true;
			so.data.user[key]["id"] = id;
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
		public static function removeUserSharedObject(key:String, bool:Boolean):void
		{
			var so:SharedObject = SharedObject.getLocal(Config.MEWCACHE);
			if(bool){
				delete so.data.accessTokenKey;
				delete so.data.accessTokenSecret;
			}
			delete so.data.user[key];
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