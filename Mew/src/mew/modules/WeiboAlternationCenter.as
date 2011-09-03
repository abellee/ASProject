package mew.modules {
	import flash.display.DisplayObjectContainer;
	import mew.data.UserData;
	import com.sina.microblog.data.MicroBlogStatus;
	import system.MewSystem;

	import com.sina.microblog.events.MicroBlogErrorEvent;
	import com.sina.microblog.events.MicroBlogEvent;

	import flash.utils.ByteArray;

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
		
		public function loadCommentList(id:String, count:int, page:int, resultFunc:Function, errorFunc:Function, emotionXML:XML):void
		{
			var onResult:Function = function(event:MicroBlogEvent):void
			{
				MewSystem.microBlog.removeEventListener(MicroBlogEvent.LOAD_COMMENTS_RESULT, onResult);
				MewSystem.microBlog.removeEventListener(MicroBlogErrorEvent.LOAD_COMMENTS_ERROR, onError);
				resultFunc(event.result as Array, emotionXML);
			};
			var onError:Function = function(event:MicroBlogErrorEvent):void
			{
				MewSystem.microBlog.removeEventListener(MicroBlogEvent.LOAD_COMMENTS_RESULT, onResult);
				MewSystem.microBlog.removeEventListener(MicroBlogErrorEvent.LOAD_COMMENTS_ERROR, onError);
				errorFunc();
			};
			MewSystem.microBlog.addEventListener(MicroBlogEvent.LOAD_COMMENTS_RESULT, onResult);
			MewSystem.microBlog.addEventListener(MicroBlogErrorEvent.LOAD_COMMENTS_ERROR, onError);
			MewSystem.microBlog.loadCommentList(id, count, page);
		}
		
		public function loadStatusInfo(id:String, target:DisplayObjectContainer):void
		{
			var onResult:Function = function(event:MicroBlogEvent):void
			{
				MewSystem.microBlog.removeEventListener(MicroBlogEvent.LOAD_STATUS_INFO_RESULT, onResult);
				MewSystem.microBlog.removeEventListener(MicroBlogErrorEvent.LOAD_STATUS_INFO_ERROR, onError);
				MewSystem.app.statusInfoLoaded(event.result as MicroBlogStatus, target);
			};
			var onError:Function = function(event:MicroBlogErrorEvent):void
			{
				MewSystem.microBlog.removeEventListener(MicroBlogEvent.LOAD_STATUS_INFO_RESULT, onResult);
				MewSystem.microBlog.removeEventListener(MicroBlogErrorEvent.LOAD_STATUS_INFO_ERROR, onError);
				if(target) MewSystem.showLightAlert("加载微博信息失败!", target);
				MewSystem.removeCycleLoading(target);
			};
			MewSystem.microBlog.addEventListener(MicroBlogEvent.LOAD_STATUS_INFO_RESULT, onResult);
			MewSystem.microBlog.addEventListener(MicroBlogErrorEvent.LOAD_STATUS_INFO_ERROR, onError);
			MewSystem.microBlog.loadStatusInfo(id);
		}
		
		public function updateStatus(status:String, imageData:ByteArray = null, replyId:String = ""):void
		{
			MewSystem.microBlog.addEventListener(MicroBlogEvent.UPDATE_STATUS_RESULT, updateStatus_resultHandler);
			MewSystem.microBlog.addEventListener(MicroBlogErrorEvent.UPDATE_STATUS_ERROR, updateStatus_errorHandler);
			MewSystem.microBlog.updateStatus(status, null, imageData, replyId);
		}
		
		public function loadUserTimeline(id:String = null, userId:String = "0", screenName:String = null, sinceId:String = "0", maxId:String = "0", count:int = 20, page:int = 1):void
		{
			MewSystem.microBlog.addEventListener(MicroBlogEvent.LOAD_USER_TIMELINE_RESULT, loadUserTimeline_resultHandler);
			MewSystem.microBlog.addEventListener(MicroBlogErrorEvent.LOAD_USER_TIMELINE_ERROR, loadUserTimeline_errorHandler);
			MewSystem.microBlog.loadUserTimeline(id, userId, screenName, sinceId, maxId, count, page);
		}

		private function loadUserTimeline_errorHandler(event : MicroBlogErrorEvent) : void
		{
			MewSystem.microBlog.removeEventListener(MicroBlogEvent.LOAD_USER_TIMELINE_RESULT, loadUserTimeline_resultHandler);
			MewSystem.microBlog.removeEventListener(MicroBlogErrorEvent.LOAD_USER_TIMELINE_ERROR, loadUserTimeline_errorHandler);
			MewSystem.removeCycleLoading(null);
			MewSystem.showLightAlert("加载用户信息失败!", MewSystem.app.currentActiveWindow.container);
			MewSystem.app.showTargetUserWindow(null, null);
		}

		private function loadUserTimeline_resultHandler(event : MicroBlogEvent) : void
		{
			MewSystem.microBlog.removeEventListener(MicroBlogEvent.LOAD_USER_TIMELINE_RESULT, loadUserTimeline_resultHandler);
			MewSystem.microBlog.removeEventListener(MicroBlogErrorEvent.LOAD_USER_TIMELINE_ERROR, loadUserTimeline_errorHandler);
			MewSystem.removeCycleLoading(null);
			var arr:Array = event.result as Array;
			if(arr && arr.length){
				var ms:MicroBlogStatus = arr[0] as MicroBlogStatus;
				var ud:UserData = MewSystem.app.dataCache.getUserDataCache(ms.user, false);
				MewSystem.app.showTargetUserWindow(arr, ud);
			}
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