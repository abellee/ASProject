package mew.windows {
	import flash.text.TextFieldAutoSize;
	import widget.Widget;
	import fl.containers.ScrollPane;
	import fl.controls.Button;
	import fl.events.ScrollEvent;

	import mew.factory.ButtonFactory;
	import mew.modules.WeiboEntry;
	import mew.modules.WeiboFormList;

	import resource.Resource;

	import system.MewSystem;

	import com.iabel.core.UISprite;
	import com.iabel.util.ScaleBitmap;
	import com.sina.microblog.data.MicroBlogStatus;

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
	import flash.text.TextField;
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
		private var position:String = null;
		private var sp:Sprite = new Sprite();
		private var scrollBarSkin:ScaleBitmap;
		private var closeButton:Button = null;
		private var showClose:Boolean = false;
		public function WeiboTextWindow(initOptions : NativeWindowInitOptions, pos:String = "top", showCloseButton:Boolean = false)
		{
			position = pos;
			showClose = showCloseButton;
			super(initOptions);
		}
		
		override protected function init():void
		{
			realHeight = Screen.mainScreen.visibleBounds.height - MewSystem.app.mainWindow.height - 100;
			drawBackground(465, 10, position);
			super.init();
			weiboEntry = new WeiboEntry(true);
			weiboEntry.finalStep = true;
			weiboEntry.x = 30;
			weiboEntry.y = 30;
			if(!scrollList) scrollList = new ScrollPane();
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
		
		override public function getContentWidth():Number
		{
			return 405;
		}
		
		public function loadData(data:MicroBlogStatus):void
		{
			var urlLoader:URLLoader = new URLLoader();
			var func:Function = function(event:Event):void
			{
				urlLoader.removeEventListener(Event.COMPLETE, func);
				var xml:XML = XML(urlLoader.data);
				weiboEntry.setSize(background.width - 40, 10);
				weiboEntry.initStatus(data, xml);
				weiboEntry.addEventListener(Event.RESIZE, onResize);
				addChild(weiboEntry);
				onResize();
				loadCommentListByPage();
			};
			urlLoader.addEventListener(Event.COMPLETE, func);
			urlLoader.load(new URLRequest("config/emotions.xml"));
		}
		
		override protected function drawBackground(w:int, h:int, pos:String = null):void
		{
			super.drawBackground(w, h, position);
			addChildAt(whiteBackground, 1);
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
			list.listData(commentList, getContentWidth(), xml, this, false);
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
			if(scrollList.content){
				scrollList.update();
				scrollList.drawNow();
			}
		}
		
		private function showScrollList():void
		{
			scrollList.source = list;
			weiboEntry.dispatchEvent(new Event(Event.RESIZE));
			scrollList.addEventListener(ScrollEvent.SCROLL, onScroll);
			addChild(scrollList);
			scrollList.setStyle("upSkin", getSprite(scrollList.width, scrollList.height));
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
		}

		private function onScroll(event : ScrollEvent) : void
		{
			if(scrollList.verticalScrollPosition >= scrollList.maxVerticalScrollPosition) loadCommentListByPage();
		}

		private function commentLoadError() : void
		{
			MewSystem.removeCycleLoading(container);
			MewSystem.showLightAlert("加载评论信息失败!", container);
		}
		
		protected function getSprite(w:int, h:int):Sprite
		{
			sp.graphics.clear();
			sp.graphics.beginFill(0x000000, 0);
			sp.graphics.drawRect(0, 0, w, h);
			sp.graphics.endFill();
			return sp;
		}

		private function onResize(event : Event = null) : void
		{
			var leftH:int = realHeight - weiboEntry.height - weiboEntry.y - 20;
			var scrollListHeight:int;
			if(list){
				if(list.height < leftH){
					scrollListHeight = list.height;
				}else{
					scrollListHeight = leftH < 30 ? 30 : leftH;
				}
			}
			scrollList.setSize(425, scrollListHeight);
			scrollList.move(30, weiboEntry.y + weiboEntry.height + 5);
			drawBackground(465, weiboEntry.y + weiboEntry.height + scrollList.height + 15);
			super.init();
		}
		
		override protected function dealloc(event:Event):void
		{
			super.dealloc(event);
			if(timer){
				timer.removeEventListener(TimerEvent.TIMER, resetLoadingState);
				timer = null;
			}
			if(list) list.removeEventListener(Event.RESIZE, listResize);
			if(scrollList) scrollList.removeEventListener(ScrollEvent.SCROLL, onScroll);
			if(weiboEntry) weiboEntry.removeEventListener(Event.RESIZE, onResize);
			weiboEntry = null;
			list = null;
			scrollList = null;
			timer = null;
			position = null;
			sp = null;
		}
	}
}
