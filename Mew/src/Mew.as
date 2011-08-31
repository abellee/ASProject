package {
	import flash.geom.Point;
	import fl.controls.Button;

	import mew.cache.AssetsCache;
	import mew.cache.DataCache;
	import mew.cache.WeiboDataCacher;
	import mew.communication.DataPreloader;
	import mew.communication.LocalManager;
	import mew.data.SystemSettingData;
	import mew.data.UserData;
	import mew.modules.FloatUserInfo;
	import mew.modules.UserFormList;
	import mew.modules.WeiboAlternationCenter;
	import mew.modules.WeiboFormList;
	import mew.update.Update;
	import mew.windows.ALNativeWindow;
	import mew.windows.AboutWindow;
	import mew.windows.DropListWindow;
	import mew.windows.EmotionWindow;
	import mew.windows.ImageViewer;
	import mew.windows.LoginWindow;
	import mew.windows.SystemSetting;
	import mew.windows.ThemeWindow;
	import mew.windows.TimingWeiboWindow;
	import mew.windows.UpdateWindow;
	import mew.windows.VideoViewer;
	import mew.windows.WeiBoListWindow;
	import mew.windows.WeiBoPublisher;

	import system.MewSystem;
	import system.TimingWeiboManager;

	import widget.Widget;

	import com.greensock.TweenLite;

	import flash.display.DisplayObject;
	import flash.display.NativeWindowInitOptions;
	import flash.display.NativeWindowType;
	import flash.display.Screen;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.text.StyleSheet;
	
	[SWF(frameRate=30)]
	public class Mew extends Sprite
	{
		private var loginPanel:LoginWindow;               // 登录界面
		public var imageViewer:ImageViewer;                // 查看大图界面 
		public var videoViewer:VideoViewer;                 // 视频界面
		public var systemSetting:SystemSetting;           // 系统设置界面
		private var dropListWindow:DropListWindow;        // 下拉列表界
		public var emotionWindow:EmotionWindow;           // 表情界面
		public var aboutWindow:AboutWindow;               // 关于界面
		public var themeWindow:ThemeWindow;               // 主题选择界面
		public var timingWindow:TimingWeiboWindow;        // 定时微博界面
		public var updateWindow:UpdateWindow;             // 更新界面
		private var weiboListWindow:WeiBoListWindow;      // 微博列表界面
		public var targetUserWindow:WeiBoListWindow;      // 目标用户界面
		public var weiboPublishWindow:WeiBoPublisher;     // 微博发布器
		public var userFloat:FloatUserInfo;
		
		private var background:Sprite;     // 主界面背景
		
		private var indexBtn:Button;         // 首页按钮
		private var atBtn:Button;            // @按钮
		private var commentBtn:Button;       // 评论按钮
		private var dmBtn:Button;            // 私信按钮
		private var collectBtn:Button;       // 收藏按钮
		private var avatarBtn:Button;        // 头像按钮
		private var fansBtn:Button;          // 粉丝按钮
		private var followBtn:Button;        // 关注按钮
		private var sysBtn:Button;           // 系统按钮
		private var searchBtn:Button;        // 搜索按钮
		private var mewBtn:Button;           // Mew图标按钮
		private var publishBtn:Button;       // 发布按钮
		private var themeChooserBtn:Button;  // 主题按钮
		private var listBtn:Button;          // 帐号列表按钮
		
		public const NONE:String = "none";                        // 未开任何窗口
		public const INDEX:String = "index";
		public const AT:String = "at";
		public const COMMENT_ME:String = "comment_me";
		public const COLLECT:String = "collect";
		public const DIRECT_MESSAGE:String = "direct_message";
		public const MY_WEIBO:String = "my_weibo";
		public const FANS:String = "fans";
		public const FOLLOW:String = "follow";
		public const SYSTEM:String = "system";                   // 系统按钮列表
		public const SEARCH:String = "search";
		public const THEME:String = "theme";
		public const ACCOUNT_LIST:String = "account_list";
		
		private var currentActiveWindow:ALNativeWindow = null;
		public var currentState:String = NONE;
		public var currentButton:DisplayObject = null;
		
		public var timingWeiboManager:TimingWeiboManager = null;        // 定时微博管理器
		public var localWriter:WeiboDataCacher = null;
		
		public var update:Update = null;                                // 更新检测
		public var userData:UserData = null;
		public var dataCache:DataCache = null;
		public var assetsCache:AssetsCache = null;
		
		private var preloader:DataPreloader = null;
		
		public var alternationCenter:WeiboAlternationCenter = null;
		
		public function Mew()
		{
			super();
			
			init();
		}
		private function init():void
		{
			this.stage.scaleMode = StageScaleMode.NO_SCALE;
			this.stage.align = StageAlign.TOP_LEFT;
			
			MewSystem.app = this;
			
//			if(/*SystemSettingData.needSQLite && */!sqliteManager) sqliteManager = new SQLiteManager();
			
			// 根据本地缓存 更新内存设置
			LocalManager.settingsBySharedObject();
			
			// 初始化MicroBlog
			MewSystem.initMicroBlog();
			
			// 打开登录界面
			doLogin();
			
			if(SystemSettingData.checkUpdateDelay == 0) checkUpdate();
			
			// 初始化主界面
//			this.visible = false;
			this.stage.nativeWindow.width = Screen.mainScreen.visibleBounds.width;
			this.stage.nativeWindow.height = 100;
			this.stage.nativeWindow.x = Screen.mainScreen.visibleBounds.x;
			this.stage.nativeWindow.y = Screen.mainScreen.visibleBounds.y;
			this.stage.nativeWindow.alwaysInFront = SystemSettingData.alwaysInfront;
			drawBackground();
			drawButtons();
		}
		
		private function doLogin():void
		{
			// 打开登录界面
			loginPanel = new LoginWindow(getNativeWindowInitOption());
			loginPanel.activate();
		}
		
		private function drawBackground():void
		{
			if(!background) background = new Sprite();
			background.mouseChildren = false;
			background.graphics.beginFill(0xeeeeee, 1.0);
			background.graphics.drawRect(0, 0, this.stage.nativeWindow.width, this.stage.nativeWindow.height - 20);
			background.graphics.endFill();
			addChildAt(background, 0);
			Widget.widgetGlowFilter(background);
			this.addEventListener(MouseEvent.MOUSE_OVER, showMainPanel);
			this.addEventListener(MouseEvent.ROLL_OUT, hideMainPanel);
		}
		
		private function showMainPanel(event:MouseEvent):void
		{
			if(SystemSettingData.autoHide && !currentActiveWindow && currentState == NONE){
				var pos:int = Screen.mainScreen.visibleBounds.y;
				TweenLite.to(this.stage.nativeWindow, .3, {y: pos});
			}
		}
		
		private function hideMainPanel(event:MouseEvent):void
		{
			if(SystemSettingData.autoHide && !currentActiveWindow && currentState == NONE){
				var pos:int = Screen.mainScreen.visibleBounds.y - this.stage.nativeWindow.height + 30;
				TweenLite.to(this.stage.nativeWindow, .3, {y: pos});
			}
		}
		
		private function drawButtons():void
		{
			if(!indexBtn) indexBtn = new Button();
			if(!atBtn) atBtn = new Button();
			if(!commentBtn) commentBtn = new Button();
			if(!dmBtn) dmBtn = new Button();
			if(!collectBtn) collectBtn= new Button();
			if(!avatarBtn) avatarBtn = new Button();
			if(!fansBtn) fansBtn= new Button();
			if(!followBtn) followBtn = new Button();
			if(!sysBtn) sysBtn = new Button();
			if(!searchBtn) searchBtn = new Button();
			if(!mewBtn) mewBtn = new Button();
			if(!publishBtn) publishBtn = new Button();
			if(!listBtn) listBtn = new Button();
			if(!themeChooserBtn) themeChooserBtn = new Button();
			
			indexBtn.label = "首页";
			indexBtn.width = 60;
			
			atBtn.label = "At";
			atBtn.width = 60;
			
			commentBtn.label = "评论";
			commentBtn.width = 60;
			
			dmBtn.label = "私信";
			dmBtn.width = 60;
			
			collectBtn.label = "收藏";
			collectBtn.width = 60;
			
			avatarBtn.label = "头像";
			avatarBtn.width = 60;
			
			fansBtn.label = "粉丝";
			fansBtn.width = 60;
			
			followBtn.label = "关注";
			followBtn.width = 60;
			
			sysBtn.label = "系统";
			sysBtn.width = 60;
			
			mewBtn.label = "Mew";
			mewBtn.width = 60;
			
			publishBtn.label = "发布器";
			publishBtn.width = 60;
			
			listBtn.label = "下拉箭头";
			listBtn.width = 60;
			
			searchBtn.label = "搜索";
			searchBtn.width = 60;
			
			themeChooserBtn.label = "主题";
			themeChooserBtn.width = 60;
			
			addChild(indexBtn);
			addChild(atBtn);
			addChild(commentBtn);
			addChild(dmBtn);
			addChild(collectBtn);
			addChild(avatarBtn);
			addChild(fansBtn);
			addChild(followBtn);
			addChild(sysBtn);
			addChild(mewBtn);
			addChild(publishBtn);
			addChild(listBtn);
			addChild(searchBtn);
			addChild(themeChooserBtn);
			
			addListener(indexBtn);
			addListener(atBtn);
			addListener(commentBtn);
			addListener(dmBtn);
			addListener(collectBtn);
			addListener(avatarBtn);
			addListener(fansBtn);
			addListener(followBtn);
			addListener(sysBtn);
			addListener(mewBtn);
			addListener(publishBtn);
			addListener(listBtn);
			addListener(searchBtn);
			addListener(themeChooserBtn);
			
			var gap:uint = 20;
			var bottomSpace:uint = 30;
			
			avatarBtn.x = (this.stage.nativeWindow.width - avatarBtn.width) / 2;
			avatarBtn.y = (this.stage.nativeWindow.height - avatarBtn.height - listBtn.height) / 2 - 20;
			
			listBtn.x = avatarBtn.x + (avatarBtn.width - listBtn.width) / 2;
			listBtn.y = avatarBtn.y + avatarBtn.height + 5;
			
			/**
			 * 左边按钮
			 */
			collectBtn.x = avatarBtn.x - collectBtn.width - gap;
			collectBtn.y = this.stage.nativeWindow.height - collectBtn.height - bottomSpace;
			
			dmBtn.x = collectBtn.x - dmBtn.width - gap;
			dmBtn.y = this.stage.nativeWindow.height - dmBtn.height - bottomSpace;
			
			commentBtn.x = dmBtn.x - commentBtn.width - gap;
			commentBtn.y = this.stage.nativeWindow.height - commentBtn.height - bottomSpace;
			
			atBtn.x = commentBtn.x - atBtn.width - gap;
			atBtn.y = this.stage.nativeWindow.height - atBtn.height - bottomSpace;
			
			indexBtn.x = atBtn.x - indexBtn.width - gap;
			indexBtn.y = this.stage.nativeWindow.height - indexBtn.height - bottomSpace;
			
			/**
			 * 右边按钮
			 */
			fansBtn.x = avatarBtn.x + avatarBtn.width + gap;
			fansBtn.y = this.stage.nativeWindow.height - fansBtn.height - bottomSpace;
			
			followBtn.x = fansBtn.x + fansBtn.width + gap;
			followBtn.y = this.stage.nativeWindow.height - followBtn.height - bottomSpace;
			
			sysBtn.x = followBtn.x + followBtn.width + gap;
			sysBtn.y = this.stage.nativeWindow.height - sysBtn.height - bottomSpace;
			
			searchBtn.x = sysBtn.x + sysBtn.width + gap;
			searchBtn.y = this.stage.nativeWindow.height - searchBtn.height - bottomSpace;
			
			themeChooserBtn.x = searchBtn.x + searchBtn.width + gap;
			themeChooserBtn.y = this.stage.nativeWindow.height - themeChooserBtn.height - bottomSpace;
			
			publishBtn.x = themeChooserBtn.x + themeChooserBtn.width + gap;
			publishBtn.y = this.stage.nativeWindow.height - publishBtn.height - bottomSpace;
			
			mewBtn.x = this.stage.nativeWindow.width - mewBtn.width - 10;
			mewBtn.y = (this.stage.nativeWindow.height - mewBtn.height) / 2;
			
		}
		
		private function addListener(displayObject:DisplayObject):void
		{
			displayObject.addEventListener(MouseEvent.CLICK, openListWindow);
			displayObject.addEventListener(MouseEvent.MOUSE_OVER, mouseOverHandler);
			displayObject.addEventListener(MouseEvent.MOUSE_OUT, mouseOutHandler);
		}
		
		private function mouseOverHandler(event:MouseEvent):void
		{
			
		}
		
		private function mouseOutHandler(event:MouseEvent):void
		{
			
		}
		
		private function openListWindow(event:MouseEvent):void
		{
			if(event.target == publishBtn){
				if(weiboPublishWindow){
					weiboPublishWindow.close();
					weiboPublishWindow = null;
					return;
				}
				weiboPublishWindow = new WeiBoPublisher(getNativeWindowInitOption());
				weiboPublishWindow.displayByState(WeiBoPublisher.NORMAL);
				weiboPublishWindow.activate();
				return;
			}
			closeCurrentWindow();
			switch(event.target){
				case indexBtn:
					if(currentState == INDEX){
						currentState = NONE;
						return;
					}
					currentState = INDEX;
					break;
				case atBtn:
					if(currentState == AT){
						currentState = NONE;
						return;
					}
					currentState = AT;
					break;
				case commentBtn:
					if(currentState == COMMENT_ME){
						currentState = NONE;
						return;
					}
					currentState = COMMENT_ME;
					break;
				case dmBtn:
					if(currentState == DIRECT_MESSAGE){
						currentState = NONE;
						return;
					}
					currentState = DIRECT_MESSAGE;
					break;
				case collectBtn:
					if(currentState == COLLECT){
						currentState = NONE;
						return;
					}
					currentState = COLLECT;
					break;
				case avatarBtn:
					if(currentState == MY_WEIBO){
						currentState = NONE;
						return;
					}
					currentState = MY_WEIBO;
					break;
				case fansBtn:
					if(currentState == FANS){
						currentState = NONE;
						return;
					}
					currentState = FANS;
					break;
				case followBtn:
					if(currentState == FOLLOW){
						currentState = NONE;
						return;
					}
					currentState = FOLLOW;
					break;
				case sysBtn:
					if(currentState == SYSTEM){
						currentState = NONE;
						if(dropListWindow){
							dropListWindow.close();
							dropListWindow = null;
						}
						return;
					}
					currentButton = event.target as DisplayObject;
					currentState = SYSTEM;
					dropListWindow = new DropListWindow(getNativeWindowInitOption());
					dropListWindow.activate();
					currentActiveWindow = dropListWindow;
					return;
					break;
				case mewBtn:
//					navigateToURL(new URLRequest("http://mew.iabel.com"));
					var timing:TimingWeiboWindow = new TimingWeiboWindow(getNativeWindowInitOption());
					timing.activate();
					return;
					break;
				case listBtn:
					if(currentState == ACCOUNT_LIST){
						currentState = NONE;
						if(dropListWindow){
							dropListWindow.close();
							dropListWindow = null;
						}
						return;
					}
					currentButton = event.target as DisplayObject;
					currentState = ACCOUNT_LIST;
					dropListWindow = new DropListWindow(getNativeWindowInitOption());
					dropListWindow.activate();
					currentActiveWindow = dropListWindow;
					return;
					break;
				case searchBtn:
					if(currentState == SEARCH){
						currentState = NONE;
						return;
					}
					currentState = SEARCH;
					break;
				case themeChooserBtn:
					if(currentState == THEME){
						currentState = NONE;
						return;
					}
					currentState = THEME;
					break;
			}
			currentButton = event.target as DisplayObject;
			weiboListWindow = new WeiBoListWindow(getNativeWindowInitOption());
			weiboListWindow.activate();
			currentActiveWindow = weiboListWindow;
			weiboListWindow.readData();
		}
		
		private function getNativeWindowInitOption():NativeWindowInitOptions
		{
			var nativeWindowInitOption:NativeWindowInitOptions = new NativeWindowInitOptions();
			nativeWindowInitOption.systemChrome = "none";
			nativeWindowInitOption.transparent = true;
			nativeWindowInitOption.type = NativeWindowType.LIGHTWEIGHT;
			
			return nativeWindowInitOption;
		}
		
		private function closeCurrentWindow():void
		{
			if(currentActiveWindow){
				currentActiveWindow.close();
			}
			if(weiboListWindow){
				weiboListWindow.close();
			}
			if(dropListWindow){
				dropListWindow.close();
				dropListWindow = null;
			}
			currentActiveWindow = null;
			weiboListWindow = null;
		}
		
		public function initWidgets():void
		{
			if(!dataCache) dataCache = new DataCache();
			if(!assetsCache) assetsCache = new AssetsCache();
			if(!alternationCenter) alternationCenter = new WeiboAlternationCenter();
			if(!Widget.linkStyle){
				Widget.linkStyle = new StyleSheet();
				Widget.linkStyle.setStyle(".mainStyle", {fontFamily: Widget.systemFont, color:Widget.mainTextColor, fontSize:12, leading:10});
				Widget.linkStyle.setStyle("a:link", {fontFamily: Widget.systemFont, color:Widget.linkColor, fontSize:12, leading:11, textDecoration:"none"});
				Widget.linkStyle.setStyle("a:hover", {fontFamily: Widget.systemFont, color:Widget.linkColor, fontSize:12, leading:11, textDecoration:"underline"});
			}
			if(!timingWeiboManager) timingWeiboManager = new TimingWeiboManager();
			timingWeiboManager.check();
		}
		
		public function checkUpdate():void
		{
			// 检测版本更新
			if(!update) update = new Update();
			update.checkUpdate();
		}
		
		public function destroyUpdate():void
		{
			if(update) update = null;
		}
		
		public function callFromSQLiteManager(arr:Array):void
		{
			if(currentActiveWindow){
				var xml:XML = null;
				var urlLoader:URLLoader = new URLLoader();
				switch(currentState){
					case INDEX:
					case AT:
					case COMMENT_ME:
					case COLLECT:
					case MY_WEIBO:
					case DIRECT_MESSAGE:
						var list:WeiboFormList = new WeiboFormList();
						var func:Function = function(event:Event):void
						{
							urlLoader.removeEventListener(Event.COMPLETE, func);
							xml = XML(urlLoader.data);
							list.listData(arr, currentActiveWindow.getContentWidth(), xml);
							currentActiveWindow.showWeibo(arr, list);
						};
						urlLoader.addEventListener(Event.COMPLETE, func);
						urlLoader.load(new URLRequest("config/emotions.xml"));
						break;
					case FANS:
					case FOLLOW:
						var userList:UserFormList = new UserFormList();
						userList.listData(arr, currentActiveWindow.getContentWidth(), null);
						currentActiveWindow.showWeibo(arr, userList);
						break;
				}
			}
		}
		
		public function showTargetUserWindow(arr:Array, ud:UserData, p:Point):void
		{
			if(!targetUserWindow) targetUserWindow = new WeiBoListWindow(getNativeWindowInitOption());
			var xml:XML = null;
			var urlLoader:URLLoader = new URLLoader();
			var list:WeiboFormList = new WeiboFormList();
			var func:Function = function(event:Event):void
			{
				urlLoader.removeEventListener(Event.COMPLETE, func);
				xml = XML(urlLoader.data);
				list.listData(arr, targetUserWindow.getContentWidth(), xml);
				targetUserWindow.showWeibo(arr, list, ud);
				targetUserWindow.relocate(p);
				targetUserWindow.activate();
			};
			urlLoader.addEventListener(Event.COMPLETE, func);
			urlLoader.load(new URLRequest("config/emotions.xml"));
		}
		
		public function loginSuccess():void
		{
			if(loginPanel){
				loginPanel.close();
				loginPanel = null;
			}
			this.visible = true;
			if(!localWriter) localWriter = new WeiboDataCacher();
			if(!preloader) preloader =  new DataPreloader();
			preloader.preload();
		}
		
		public function reloadTheme():void
		{
			
		}
	}
}