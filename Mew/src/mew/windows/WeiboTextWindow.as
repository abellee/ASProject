package mew.windows {
	import fl.containers.ScrollPane;
	import fl.events.ScrollEvent;

	import mew.modules.WeiboEntry;
	import mew.modules.WeiboFormList;

	import system.MewSystem;

	import com.iabel.core.UISprite;
	import com.sina.microblog.data.MicroBlogStatus;

	import flash.display.NativeWindowInitOptions;
	import flash.display.Screen;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.Timer;

	/**
	 * @author Abel Lee
	 */
	public class WeiboTextWindow extends ALNativeWindow {
		private var weiboEntry:WeiboEntry = null;
		private var list:UISprite = null;
		private var scrollList:ScrollPane = null;
		private var curPage:int = 0;
		private var dataLoading:Boolean = false;
		private var timer:Timer = null;
		private var realHeight:int = 0;
		public function WeiboTextWindow(initOptions : NativeWindowInitOptions) {
			super(initOptions);
		}
		
		override protected function init():void
		{
			realHeight = Screen.mainScreen.visibleBounds.height - MewSystem.app.height - 100;
			drawBackground(465, 10);
			super.init();
			weiboEntry = new WeiboEntry();
			weiboEntry.x = 15;
			weiboEntry.y = 15;
			if(!scrollList) scrollList = new ScrollPane();
		}
		
		override public function getContentWidth():Number
		{
			return (465 - scrollList.verticalScrollBar.width);
		}
		
		public function loadData(data:MicroBlogStatus):void
		{
			var urlLoader:URLLoader = new URLLoader();
			var func:Function = function(event:Event):void
			{
				urlLoader.removeEventListener(Event.COMPLETE, func);
				var xml:XML = XML(urlLoader.data);
				weiboEntry.setSize(background.width - 10, 10);
				weiboEntry.initStatus(data, xml);
				weiboEntry.addEventListener(Event.RESIZE, onResize);
				addChild(weiboEntry);
				onResize();
				loadCommentListByPage();
			};
			urlLoader.addEventListener(Event.COMPLETE, func);
			urlLoader.load(new URLRequest("config/emotions.xml"));
		}
		
		private function loadCommentListByPage():void
		{
			if(dataLoading) return;
			dataLoading = true;
			curPage++;
			var urlLoader:URLLoader = new URLLoader();
			var func:Function = function(event:Event):void
			{
				urlLoader.removeEventListener(Event.COMPLETE, func);
				MewSystem.showCycleLoading(container);
				MewSystem.app.alternationCenter.loadCommentList(weiboEntry.data.id, MewSystem.wbCommentNum, curPage, listComments, commentLoadError, XML(urlLoader.data));
			};
			urlLoader.addEventListener(Event.COMPLETE, func);
			urlLoader.load(new URLRequest("config/emotions.xml"));
		}
		
		private function listComments(commentList:Array, xml:XML):void
		{
			if(!timer) timer = new Timer(1000);
			if(!timer.hasEventListener(TimerEvent.TIMER)) timer.addEventListener(TimerEvent.TIMER, resetLoadingState);
			timer.reset();
			timer.start();
			MewSystem.removeCycleLoading(container);
			if(!commentList || !commentList.length){
				if(curPage > 1) curPage--;
				return;
			}
			if(!list) list = new WeiboFormList();
			list.listData(commentList, getContentWidth(), xml, false);
			list.addEventListener(Event.RESIZE, listResize);
			if(curPage < 2) showScrollList();
		}
		
		private function resetLoadingState(event:TimerEvent):void
		{
			timer.stop();
			dataLoading = false;
		}
		
		private function listResize(event:Event):void
		{
			scrollList.update();
			scrollList.drawNow();
		}
		
		private function showScrollList():void
		{
			scrollList.source = list;
			weiboEntry.dispatchEvent(new Event(Event.RESIZE));
			scrollList.addEventListener(ScrollEvent.SCROLL, onScroll);
			addChild(scrollList);
		}

		private function onScroll(event : ScrollEvent) : void
		{
			if(scrollList.verticalScrollPosition >= scrollList.maxVerticalScrollPosition) loadCommentListByPage();
		}

		private function commentLoadError() : void
		{
			MewSystem.showLightAlert("加载评论信息失败!", container);
		}

		private function onResize(event : Event = null) : void
		{
			var leftH:int = realHeight - weiboEntry.height - weiboEntry.y;
			var scrollListHeight:int;
			if(list){
				if(list.height < leftH){
					scrollListHeight = list.height;
				}else{
					scrollListHeight = leftH < 30 ? 30 : leftH;
				}
			}
			scrollList.setSize(465, scrollListHeight);
			scrollList.move(10, weiboEntry.y + weiboEntry.height + 5);
			
			drawBackground(465, weiboEntry.height + (scrollList.height + 15));
			super.init();
		}
	}
}
