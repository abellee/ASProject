package mew.data
{
	import com.sina.microblog.data.MicroBlogStatus;
	
	import system.MewSystem;

	public class WeiboData
	{
		public var content:String = null;
		public var id:String = null;
		public var isCollected:Boolean = false;
		public var imageData:ImageData = null;
		public var videoData:MediaData = null;
		public var musicData:MediaData = null;
		public var repostData:WeiboData = null;
		public var height:int = 0;
		public var y:int = 0;
		public function WeiboData()
		{
		}
		
		public function init(status:MicroBlogStatus):void
		{
			content = status.text;
			id = status.id;
			isCollected = status.isFavorited;
			
			if(status.thumbPicUrl){
				imageData = new ImageData();
				imageData.midURL = status.bmiddlePicUrl;
				imageData.thumbURL = status.thumbPicUrl;
				imageData.originURL = status.originalPicUrl;
			}
			
			if(status.repost){
				repostData = MewSystem.app.dataCache.getWeiboDataCache(status.repost);
			}
		}
	}
}