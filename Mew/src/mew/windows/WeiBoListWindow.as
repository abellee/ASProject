package mew.windows
{
	import com.iabel.component.VGroup;
	import com.iabel.core.ALSprite;
	import com.iabel.core.UISprite;
	import com.sina.microblog.data.MicroBlogStatus;
	import com.sina.microblog.events.MicroBlogEvent;
	import com.yahoo.astra.fl.containers.BorderPane;
	import com.yahoo.astra.fl.containers.VBoxPane;
	
	import fl.containers.ScrollPane;
	import fl.events.ScrollEvent;
	
	import flash.data.SQLResult;
	import flash.display.NativeWindowInitOptions;
	import flash.display.Screen;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.Timer;
	
	import mew.modules.NameBox;
	import mew.modules.WeiboEntry;
	import mew.modules.WeiboFormList;
	
	import system.MewSystem;
	
	public class WeiBoListWindow extends ALNativeWindow
	{
		private var list:UISprite;
		private var scrollList:ScrollPane;
		private var curPage:int = 1;
		private var dataLoading:Boolean = false;
		private var tempArr:Array = null;
		private var timer:Timer = new Timer(1000);
		public function WeiBoListWindow(initOptions:NativeWindowInitOptions)
		{
			super(initOptions);
//			this.stage.addEventListener(Event.RESIZE, onResize);
		}
		
//		private function onResize(event:Event):void
//		{
//			/*var preHeight:Number = scrollList.content.height;
//			var num:int = list.numChildren;
//			for(var i:int = 0; i<num; i++){
//				var child:WeiboEntry = list.getChildAt(i) as WeiboEntry;
//				child.x = 10;
//				if(i){
//					var pre:WeiboEntry = list.getChildAt(i - 1) as WeiboEntry;
//					child.y = pre.y + pre.height + 10;
//				}else{
//					child.y = 10;
//				}
//			}
//			if(scrollList){
//				if(scrollList.content.height != preHeight){
//					list.setSize(scrollList.width - scrollList.verticalScrollBar.width, Math.max(scrollList.content.height, preHeight), 0xff0000);
//					scrollList.source = list;
//					scrollList.update();
//				}
//			}*/
//		}
		
		override protected function init():void
		{
			super.init();
			if(!scrollList) scrollList = new ScrollPane();
		}
		override public function getContentWidth():Number
		{
			return (background.width - scrollList.verticalScrollBar.width);
		}
		
		override public function showWeibo(arr:Array, content:UISprite):void
		{
			list = content;
			list.addEventListener(Event.RESIZE, onResize);
			scrollList.addEventListener(ScrollEvent.SCROLL, onScroll);
			scrollList.source = list;
			scrollList.move(10, 10);
			scrollList.setSize(this.background.width, this.background.height);
			addChild(scrollList);
		}
		
		private function onScroll(event:ScrollEvent):void
		{
			if(scrollList.verticalScrollPosition >= scrollList.maxVerticalScrollPosition) loadDataByPage();
		}
		
		private function onResize(event:Event):void
		{
			scrollList.update();
			scrollList.drawNow();
		}
		
		private function loadDataByPage():void
		{
			if(dataLoading) return;
			dataLoading = true;
			curPage++;
			switch(MewSystem.app.currentState){
				case MewSystem.app.INDEX:
					MewSystem.microBlog.addEventListener(MicroBlogEvent.LOAD_FRIENDS_TIMELINE_RESULT, dataByPageLoadComplete);
					MewSystem.microBlog.loadFriendsTimeline("0", "0", 20, curPage);
					break;
				case MewSystem.app.AT:
					MewSystem.microBlog.addEventListener(MicroBlogEvent.LOAD_MENSIONS_RESULT, dataByPageLoadComplete);
					MewSystem.microBlog.loadMentions("0", "0", 20, curPage);
					break;
				case MewSystem.app.COMMENT_ME:
					MewSystem.microBlog.addEventListener(MicroBlogEvent.LOAD_COMMENTS_TO_ME_RESULT, dataByPageLoadComplete);
					MewSystem.microBlog.loadCommentsToMe("0", "0", 20, curPage);
					break;
				case MewSystem.app.COLLECT:
					MewSystem.microBlog.addEventListener(MicroBlogEvent.LOAD_FAVORITE_LIST_RESULT, dataByPageLoadComplete);
					MewSystem.microBlog.loadFavoriteList(curPage);
					break;
				case MewSystem.app.MY_WEIBO:
					MewSystem.microBlog.addEventListener(MicroBlogEvent.LOAD_USER_TIMELINE_RESULT, dataByPageLoadComplete);
					MewSystem.microBlog.loadUserTimeline(null, "0", null, "0", "0", 20, curPage);
					break;
				case MewSystem.app.DIRECT_MESSAGE:
					MewSystem.microBlog.addEventListener(MicroBlogEvent.LOAD_DIRECT_MESSAGES_SENT_RESULT, loadDirectMessageSentResult);
					MewSystem.microBlog.loadDirectMessagesSent("0", "0", 20, curPage);
					break;
				case MewSystem.app.FANS:
					trace(">>>>", curPage);
					MewSystem.microBlog.addEventListener(MicroBlogEvent.LOAD_FOLLOWERS_INFO_RESULT, dataByPageLoadComplete);
					MewSystem.microBlog.loadFollowersInfo(null, "0", null, 20 * (curPage - 1), 20);
					break;
				case MewSystem.app.FOLLOW:
					MewSystem.microBlog.addEventListener(MicroBlogEvent.LOAD_FRIENDS_INFO_RESULT, dataByPageLoadComplete);
					MewSystem.microBlog.loadFriendsInfo(null, "0", null, 20 * (curPage - 1), 20);
					break;
			}
		}
		
		private function loadDirectMessageSentResult(event:MicroBlogEvent):void
		{
			MewSystem.microBlog.removeEventListener(MicroBlogEvent.LOAD_DIRECT_MESSAGES_SENT_RESULT, loadDirectMessageSentResult);
			tempArr = event.result as Array;
			MewSystem.microBlog.addEventListener(MicroBlogEvent.LOAD_DIRECT_MESSAGES_RECEIVED_RESULT, loadDirectMessageReceivedResult);
			MewSystem.microBlog.loadDirectMessagesReceived("0", "0", 20, curPage);
		}
		
		private function loadDirectMessageReceivedResult(event:MicroBlogEvent):void
		{
			MewSystem.microBlog.removeEventListener(MicroBlogEvent.LOAD_DIRECT_MESSAGES_RECEIVED_RESULT, loadDirectMessageReceivedResult);
			var receivedArray:Array = event.result as Array;
			tempArr = tempArr.concat(receivedArray);
			if(tempArr && tempArr.length){
				tempArr.sortOn("id", Array.DESCENDING);
				list.listData(tempArr, getContentWidth());
			}else{
				if(curPage > 1) curPage--;
			}
			tempArr = null;
			dataLoading = false;
		}
		
		private function dataByPageLoadComplete(event:MicroBlogEvent):void
		{
			MewSystem.microBlog.removeEventListener(MicroBlogEvent.LOAD_FRIENDS_TIMELINE_RESULT, dataByPageLoadComplete);
			MewSystem.microBlog.removeEventListener(MicroBlogEvent.LOAD_MENSIONS_RESULT, dataByPageLoadComplete);
			MewSystem.microBlog.removeEventListener(MicroBlogEvent.LOAD_COMMENTS_TO_ME_RESULT, dataByPageLoadComplete);
			MewSystem.microBlog.removeEventListener(MicroBlogEvent.LOAD_FAVORITE_LIST_RESULT, dataByPageLoadComplete);
			MewSystem.microBlog.removeEventListener(MicroBlogEvent.LOAD_USER_TIMELINE_RESULT, dataByPageLoadComplete);
			MewSystem.microBlog.removeEventListener(MicroBlogEvent.LOAD_FOLLOWERS_INFO_RESULT, dataByPageLoadComplete);
			MewSystem.microBlog.removeEventListener(MicroBlogEvent.LOAD_FRIENDS_INFO_RESULT, dataByPageLoadComplete);
			if(!timer.hasEventListener(TimerEvent.TIMER)) timer.addEventListener(TimerEvent.TIMER, resetLoadingState);
			timer.reset();
			timer.start();
			var arr:Array = event.result as Array;
			trace(arr.length);
			if(!arr || !arr.length){
				if(curPage > 1) curPage--;
				return;
			}
			list.listData(arr, getContentWidth());
		}
		private function resetLoadingState(event:TimerEvent):void
		{
			dataLoading = false;
		}
		
		override protected function dealloc(event:Event):void
		{
			super.dealloc(event);
			timer.stop();
			timer.removeEventListener(TimerEvent.TIMER, resetLoadingState);
			timer = null;
		}
	}
}