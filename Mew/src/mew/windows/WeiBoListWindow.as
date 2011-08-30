package mew.windows
{
	import com.iabel.component.VGroup;
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
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.Timer;
	
	import mew.modules.NameBox;
	import mew.modules.UserDescription;
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
		protected var userDescription:UserDescription = null;
		public function WeiBoListWindow(initOptions:NativeWindowInitOptions)
		{
			super(initOptions);
		}
		
		override protected function init():void
		{
			drawBackground(465, Screen.mainScreen.visibleBounds.height - MewSystem.app.height - 100);
			super.init();
			if(!scrollList) scrollList = new ScrollPane();
		}
		override public function getContentWidth():Number
		{
			return (background.width - scrollList.verticalScrollBar.width);
		}
		
		override public function showWeibo(arr:Array, content:UISprite):void
		{
			var xpos:int = 10;
			var ypos:int = 10;
			var hvalue:int = this.background.height;
			if(MewSystem.app.currentState == MewSystem.app.MY_WEIBO){
				if(!userDescription){
					userDescription = new UserDescription();
					userDescription.setSize(this.background.width, 10);
					userDescription.userData = MewSystem.app.userData;
					userDescription.showData();
					addChild(userDescription);
					userDescription.x = 10;
					userDescription.y = 20;
					ypos = userDescription.y + userDescription.height;
					hvalue = hvalue - userDescription.height - 10;
				}
			}
			list = content;
			list.addEventListener(Event.RESIZE, onResize);
			scrollList.addEventListener(ScrollEvent.SCROLL, onScroll);
			scrollList.source = list;
			scrollList.move(xpos, ypos);
			scrollList.setSize(this.background.width, hvalue);
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
				var urlLoader:URLLoader = new URLLoader();
				var func:Function = function(e:Event):void{
					urlLoader.removeEventListener(Event.COMPLETE, func);
					list.listData(tempArr, getContentWidth(), XML(e.target.data));
					urlLoader = null;
				}
				urlLoader.addEventListener(Event.COMPLETE, func);
				urlLoader.load(new URLRequest("config/emotions.xml"));
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
			if(!arr || !arr.length){
				if(curPage > 1) curPage--;
				return;
			}
			var urlLoader:URLLoader = new URLLoader();
			var func:Function = function(e:Event):void{
				urlLoader.removeEventListener(Event.COMPLETE, func);
				list.listData(arr, getContentWidth(), XML(e.target.data));
				return;
			}
			urlLoader.addEventListener(Event.COMPLETE, func);
			urlLoader.load(new URLRequest("config/emotions.xml"));
		}
		private function resetLoadingState(event:TimerEvent):void
		{
			timer.stop();
			dataLoading = false;
		}
		
		override protected function dealloc(event:Event):void
		{
			super.dealloc(event);
			if(timer){
				timer.stop();
				timer.removeEventListener(TimerEvent.TIMER, resetLoadingState);
				timer = null;
			}
			if(list) list = null;
			if(scrollList) scrollList = null;
			tempArr = null;
		}
	}
}