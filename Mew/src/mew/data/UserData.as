package mew.data
{
	import com.sina.microblog.data.MicroBlogUser;
	
	import system.MewSystem;

	public class UserData
	{
		public var username:String = null;
		public var screenName:String = null;
		public var id:String = null;
		public var src:String = null;
		public var location:String = null;
		public var sex:String = null;
		public var domain:String = null;
		
		public var isVerified:Boolean = false;
		public var isFollowMe:Boolean = false;
		public var allowAllActMsg:Boolean = true;
		
		public var followNum:int = 0;
		public var fansNum:int = 0;
		public var tweetsNum:int = 0;
		public var collectionNum:int = 0;
		public var description:String = null;
		
		public var blogURL:String = null;
		
		public var status:WeiboData = null;
		
		public function UserData()
		{
		}
		
		public function init(user:MicroBlogUser):void
		{
			blogURL = user.url;
			location = user.location;
			collectionNum = user.favouritesCount;
			description = user.description;
			fansNum = user.followersCount;
			followNum = user.friendsCount;
			id = user.id;
			isVerified = user.isVerified;
			sex = user.gender;
			src = user.profileImageUrl;
			tweetsNum = user.statusesCount;
			username = user.name;
			screenName = user.screenName;
			isFollowMe = user.isFollowingMe;
			allowAllActMsg = user.allowAllActMsg;
			domain = user.domain;
			if(user.status) status = MewSystem.app.dataCache.getWeiboDataCache(user.status);
		}
		
		public function refreshUserData():void
		{
			
		}
		
		public function dealloc():void
		{
			username = null;
			screenName = null;
			id = null;
			src = null;
			location = null;
			sex = null;
			description = null;
			blogURL = null;
			if(status) status.dealloc();
			status = null;
		}
	}
}