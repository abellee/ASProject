package mew.cache
{
	import com.sina.microblog.data.MicroBlogStatus;
	import com.sina.microblog.data.MicroBlogUser;
	
	import mew.data.UserData;
	import mew.data.WeiboData;
	
	import system.MewSystem;

	public class DataCache
	{
		private var userDataCache:Object = null;
		private var weiboDataCache:Object = null;
		public function DataCache()
		{
			init();
		}
		private function init():void
		{
			userDataCache = {};
			weiboDataCache = {};
		}
		public function getUserDataCache(user:MicroBlogUser, cache:Boolean = true):UserData
		{
			if(!cache){
				if(userDataCache[user.id]) return userDataCache[user.id];
				var userData:UserData = new UserData();
				userData.init(user);
				return userData;
			}
			return userDataCache[user.id] ? userDataCache[user.id] : cacheUserData(user);
		}
		private function cacheUserData(user:MicroBlogUser):UserData
		{
			var userData:UserData = new UserData();
			userData.init(user);
			userDataCache[userData.id] = userData;
			
			return userData;
		}
		
		public function getWeiboDataCache(status:MicroBlogStatus, cache:Boolean = true):WeiboData
		{
			if(!cache){
				if(weiboDataCache[status.id]) return weiboDataCache[status.id];
				var weiboData:WeiboData = new WeiboData();
				weiboData.init(status);
				return weiboData;
			}
			return weiboDataCache[status.id] ? weiboDataCache[status.id] : cacheWeiboData(status);
		}
		private function cacheWeiboData(status:MicroBlogStatus):WeiboData
		{
			var weiboData:WeiboData = new WeiboData();
			weiboData.init(status);
			weiboDataCache[status.id] = weiboData;
			
			return weiboData;
		}
		
		public function destroy():void
		{
			for(var key:String in userDataCache){
				var udc:UserData = userDataCache[key] as UserData;
				if(udc.id == MewSystem.app.userData.id) continue;
				if(udc) udc.dealloc();
				userDataCache[key] = null;
				delete userDataCache[key];
			}
			for(var k:String in weiboDataCache){
				var wdc:WeiboData = weiboDataCache[k] as WeiboData;
				if(wdc) wdc.dealloc();
				weiboDataCache[k] = null;
				delete weiboDataCache[k];
			}
		}
	}
}