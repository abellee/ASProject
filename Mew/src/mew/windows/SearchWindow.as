package mew.windows {
	import fl.containers.ScrollPane;
	import fl.controls.Button;
	import fl.events.ScrollEvent;

	import mew.data.UserData;
	import mew.events.MewEvent;
	import mew.factory.ButtonFactory;
	import mew.modules.UserFormList;
	import mew.modules.WeiboFormList;

	import resource.Resource;

	import system.MewSystem;

	import widget.Widget;

	import com.iabel.core.UISprite;
	import com.iabel.utils.ScaleBitmap;
	import com.sina.microblog.data.MicroBlogStatus;
	import com.sina.microblog.data.MicroBlogUser;
	import com.sina.microblog.events.MicroBlogErrorEvent;
	import com.sina.microblog.events.MicroBlogEvent;

	import mx.utils.StringUtil;

	import flash.display.Bitmap;
	import flash.display.NativeWindowInitOptions;
	import flash.display.Screen;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Rectangle;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.ui.Keyboard;
	import flash.utils.Timer;

	/**
	 * @author Abel Lee
	 */
	public class SearchWindow extends ALNativeWindow {
		
		private var searchBackground : Sprite = null;
		private var searchWeiboButton : Button = null;
		private var searchUserButton : Button = null;
		private var searchButton : Button = null;
		private var inputText : TextField = null;
		private var inputBackground : Sprite = null;
		
		private var weiboPath : String = "/statuses/search.xml";
		private var userPath : String = "/users/search.xml";
		
		private var clicked : Boolean = false;
		private var preButton : Button = null;
		
		private var curPath:String = weiboPath;
		private var curPage:int = 0;
		private var curQ:String = "";
		
		private var list:UISprite;
		private var scrollList:ScrollPane;
		private var dataLoading:Boolean = false;
		private var timer:Timer = new Timer(1000);
		
		private var desH : int;
		private var scrollBarSkin : ScaleBitmap;
		
		public function SearchWindow(initOptions : NativeWindowInitOptions) {
			super(initOptions);
		}
		
		override protected function init():void
		{
			drawBackground(465, 50, "top");
			super.init();
			if(!scrollList) scrollList = new ScrollPane();
			drawSearchBackground();
			
			if(!searchWeiboButton) searchWeiboButton = ButtonFactory.WhiteButton();
			if(!searchUserButton) searchUserButton = ButtonFactory.WhiteButton();
			if(!searchButton) searchButton = ButtonFactory.SearchButton();
			if(!inputText) inputText = new TextField();
			
			searchWeiboButton.width = 60;
			searchUserButton.width = 60;
			searchWeiboButton.label = "搜微博";
			searchUserButton.label = "找人";
			searchWeiboButton.setStyle("textFormat", Widget.normalFormat);
			searchWeiboButton.setStyle("disabledTextFormat", Widget.normalFormat);
			searchUserButton.setStyle("textFormat", Widget.normalFormat);
			searchUserButton.setStyle("disabledTextFormat", Widget.normalFormat);
			
			inputText.defaultTextFormat = Widget.searchGrayFormat;
			inputText.type = TextFieldType.INPUT;
			inputText.text = "搜索微博、找人";
			inputText.height = inputText.textHeight + 5;
			
			addChild(searchUserButton);
			addChild(searchWeiboButton);
			addChild(searchButton);
			addChild(inputText);
			
			searchWeiboButton.x = 20;
			searchWeiboButton.y = 20;
			
			searchUserButton.x = searchWeiboButton.x + searchWeiboButton.width;
			searchUserButton.y = searchWeiboButton.y;
			
			var w:int = background.width - 30 - searchUserButton.width - searchWeiboButton.width - searchButton.width;
			var h:int = searchWeiboButton.height;
			drawInputBackground(w, h);
			addChild(inputBackground);
			inputBackground.x = searchUserButton.x + searchUserButton.width + 5;
			inputBackground.y = searchUserButton.y;
			
			addChild(inputText);
			inputText.width = inputBackground.width - 10;
			inputText.x = inputBackground.x + 5;
			inputText.y = inputBackground.y + (inputBackground.height - inputText.height) / 2;
			
			searchButton.x = inputBackground.x + inputBackground.width;
			searchButton.y = inputBackground.y + (inputBackground.height - searchButton.height) / 2;
			
			searchWeiboButton.setMouseState("selectedUp");
			searchWeiboButton.enabled = false;
			preButton = searchWeiboButton;
			
			inputText.addEventListener(MouseEvent.MOUSE_DOWN, onMouseClick);
			inputText.addEventListener(FocusEvent.FOCUS_OUT, onFocusOut);
			inputText.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			
			searchUserButton.addEventListener(MouseEvent.CLICK, onButtonClick);
			searchWeiboButton.addEventListener(MouseEvent.CLICK, onButtonClick);
			
			searchButton.addEventListener(MouseEvent.CLICK, searchResult);
		}
		
		override public function getContentWidth():Number
		{
			return (background.width - 60);
		}
		
		protected function getSprite(w:int, h:int):Sprite
		{
			var sp:Sprite = new Sprite();
			sp.graphics.beginFill(0x000000, 0);
			sp.graphics.drawRect(0, 0, w, h);
			sp.graphics.endFill();
			return sp;
		}
		
		override public function showWeibo(arr:Array, content:UISprite, ud:UserData = null):void
		{
			var xpos:int = 30;
			var ypos:int = searchBackground.y + searchBackground.height + 10;
			desH = Screen.mainScreen.visibleBounds.height - MewSystem.app.height - 100;
			scrollList.source = list;
			list.addEventListener(Event.RESIZE, onResize);
			scrollList.addEventListener(ScrollEvent.SCROLL, onScroll);
			if(background.height < desH){
				drawBackground(465, desH, "top");
				super.init();
				scrollList.move(xpos, ypos);
				addChild(scrollList);
				scrollList.setSize(this.background.width - 40, desH - searchBackground.height - searchBackground.y - 20);
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
		}
		
		public function search(topic:String):void
		{
			inputText.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_DOWN));
			inputText.text = topic;
			searchButton.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
		}
		
		private function onResize(event:Event):void
		{
			scrollList.update();
			scrollList.drawNow();
		}
		
		private function onScroll(event:ScrollEvent):void
		{
			if(scrollList.verticalScrollPosition >= scrollList.maxVerticalScrollPosition) loadDataByPage();
		}
		
		private function searchResult(event:MouseEvent):void
		{
			if(!clicked) return;
			curQ = inputText.text.replace(/\s/g, "");
			if(curQ == "") return;
			
			curQ = inputText.text;
			curQ = StringUtil.trim(curQ);
			if(scrollList && scrollList.verticalScrollPosition) scrollList.verticalScrollPosition = 0;
			if(list){
				scrollList.source = null;
				list.removeAllChildren();
				list = null;
			}
			curPage = 0;
			loadDataByPage();
		}
		
		private function loadDataByPage():void
		{
			if(dataLoading) return;
			dataLoading = true;
			curPage++;
			var obj:Object = {};
			obj.q = curQ;
			obj.page = curPage;
			MewSystem.showCycleLoading(container);
			if(curPath == weiboPath){
				obj.count = MewSystem.statusNum;
				MewSystem.microBlog.addEventListener(MewEvent.SEARCH_WEIBO, onSearchWeibo);
				MewSystem.microBlog.addEventListener(MewEvent.SEARCH_WEIBO_ERROR, onSearchWeiboError);
				MewSystem.microBlog.callGeneralApi(curPath, obj, MewEvent.SEARCH_WEIBO, MewEvent.SEARCH_WEIBO_ERROR);
			}else{
				obj.count = MewSystem.fansNum;
				MewSystem.microBlog.addEventListener(MewEvent.SEARCH_USER, onSearchUser);
				MewSystem.microBlog.addEventListener(MewEvent.SEARCH_USER_ERROR, onSearchUserError);
				MewSystem.microBlog.callGeneralApi(curPath, obj, MewEvent.SEARCH_USER, MewEvent.SEARCH_USER_ERROR);
			}
		}
		
		private function onSearchWeiboError(event : MicroBlogErrorEvent) : void
		{
			MewSystem.microBlog.removeEventListener(MewEvent.SEARCH_WEIBO, onSearchWeibo);
			MewSystem.microBlog.removeEventListener(MewEvent.SEARCH_WEIBO_ERROR, onSearchWeiboError);
			MewSystem.removeCycleLoading(container);
			if(curPage > 1) curPage--;
			dataLoading = false;
			MewSystem.showLightAlert("微博信息加载失败!", container);
		}
		
		private function onSearchWeibo(event : MicroBlogEvent) : void
		{
			MewSystem.microBlog.removeEventListener(MewEvent.SEARCH_WEIBO, onSearchWeibo);
			MewSystem.microBlog.removeEventListener(MewEvent.SEARCH_WEIBO_ERROR, onSearchWeiboError);
			var xmlList:XMLList = XML(event.result).statuses.children();
			var arr:Array = [];
			if(!timer.hasEventListener(TimerEvent.TIMER)) timer.addEventListener(TimerEvent.TIMER, resetLoadingState);
			timer.reset();
			timer.start();
			if(xmlList && xmlList.length()){
				for each(var xml:XML in xmlList){
					var mb:MicroBlogStatus = new MicroBlogStatus();
					mb.init(xml);
					arr.push(mb);
				}
			}
			MewSystem.removeCycleLoading(container);
			if(!arr || !arr.length){
				if(curPage > 1) curPage--;
				return;
			}
			trace(curPage + "_________");
			if(arr.length){
				if(list is UserFormList || !list){
					if(list) list.removeAllChildren();
					list = new WeiboFormList();
				}
				var win:ALNativeWindow = this.stage.nativeWindow as ALNativeWindow;
				var urlLoader:URLLoader = new URLLoader();
				var func:Function = function(event:Event):void
				{
					urlLoader.removeEventListener(Event.COMPLETE, func);
					var emotionXML:XML = XML(urlLoader.data);
					list.listData(arr, getContentWidth(), emotionXML, win);
					if(curPage < 2) showWeibo(arr, list, null);
					else{
						scrollList.update();
						scrollList.drawNow();
					}
				};
				urlLoader.addEventListener(Event.COMPLETE, func);
				urlLoader.load(new URLRequest("config/emotions.xml"));
			}
		}
		
		private function onSearchUserError(event : MicroBlogErrorEvent) : void
		{
			MewSystem.microBlog.removeEventListener(MewEvent.SEARCH_USER, onSearchUser);
			MewSystem.microBlog.removeEventListener(MewEvent.SEARCH_USER_ERROR, onSearchUserError);
			MewSystem.removeCycleLoading(container);
			if(curPage > 1) curPage--;
			dataLoading = false;
			MewSystem.showLightAlert("微博用户加载失败!", container);
		}
		
		private function onSearchUser(event : MicroBlogEvent) : void
		{
			MewSystem.microBlog.removeEventListener(MewEvent.SEARCH_USER, onSearchUser);
			MewSystem.microBlog.removeEventListener(MewEvent.SEARCH_USER_ERROR, onSearchUserError);
			var xmlList:XMLList = XML(event.result).users.children();
			var arr:Array = [];
			if(!timer.hasEventListener(TimerEvent.TIMER)) timer.addEventListener(TimerEvent.TIMER, resetLoadingState);
			timer.reset();
			timer.start();
			if(xmlList && xmlList.length()){
				for each(var xml:XML in xmlList){
					var user:MicroBlogUser = new MicroBlogUser();
					user.init(xml);
					arr.push(user);
				}
			}
			MewSystem.removeCycleLoading(container);
			if(!arr || !arr.length){
				if(curPage > 1) curPage--;
				return;
			}
			if(arr.length){
				if(!(list is UserFormList) || !list){
					if(list) list.removeAllChildren();
					list = new UserFormList();
				}
				list.listData(arr, getContentWidth(), null, this);
				if(curPage < 2) showWeibo(arr, list, null);
				else{
					scrollList.update();
					scrollList.drawNow();
				}
			}
		}

		private function resetLoadingState(event : TimerEvent) : void
		{
			timer.stop();
			dataLoading = false;
		}

		private function onButtonClick(event : MouseEvent) : void
		{
			var btn:Button = event.currentTarget as Button;
			btn.setMouseState("selectedUp");
			btn.enabled = false;
			if(btn == searchWeiboButton) curPath = weiboPath;
			else curPath = userPath;
			if(preButton && preButton != btn){
				preButton.setMouseState("up");
				preButton.enabled = true;
				searchButton.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
			}
			preButton = btn;
		}

		private function onKeyDown(event : KeyboardEvent) : void
		{
			if(event.keyCode == Keyboard.ENTER) searchButton.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
		}

		private function onMouseClick(event : MouseEvent) : void
		{
			if(!clicked){
				inputText.defaultTextFormat = Widget.searchFormat;
				inputText.text = "";
				clicked = true;
			}
		}

		private function onFocusOut(event : FocusEvent) : void
		{
			var str:String = inputText.text.replace(/\s/g, "");
			if(clicked && str == ""){
				inputText.defaultTextFormat = Widget.searchGrayFormat;
				inputText.text = "搜索微博、找人";
				clicked = false;
			}
		}
		
		private function drawInputBackground(w:int, h:int):void
		{
			if(!inputBackground) inputBackground = new Sprite();
			inputBackground.graphics.clear();
			inputBackground.graphics.beginFill(0xFFFFFF);
			inputBackground.graphics.drawRect(0, 0, w, h);
			inputBackground.graphics.endFill();
		}
		
		private function drawSearchBackground():void
		{
			if(!searchBackground) searchBackground = new Sprite();
			searchBackground.graphics.clear();
			searchBackground.graphics.beginFill(Widget.mainColor, 1.0);
			searchBackground.graphics.drawRoundRectComplex(0, 0, background.width, 50, 12, 12, 12, 12);
			searchBackground.graphics.endFill();
			addChildAt(searchBackground, 2);
			searchBackground.x = 10;
			searchBackground.y = 10;
		}
		
		override protected function dealloc(event:Event):void
		{
			super.dealloc(event);
			
			MewSystem.microBlog.removeEventListener(MewEvent.SEARCH_USER, onSearchUser);
			MewSystem.microBlog.removeEventListener(MewEvent.SEARCH_USER_ERROR, onSearchUserError);
			MewSystem.microBlog.removeEventListener(MewEvent.SEARCH_WEIBO, onSearchWeibo);
			MewSystem.microBlog.removeEventListener(MewEvent.SEARCH_WEIBO_ERROR, onSearchWeiboError);
			
			if(list) list.removeEventListener(Event.RESIZE, onResize);
			scrollList.removeEventListener(ScrollEvent.SCROLL, onScroll);
			
			searchBackground = null;
			inputBackground = null;
			weiboPath = null;
			userPath = null;
			preButton = null;
			curPath = null;	
			curQ = null;
			list = null;
			scrollList = null;
			if(timer){
				timer.stop();
				timer.removeEventListener(TimerEvent.TIMER, resetLoadingState);
				timer = null;
			}
			if(inputText){
				inputText.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseClick);
				inputText.removeEventListener(FocusEvent.FOCUS_OUT, onFocusOut);
				inputText.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
				inputText = null;
			}
			if(searchUserButton) searchUserButton.removeEventListener(MouseEvent.CLICK, onButtonClick);
			if(searchWeiboButton) searchWeiboButton.removeEventListener(MouseEvent.CLICK, onButtonClick);
			if(searchButton) searchButton.removeEventListener(MouseEvent.CLICK, searchResult);
			searchWeiboButton = null;
			searchUserButton = null;
			searchButton = null;
			if(scrollBarSkin && scrollBarSkin.bitmapData) scrollBarSkin.bitmapData.dispose();
			scrollBarSkin = null;
		}
	}
}
