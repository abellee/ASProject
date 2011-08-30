package mew.modules
{
	import com.sina.microblog.events.MicroBlogErrorEvent;
	import com.sina.microblog.events.MicroBlogEvent;
	
	import flash.utils.ByteArray;
	
	import mew.windows.ALNativeWindow;
	
	import system.MewSystem;

	public class WeiboAlternationCenter
	{
		public function WeiboAlternationCenter()
		{
		}
		
		public function repostStatus(id:String, status:String, isComment:int = 0):void
		{
			
		}
		
		public function commentStatus(id:String, comment:String, cid:String = "0"):void
		{
			
		}
		
		public function deleteComment(id:String):void
		{
			
		}
		
		public function updateStatus(status:String, imageData:ByteArray = null, replyId:String = ""):void
		{
			MewSystem.microBlog.addEventListener(MicroBlogEvent.UPDATE_STATUS_RESULT, updateStatus_resultHandler);
			MewSystem.microBlog.addEventListener(MicroBlogErrorEvent.UPDATE_STATUS_ERROR, updateStatus_errorHandler);
			MewSystem.microBlog.updateStatus(status, null, imageData, replyId);
		}
		
		private function updateStatus_resultHandler(event:MicroBlogEvent):void
		{
			MewSystem.microBlog.removeEventListener(MicroBlogEvent.UPDATE_STATUS_RESULT, updateStatus_resultHandler);
			MewSystem.microBlog.removeEventListener(MicroBlogErrorEvent.UPDATE_STATUS_ERROR, updateStatus_errorHandler);
			if(MewSystem.app.weiboPublishWindow) MewSystem.app.weiboPublishWindow.showResult(1);
		}
		
		private function updateStatus_errorHandler(event:MicroBlogErrorEvent):void
		{
			MewSystem.microBlog.removeEventListener(MicroBlogEvent.UPDATE_STATUS_RESULT, updateStatus_resultHandler);
			MewSystem.microBlog.removeEventListener(MicroBlogErrorEvent.UPDATE_STATUS_ERROR, updateStatus_errorHandler);
			if(MewSystem.app.weiboPublishWindow) MewSystem.app.weiboPublishWindow.showResult(0);
		}
	}
}