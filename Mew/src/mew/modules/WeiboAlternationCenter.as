package mew.modules {
	import mew.events.MewEvent;
	import flash.net.URLLoader;
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
		
		public function repostStatus(id:String, status:String, isComment:int = 0, report:Boolean = true):void
		{
			var onResult:Function = function(event:MicroBlogEvent):void
			{
				MewSystem.microBlog.removeEventListener(MewEvent.REPOST_SUCCESS, onResult);
				MewSystem.microBlog.removeEventListener(MewEvent.REPOST_FAILED, onError);
				if(report){
					if(MewSystem.app.weiboPublishWindow) MewSystem.app.weiboPublishWindow.showResult(1);
				}
			};
			var onError:Function = function(event:MicroBlogErrorEvent):void
			{
				MewSystem.microBlog.removeEventListener(MewEvent.REPOST_SUCCESS, onResult);
				MewSystem.microBlog.removeEventListener(MewEvent.REPOST_FAILED, onError);
				if(report){
					if(MewSystem.app.weiboPublishWindow) MewSystem.app.weiboPublishWindow.showResult(0);
				}
			};
			MewSystem.microBlog.addEventListener(MewEvent.REPOST_SUCCESS, onResult);
			MewSystem.microBlog.addEventListener(MewEvent.REPOST_FAILED, onError);
			var obj:Object = {};
			obj.id = id;
			obj.status = status;
			obj.is_comment = isComment;
			MewSystem.microBlog.callGeneralApi(MewSystem.repostURL, obj, MewEvent.REPOST_SUCCESS, MewEvent.REPOST_FAILED);
		}
		
		public function commentStatus(id:String, comment:String, cid:String = "0", commentOrigin:int = 0, report:Boolean = true):void
		{
			var onResult:Function = function(event:MicroBlogEvent):void
			{
				MewSystem.microBlog.removeEventListener(MewEvent.COMMENT_SUCCESS, onResult);
				MewSystem.microBlog.removeEventListener(MewEvent.COMMENT_FAILED, onError);
				if(report && MewSystem.app.weiboPublishWindow) MewSystem.app.weiboPublishWindow.showResult(1);
			};
			var onError:Function = function(event:MicroBlogErrorEvent):void
			{
				MewSystem.microBlog.removeEventListener(MewEvent.COMMENT_SUCCESS, onResult);
				MewSystem.microBlog.removeEventListener(MewEvent.COMMENT_FAILED, onError);
				if(report && MewSystem.app.weiboPublishWindow) MewSystem.app.weiboPublishWindow.showResult(0);
			};
			MewSystem.microBlog.addEventListener(MewEvent.COMMENT_SUCCESS, onResult);
			MewSystem.microBlog.addEventListener(MewEvent.COMMENT_FAILED, onError);
			var obj:Object = {};
			obj.id = id;
			obj.comment = comment;
			if(cid && cid != "0") obj.cid = cid;
			obj.comment_ori = commentOrigin;
			MewSystem.microBlog.callGeneralApi(MewSystem.commentURL, obj, MewEvent.COMMENT_SUCCESS, MewEvent.COMMENT_FAILED);
		}
		
		public function deleteComment(id:String, container:DisplayObjectContainer):void
		{
			var onResult:Function = function(event:MicroBlogEvent):void
			{
				trace("delete comment success!");
				MewSystem.microBlog.removeEventListener(MicroBlogEvent.DELETE_COMMENT_RESULT, onResult);
				MewSystem.microBlog.removeEventListener(MicroBlogErrorEvent.DELETE_COMMENT_ERROR, onError);
				if(container) MewSystem.showLightAlert("删除评论成功!", container);
			};
			var onError:Function = function(event:MicroBlogErrorEvent):void
			{
				trace("delete comment failed!");
				MewSystem.microBlog.removeEventListener(MicroBlogEvent.DELETE_COMMENT_RESULT, onResult);
				MewSystem.microBlog.removeEventListener(MicroBlogErrorEvent.DELETE_COMMENT_ERROR, onError);
				if(container) MewSystem.showLightAlert("删除评论失败!", container);
			};
			MewSystem.microBlog.addEventListener(MicroBlogEvent.DELETE_COMMENT_RESULT, onResult);
			MewSystem.microBlog.addEventListener(MicroBlogErrorEvent.DELETE_COMMENT_ERROR, onError);
			MewSystem.microBlog.deleteComment(id);
		}
		
		public function deleteStatus(id:String, container:DisplayObjectContainer):void
		{
			var onResult:Function = function(event:MicroBlogEvent):void
			{
				trace("delete status success!");
				MewSystem.microBlog.removeEventListener(MicroBlogEvent.DELETE_STATUS_RESULT, onResult);
				MewSystem.microBlog.removeEventListener(MicroBlogErrorEvent.DELETE_STATUS_ERROR, onError);
				if(container) MewSystem.showLightAlert("删除微博成功!", container);
			};
			var onError:Function = function(event:MicroBlogErrorEvent):void
			{
				trace("delete status failed!");
				MewSystem.microBlog.removeEventListener(MicroBlogEvent.DELETE_STATUS_RESULT, onResult);
				MewSystem.microBlog.removeEventListener(MicroBlogErrorEvent.DELETE_STATUS_ERROR, onError);
				if(container) MewSystem.showLightAlert("删除微博失败!", container);
			};
			MewSystem.microBlog.addEventListener(MicroBlogEvent.DELETE_STATUS_RESULT, onResult);
			MewSystem.microBlog.addEventListener(MicroBlogErrorEvent.DELETE_STATUS_ERROR, onError);
			MewSystem.microBlog.deleteStatus(id);
		}
		
		public function removeFavorite(id:String, container:DisplayObjectContainer):void
		{
			var onResult:Function = function(event:MicroBlogEvent):void
			{
				MewSystem.microBlog.removeEventListener(MicroBlogEvent.REMOVE_FROM_FAVORITES_RESULT, onResult);
				MewSystem.microBlog.removeEventListener(MicroBlogErrorEvent.REMOVE_FROM_FAVORITES_ERROR, onError);
				if(container) MewSystem.showLightAlert("取消收藏成功!", container);
			};
			var onError:Function = function(event:MicroBlogErrorEvent):void
			{
				MewSystem.microBlog.removeEventListener(MicroBlogEvent.REMOVE_FROM_FAVORITES_RESULT, onResult);
				MewSystem.microBlog.removeEventListener(MicroBlogErrorEvent.REMOVE_FROM_FAVORITES_ERROR, onError);
				if(container) MewSystem.showLightAlert("取消收藏失败!", container);
			};
			MewSystem.microBlog.addEventListener(MicroBlogEvent.REMOVE_FROM_FAVORITES_RESULT, onResult);
			MewSystem.microBlog.addEventListener(MicroBlogErrorEvent.REMOVE_FROM_FAVORITES_ERROR, onError);
			MewSystem.microBlog.removeFromFavorites(id);
		}
		
		public function deleteDirectMessage(id:String, container:DisplayObjectContainer):void
		{
			var onResult:Function = function(event:MicroBlogEvent):void
			{
				trace("delete DM success!");
				MewSystem.microBlog.removeEventListener(MicroBlogEvent.DELETE_DIRECT_MESSAGE_RESULT, onResult);
				MewSystem.microBlog.removeEventListener(MicroBlogErrorEvent.DELETE_DIRECT_MESSAGE_ERROR, onError);
				if(container) MewSystem.showLightAlert("取消私信成功!", container);
			};
			var onError:Function = function(event:MicroBlogErrorEvent):void
			{
				trace("delete DM failed!");
				MewSystem.microBlog.removeEventListener(MicroBlogEvent.DELETE_DIRECT_MESSAGE_RESULT, onResult);
				MewSystem.microBlog.removeEventListener(MicroBlogErrorEvent.DELETE_DIRECT_MESSAGE_ERROR, onError);
				if(container) MewSystem.showLightAlert("取消私信失败!", container);
			};
			MewSystem.microBlog.addEventListener(MicroBlogEvent.DELETE_DIRECT_MESSAGE_RESULT, onResult);
			MewSystem.microBlog.addEventListener(MicroBlogErrorEvent.DELETE_DIRECT_MESSAGE_ERROR, onError);
			MewSystem.microBlog.deleteDirectMessage(id);
		}
		
		public function collectStatus(id:String, container:DisplayObjectContainer):void
		{
			var onResult:Function = function(event:MicroBlogEvent):void
			{
				trace("add favorite success!");
				MewSystem.microBlog.removeEventListener(MicroBlogEvent.ADD_TO_FAVORITES_RESULT, onResult);
				MewSystem.microBlog.removeEventListener(MicroBlogErrorEvent.ADD_TO_FAVORITES_ERROR, onError);
				if(container) MewSystem.showLightAlert("收藏微博成功!", container);
			};
			var onError:Function = function(event:MicroBlogErrorEvent):void
			{
				trace("add favorite failed!");
				MewSystem.microBlog.removeEventListener(MicroBlogEvent.ADD_TO_FAVORITES_RESULT, onResult);
				MewSystem.microBlog.removeEventListener(MicroBlogErrorEvent.ADD_TO_FAVORITES_ERROR, onError);
				if(container) MewSystem.showLightAlert("收藏微博失败!", container);
			};
			MewSystem.microBlog.addEventListener(MicroBlogEvent.ADD_TO_FAVORITES_RESULT, onResult);
			MewSystem.microBlog.addEventListener(MicroBlogErrorEvent.ADD_TO_FAVORITES_ERROR, onError);
			MewSystem.microBlog.addToFavorites(id);
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
		
		public function updateStatus(status:String, imageData:ByteArray = null, replyId:String = "", target:IWeiboPublish = null):void
		{
			var successFunc:Function = function(event:MicroBlogEvent):void
			{
				MewSystem.microBlog.removeEventListener(MicroBlogEvent.UPDATE_STATUS_RESULT, successFunc);
				MewSystem.microBlog.removeEventListener(MicroBlogErrorEvent.UPDATE_STATUS_ERROR, errorFunc);
				if(MewSystem.app.weiboPublishWindow) MewSystem.app.weiboPublishWindow.showResult(1);
				else if(target) target.updateSuccess();
			};
			var errorFunc:Function = function(event:MicroBlogErrorEvent):void
			{
				MewSystem.microBlog.removeEventListener(MicroBlogEvent.UPDATE_STATUS_RESULT, successFunc);
				MewSystem.microBlog.removeEventListener(MicroBlogErrorEvent.UPDATE_STATUS_ERROR, errorFunc);
				if(MewSystem.app.weiboPublishWindow) MewSystem.app.weiboPublishWindow.showResult(0);
				else if(target) target.updateFailed();
			};
			MewSystem.microBlog.addEventListener(MicroBlogEvent.UPDATE_STATUS_RESULT, successFunc);
			MewSystem.microBlog.addEventListener(MicroBlogErrorEvent.UPDATE_STATUS_ERROR, errorFunc);
			MewSystem.microBlog.updateStatus(status, null, imageData, replyId);
		}
		
		public function loadUserTimeline(id:String = null, userId:String = "0", screenName:String = null,
		 sinceId:String = "0", maxId:String = "0", count:int = 20, page:int = 1):void
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
	}
}