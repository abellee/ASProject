package mew.windows {
	import fl.containers.ScrollPane;
	import fl.controls.Button;
	import fl.events.ScrollEvent;

	import mew.data.UserData;
	import mew.events.MewEvent;
	import mew.factory.ButtonFactory;
	import mew.modules.UserDescription;
	import mew.modules.UserFormList;
	import mew.modules.WeiboFormList;

	import resource.Resource;

	import system.MewSystem;

	import com.iabel.core.UISprite;
	import com.iabel.utils.ScaleBitmap;
	import com.sina.microblog.events.MicroBlogEvent;

	import flash.display.Bitmap;
	import flash.display.NativeWindowInitOptions;
	import flash.display.Screen;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Rectangle;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.Timer;
	
	public class WeiBoListWindow extends ALNativeWindow
	{
		private var list:UISprite;
		private var scrollList:ScrollPane;
		private var curPage:int = 1;
		private var dataLoading:Boolean = false;
		private var tempArr:Array = null;
		private var timer:Timer = new Timer(1000);
		protected var userDescription:UserDescription = null;
		private var curUserData:UserData = null;
		private var curState:String = MewSystem.app.INDEX;
		private var preState:String = MewSystem.app.INDEX;
		private var desH:int;
		private var position:String = null;
		private var scrollBarSkin:ScaleBitmap = null;
		private var closeButton:Button = null;
		private var showClose:Boolean = false;
		public function WeiBoListWindow(initOptions:NativeWindowInitOptions, pos:String = "top", showCloseButton:Boolean = false)
		{
			position = pos;
			showClose = showCloseButton;
			super(initOptions);
		}
		
		override protected function init():void
		{
			drawBackground(465, Screen.mainScreen.visibleBounds.height - MewSystem.app.height - 100, position);
			super.init();
			if(!scrollList) scrollList = new ScrollPane();
			scrollBarSkin = new ScaleBitmap((new Resource.ScrollBarSkin() as Bitmap).bitmapData, "auto", true);
			scrollBarSkin.scale9Grid = new Rectangle(0, 10, 16, 10);
			scrollList.setStyle("thumbUpSkin", scrollBarSkin);
			scrollList.setStyle("thumbOverSkin", scrollBarSkin);
			scrollList.setStyle("thumbDownSkin", scrollBarSkin);
			scrollList.setStyle("thumbIcon", new Sprite());
			scrollList.setStyle("trackUpSkin", new Sprite());
			scrollList.setStyle("trackOverSkin", new Sprite());
			scrollList.setStyle("trackDownSkin", new Sprite());
			scrollList.setStyle("upArrowUpSkin", new Sprite());
			scrollList.setStyle("upArrowOverSkin", new Sprite());
			scrollList.setStyle("upArrowDownSkin", new Sprite());
			scrollList.setStyle("downArrowUpSkin", new Sprite());
			scrollList.setStyle("downArrowOverSkin", new Sprite());
			scrollList.setStyle("downArrowDownSkin", new Sprite());
			
			
			
			if(showClose){
				closeButton = ButtonFactory.CloseButton();
				addChild(closeButton);
				closeButton.x = 465 - closeButton.width;
				closeButton.y = 20;
				closeButton.addEventListener(MouseEvent.CLICK, closeCurrentWindow);
			}
		}
		private function closeCurrentWindow(event:MouseEvent):void
		{
			MewSystem.app.closeWidgetWindow();
		}
		protected function getSprite(w:int, h:int):Sprite
		{
			var sp:Sprite = new Sprite();
			sp.graphics.beginFill(0x000000, 0);
			sp.graphics.drawRect(0, 0, w, h);
			sp.graphics.endFill();
			return sp;
		}
		
		override public function reload():void
		{
			scrollList.source = null;
			list = null;
		}
		override public function getContentWidth():Number
		{
			return (background.width - 60);
		}
		
		override public function showWeibo(arr:Array, content:UISprite, ud:UserData = null):void
		{
			var xpos:int = 30;
			var ypos:int = 30;
			desH = this.background.height;
			if(ud){                                                                 // 其它用户
				if(!userDescription){
					userDescription = new UserDescription();
					userDescription.setSize(this.background.width - 40, 10);
					curUserData = ud;
					userDescription.userData = ud;
					userDescription.showData();
					addChild(userDescription);
					userDescription.x = 30;
					userDescription.y = 30;
					addListener();
				}
				desH = desH - userDescription.height;
				ypos = userDescription.y + userDescription.height;
			}else if(MewSystem.app.currentState == MewSystem.app.MY_WEIBO){         // 当前用户
				if(!userDescription){
					userDescription = new UserDescription();
					userDescription.setSize(this.background.width - 40, 10);
					curUserData = MewSystem.app.userData;
					userDescription.userData = MewSystem.app.userData;
					userDescription.showData();
					addChild(userDescription);
					userDescription.x = 30;
					userDescription.y = 30;
					addListener();
				}
				desH = desH - userDescription.height;
				ypos = userDescription.y + userDescription.height;
			}
			list = content;
			list.addEventListener(Event.RESIZE, onResize);
			scrollList.addEventListener(ScrollEvent.SCROLL, onScroll);
			scrollList.source = list;
			scrollList.move(xpos, ypos);
			scrollList.setSize(this.background.width - 40, desH - 40);
			scrollList.setStyle("upSkin", getSprite(scrollList.width, scrollList.height));
			addChild(scrollList);
		}
		
		override protected function drawBackground(w:int, h:int, position:String = null):void
		{
			super.drawBackground(w, h, position);
			if(!triangle) addChildAt(whiteBackground, 1);
		}
		
		private function addListener():void
		{
			userDescription.addEventListener(MewEvent.USER_FANS, showUserFans);
			userDescription.addEventListener(MewEvent.USER_FOLLOW, showUserFollow);
			userDescription.addEventListener(MewEvent.USER_HOME, showUserHome);
		}

		private function showUserHome(event : MewEvent) : void
		{
			if(curState == MewSystem.app.INDEX) return;
			curState = MewSystem.app.INDEX;
			list.removeAllChildren();
			list = new WeiboFormList();
			resetAndLoad();
		}

		private function showUserFollow(event : MewEvent) : void
		{
			if(curState == MewSystem.app.FOLLOW) return;
			curState = MewSystem.app.FOLLOW;
			list.removeAllChildren();
			list = new UserFormList();
			resetAndLoad();
		}

		private function showUserFans(event : MewEvent) : void
		{
			if(curState == MewSystem.app.FANS) return;
			curState = MewSystem.app.FANS;
			list.removeAllChildren();
			list = new UserFormList();
			resetAndLoad();
		}
		
		private function resetAndLoad():void
		{
			scrollList.source = list;
			scrollList.setSize(this.background.width - 40, desH - 40);
			curPage = 0;
			loadDataByPage();
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
			if(dataLoading && preState == curState) return;
			dataLoading = true;
			curPage++;
			if(curUserData){
				trace(curState, curPage);
				switch(curState){
					case MewSystem.app.INDEX:
						preState = MewSystem.app.INDEX;
						MewSystem.microBlog.addEventListener(MicroBlogEvent.LOAD_USER_TIMELINE_RESULT, dataByPageLoadComplete);
						MewSystem.microBlog.loadUserTimeline(curUserData.id, "0", null, "0", "0", MewSystem.statusNum, curPage);
						break;
					case MewSystem.app.FANS:
						preState = MewSystem.app.FANS;
						MewSystem.microBlog.addEventListener(MicroBlogEvent.LOAD_FOLLOWERS_INFO_RESULT, dataByPageLoadComplete);
						MewSystem.microBlog.loadFollowersInfo(curUserData.id, "0", null, MewSystem.fansNum * (curPage - 1), MewSystem.fansNum);
						break;
					case MewSystem.app.FOLLOW:
						preState = MewSystem.app.FOLLOW;
						MewSystem.microBlog.addEventListener(MicroBlogEvent.LOAD_FRIENDS_INFO_RESULT, dataByPageLoadComplete);
						MewSystem.microBlog.loadFriendsInfo(curUserData.id, "0", null, MewSystem.followNum * (curPage - 1), MewSystem.followNum);
						break;
				}
				MewSystem.showCycleLoading(container);
				return;
			}
			switch(MewSystem.app.currentState){
				case MewSystem.app.INDEX:
					MewSystem.microBlog.addEventListener(MicroBlogEvent.LOAD_FRIENDS_TIMELINE_RESULT, dataByPageLoadComplete);
					MewSystem.microBlog.loadFriendsTimeline("0", "0", MewSystem.statusNum, curPage);
					break;
				case MewSystem.app.AT:
					MewSystem.microBlog.addEventListener(MicroBlogEvent.LOAD_MENSIONS_RESULT, dataByPageLoadComplete);
					MewSystem.microBlog.loadMentions("0", "0", MewSystem.atNum, curPage);
					break;
				case MewSystem.app.COMMENT:
					MewSystem.microBlog.addEventListener(MicroBlogEvent.LOAD_COMMENTS_TIMELINE_RESULT, dataByPageLoadComplete);
					MewSystem.microBlog.loadCommentsTimeline("0", "0", MewSystem.commentNum, curPage);
					break;
				case MewSystem.app.COLLECT:
					MewSystem.microBlog.addEventListener(MicroBlogEvent.LOAD_FAVORITE_LIST_RESULT, dataByPageLoadComplete);
					MewSystem.microBlog.loadFavoriteList(curPage);
					break;
				case MewSystem.app.MY_WEIBO:
					MewSystem.microBlog.addEventListener(MicroBlogEvent.LOAD_USER_TIMELINE_RESULT, dataByPageLoadComplete);
					MewSystem.microBlog.loadUserTimeline(null, "0", null, "0", "0", MewSystem.userStatusNum, curPage);
					break;
				case MewSystem.app.DIRECT_MESSAGE:
					MewSystem.microBlog.addEventListener(MicroBlogEvent.LOAD_DIRECT_MESSAGES_SENT_RESULT, loadDirectMessageSentResult);
					MewSystem.microBlog.loadDirectMessagesSent("0", "0", MewSystem.directMessageNum, curPage);
					break;
				case MewSystem.app.FANS:
					MewSystem.microBlog.addEventListener(MicroBlogEvent.LOAD_FOLLOWERS_INFO_RESULT, dataByPageLoadComplete);
					MewSystem.microBlog.loadFollowersInfo(null, "0", null, MewSystem.fansNum * (curPage - 1), MewSystem.fansNum);
					break;
				case MewSystem.app.FOLLOW:
					MewSystem.microBlog.addEventListener(MicroBlogEvent.LOAD_FRIENDS_INFO_RESULT, dataByPageLoadComplete);
					MewSystem.microBlog.loadFriendsInfo(null, "0", null, MewSystem.followNum * (curPage - 1), MewSystem.followNum);
					break;
			}
			MewSystem.showCycleLoading(container);
		}
		
		private function loadDirectMessageSentResult(event:MicroBlogEvent):void
		{
			MewSystem.microBlog.removeEventListener(MicroBlogEvent.LOAD_DIRECT_MESSAGES_SENT_RESULT, loadDirectMessageSentResult);
			tempArr = event.result as Array;
			MewSystem.microBlog.addEventListener(MicroBlogEvent.LOAD_DIRECT_MESSAGES_RECEIVED_RESULT, loadDirectMessageReceivedResult);
			MewSystem.microBlog.loadDirectMessagesReceived("0", "0", MewSystem.directMessageNum, curPage);
		}
		
		private function loadDirectMessageReceivedResult(event:MicroBlogEvent):void
		{
			MewSystem.microBlog.removeEventListener(MicroBlogEvent.LOAD_DIRECT_MESSAGES_RECEIVED_RESULT, loadDirectMessageReceivedResult);
			var receivedArray:Array = event.result as Array;
			if(timer && !timer.hasEventListener(TimerEvent.TIMER)) timer.addEventListener(TimerEvent.TIMER, resetLoadingState);
			timer.reset();
			timer.start();
			MewSystem.removeCycleLoading(container);
			tempArr = tempArr.concat(receivedArray);
			if(tempArr && tempArr.length){
				tempArr.sortOn("id", Array.DESCENDING);
				var urlLoader:URLLoader = new URLLoader();
				var func:Function = function(e:Event):void{
					urlLoader.removeEventListener(Event.COMPLETE, func);
					list.listData(tempArr, getContentWidth(), XML(e.target.data), this);
					scrollList.update();
					scrollList.drawNow();
					urlLoader = null;
					tempArr = null;
				};
				urlLoader.addEventListener(Event.COMPLETE, func);
				urlLoader.load(new URLRequest("config/emotions.xml"));
			}else{
				if(curPage > 1) curPage--;
			}
		}
		
		private function dataByPageLoadComplete(event:MicroBlogEvent):void
		{
			MewSystem.microBlog.removeEventListener(MicroBlogEvent.LOAD_FRIENDS_TIMELINE_RESULT, dataByPageLoadComplete);
			MewSystem.microBlog.removeEventListener(MicroBlogEvent.LOAD_MENSIONS_RESULT, dataByPageLoadComplete);
			MewSystem.microBlog.removeEventListener(MicroBlogEvent.LOAD_COMMENTS_TIMELINE_RESULT, dataByPageLoadComplete);
			MewSystem.microBlog.removeEventListener(MicroBlogEvent.LOAD_FAVORITE_LIST_RESULT, dataByPageLoadComplete);
			MewSystem.microBlog.removeEventListener(MicroBlogEvent.LOAD_USER_TIMELINE_RESULT, dataByPageLoadComplete);
			MewSystem.microBlog.removeEventListener(MicroBlogEvent.LOAD_FOLLOWERS_INFO_RESULT, dataByPageLoadComplete);
			MewSystem.microBlog.removeEventListener(MicroBlogEvent.LOAD_FRIENDS_INFO_RESULT, dataByPageLoadComplete);
			if(timer && !timer.hasEventListener(TimerEvent.TIMER)) timer.addEventListener(TimerEvent.TIMER, resetLoadingState);
			timer.reset();
			timer.start();
			MewSystem.removeCycleLoading(container);
			var arr:Array = event.result as Array;
			if(!arr || !arr.length){
				if(curPage > 1) curPage--;
				return;
			}
			var win:ALNativeWindow = this;
			var urlLoader:URLLoader = new URLLoader();
			var func:Function = function(e:Event):void{
				urlLoader.removeEventListener(Event.COMPLETE, func);
				list.listData(arr, getContentWidth(), XML(e.target.data), win);
				scrollList.update();
				scrollList.drawNow();
				return;
			};
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
			if(scrollList){
				scrollList.removeEventListener(ScrollEvent.SCROLL, onScroll);
				scrollList = null;
			}
			tempArr = null;
			curUserData = null;
			if(userDescription){
				userDescription.removeEventListener(MewEvent.USER_FANS, showUserFans);
				userDescription.removeEventListener(MewEvent.USER_FOLLOW, showUserFollow);
				userDescription.removeEventListener(MewEvent.USER_HOME, showUserHome);
			}
			userDescription = null;
			if(scrollBarSkin && scrollBarSkin.bitmapData) scrollBarSkin.bitmapData.dispose();
			scrollBarSkin = null;
			if(closeButton){
				closeButton.removeEventListener(MouseEvent.CLICK, closeCurrentWindow);
				closeButton = null;
			}
		}
	}
}