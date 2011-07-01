package mew.cache
{
	import com.sina.microblog.data.MicroBlogStatus;
	import com.sina.microblog.data.MicroBlogUser;
	
	import mew.data.UserData;
	import mew.data.WeiboData;

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
		public function getUserDataCache(user:MicroBlogUser):UserData
		{
			return userDataCache[user.id] ? userDataCache[user.id] : cacheUserData(user);
		}
		private function cacheUserData(user:MicroBlogUser):UserData
		{
			var userData:UserData = new UserData();
			userData.init(user);
			userDataCache[userData.id] = userData;
			
			return userData;
		}
		
		public function getWeiboDataCache(status:MicroBlogStatus):WeiboData
		{
			return weiboDataCache[status.id] ? weiboDataCache[status.id] : cacheWeiboData(status);
		}
		private function cacheWeiboData(status:MicroBlogStatus):WeiboData
		{
			var weiboData:WeiboData = new WeiboData();
			weiboData.init(status);
			weiboDataCache[status.id] = weiboData;
			
			return weiboData;
		}
	}
}