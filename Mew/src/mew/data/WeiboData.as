package mew.data
{
	import com.sina.microblog.data.MicroBlogStatus;
	
	import system.MewSystem;

	public class WeiboData
	{
		public var id:String = null;
		public var content:String = null;
		public var imageData:ImageData = null;
		public var videoData:MediaData = null;
		public var musicData:MediaData = null;
		public var repostData:WeiboData = null;
		public var isCollected:Boolean = false;
		
		public var cid:String = null;               // 供微博发布器使用
		public var time:Number = 0;                 // 供定时微博发布器使用
		public var success:Boolean = false;         // 供定时微博发布器使用
		
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
		
		public function dealloc():void
		{
			content = null;
			id = null;
			if(imageData) imageData.dealloc();
			imageData = null;
			if(videoData) videoData.dealloc();
			videoData = null;
			if(musicData) musicData.dealloc();
			musicData = null;
			if(repostData) repostData.dealloc();
			repostData = null;
			cid = null;
		}
	}
}