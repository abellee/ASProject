package {
	import com.sina.microblog.data.MicroBlogStatus;
	
	import fl.data.DataProvider;
	
	import flash.desktop.DockIcon;
	import flash.desktop.NativeApplication;
	import flash.desktop.SystemTrayIcon;
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.NativeMenu;
	import flash.display.NativeMenuItem;
	import flash.display.NativeWindow;
	import flash.display.NativeWindowInitOptions;
	import flash.display.NativeWindowType;
	import flash.display.Screen;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.InvokeEvent;
	import flash.events.MouseEvent;
	import flash.events.ScreenMouseEvent;
	import flash.geom.Point;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.system.LoaderContext;
	import flash.text.StyleSheet;
	
	import mew.cache.AssetsCache;
	import mew.cache.DataCache;
	import mew.cache.WeiboDataCacher;
	import mew.communication.DataPreloader;
	import mew.communication.LocalManager;
	import mew.communication.WeiboChecker;
	import mew.data.SystemSettingData;
	import mew.data.UserData;
	import mew.data.WeiboData;
	import mew.events.MewEvent;
	import mew.modules.FloatUserInfo;
	import mew.modules.Suggesttor;
	import mew.modules.UIButton;
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
	import mew.windows.MainWindow;
	import mew.windows.SearchWindow;
	import mew.windows.SystemSetting;
	import mew.windows.ThemeWindow;
	import mew.windows.TimingWeiboWindow;
	import mew.windows.UpdateCheckWindow;
	import mew.windows.UpdateWindow;
	import mew.windows.UserSuggestion;
	import mew.windows.VideoViewer;
	import mew.windows.WeiBoListWindow;
	import mew.windows.WeiBoPublisher;
	import mew.windows.WeiboTextWindow;
	
	import resource.Resource;
	
	import system.MewSystem;
	import system.TimingWeiboManager;
	
	import widget.Widget;
	
	[SWF(frameRate=30)]
	public class Mew extends Sprite
	{
		public var mainWindow:MainWindow;                // 主界面
		private var loginPanel:LoginWindow;               // 登录界面
		private var weiboListWindow:WeiBoListWindow;      // 微博列表界面
		public var imageViewer:ImageViewer;               // 查看大图界面 
		public var videoViewer:VideoViewer;               // 视频界面
		public var systemSetting:SystemSetting;           // 系统设置界面
		public var dropListWindow:DropListWindow;         // 下拉列表界
		public var emotionWindow:EmotionWindow;           // 表情界面
		public var aboutWindow:AboutWindow;               // 关于界面
		public var themeWindow:ThemeWindow;               // 主题选择界面
		public var timingWindow:TimingWeiboWindow;        // 定时微博界面
		public var updateWindow:UpdateWindow;             // 更新界面
		public var weiboPublishWindow:WeiBoPublisher;     // 微博发布器
		public var userFloat:FloatUserInfo;
		public var searchWindow:SearchWindow;
		public var widgetWindow:ALNativeWindow;           // 目标用户界面 或者搜索界面
		public var updateCheckingWindow:UpdateCheckWindow;
		
		public const NONE:String = "none";     // 未开任何窗口
		public const INDEX:String = "index";
		public const AT:String = "at";
		public const COMMENT:String = "comment";
		public const COLLECT:String = "collect";
		public const DIRECT_MESSAGE:String = "direct_message";
		public const MY_WEIBO:String = "my_weibo";
		public const FANS:String = "fans";
		public const FOLLOW:String = "follow";
		public const SYSTEM:String = "system";                   // 系统按钮列表
		public const SEARCH:String = "search";
		public const THEME:String = "theme";
		public const MEW:String = "mew";
		public const ACCOUNT_LIST:String = "account_list";
		
		public var currentActiveWindow:ALNativeWindow = null;
		public var currentState:String = NONE;
		
		public var timingWeiboManager:TimingWeiboManager = null;        // 定时微博管理器
		public var localWriter:WeiboDataCacher = null;
		public var unreadChecker:WeiboChecker = null;
		
		public var update:Update = null;                                // 更新检测
		public var userData:UserData = null;
		public var dataCache:DataCache = null;
		public var assetsCache:AssetsCache = null;
		
		public var preloader:DataPreloader = null;
		
		public var alternationCenter:WeiboAlternationCenter = null;
		public var suggestor:Suggesttor = null;
		
		private var suggestionWindow:UserSuggestion = null;
		private var bugWindow:UserSuggestion = null;
		
		public var isLogout:Boolean = false;
		
		public function Mew()
		{
			super();
			
			init();
		}
		private function init():void
		{
			if(NativeApplication.supportsSystemTrayIcon){
				
				var systemTrayIcon:SystemTrayIcon = NativeApplication.nativeApplication.icon as SystemTrayIcon;
				systemTrayIcon.tooltip = "Mew";
				var iconMenu:NativeMenu = new NativeMenu();
				var showPanelCmd:NativeMenuItem = iconMenu.addItem(new NativeMenuItem("显示Mew主界面"));
				var exitCommand:NativeMenuItem = iconMenu.addItem(new NativeMenuItem("退出Mew"));
				exitCommand.addEventListener(Event.SELECT,closeWindowByDock);
				showPanelCmd.addEventListener(Event.SELECT,showMewPanel);
				systemTrayIcon.addEventListener(ScreenMouseEvent.CLICK,clickShowMewPanel);
				systemTrayIcon.menu = iconMenu;
				
			}
			if(NativeApplication.supportsDockIcon){
				
				var dockIcon:DockIcon = NativeApplication.nativeApplication.icon as DockIcon;
				var dockMenu:NativeMenu = new NativeMenu();
				var setCmd:NativeMenuItem = dockMenu.addItem(new NativeMenuItem("显示Mew主界面"));
				setCmd.addEventListener(Event.SELECT,showMewPanel);
				NativeApplication.nativeApplication.addEventListener(InvokeEvent.INVOKE, showMewPanelForMac);
				dockIcon.menu = dockMenu;
				
			}
			
			this.stage.scaleMode = StageScaleMode.NO_SCALE;
			this.stage.align = StageAlign.TOP_LEFT;
			
			this.stage.nativeWindow.close();
			
			// 初始化应用图标
			initIcons();
			
			MewSystem.app = this;
			
			// 初始化样式
			MewSystem.initStyle();
			
			// 根据本地缓存 更新内存设置
			LocalManager.settingsBySharedObject();
			
			// 初始化MicroBlog
			MewSystem.initMicroBlog();
			
			// 加载loading动画资源
			loadResource();
			
			// 打开登录界面
			doLogin();
			
			if(SystemSettingData.checkUpdateDelay == 0) checkUpdate();
			
//			drawBackground();
//			drawButtons();
		}
		
		public function mainWindowNoHide():void
		{
			mainWindow.noHide();
		}
		
		private function closeWindowByDock(event:Event):void
		{
			NativeApplication.nativeApplication.exit();
		}
		
		private function showMewPanel(event:Event):void
		{
			var arr:Array = NativeApplication.nativeApplication.openedWindows;
			for each(var win:NativeWindow in arr){
				win.alwaysInFront = true;
				win.alwaysInFront = SystemSettingData.alwaysInfront;
			}
		}
		
		private function showMewPanelForMac(event:InvokeEvent):void
		{
			var arr:Array = NativeApplication.nativeApplication.openedWindows;
			for each(var win:NativeWindow in arr){
				win.alwaysInFront = true;
				win.alwaysInFront = SystemSettingData.alwaysInfront;
			}
		}
		
		private function clickShowMewPanel(event:ScreenMouseEvent):void
		{
			var arr:Array = NativeApplication.nativeApplication.openedWindows;
			for each(var win:NativeWindow in arr){
				win.alwaysInFront = true;
				win.alwaysInFront = SystemSettingData.alwaysInfront;
			}
		}
		
		private function initIcons():void
		{
			var bitmap16:Bitmap = new (Resource.X16)();
			var bitmap32:Bitmap = new (Resource.X32)();
			var bitmap36:Bitmap = new (Resource.X36)();
			var bitmap48:Bitmap = new (Resource.X48)();
			var bitmap72:Bitmap = new (Resource.X72)();
			var bitmap114:Bitmap = new (Resource.X114)();
			var bitmap128:Bitmap = new (Resource.X128)();
			
			NativeApplication.nativeApplication.icon.bitmaps = [bitmap16.bitmapData, bitmap32.bitmapData, bitmap36.bitmapData,
			 bitmap48.bitmapData, bitmap72.bitmapData, bitmap114.bitmapData, bitmap128.bitmapData];
		}
		
		private function doLogin():void
		{
			// 打开登录界面
			loginPanel = new LoginWindow(getNativeWindowInitOption());
			loginPanel.activate();
		}
		
		public function refreshCurrentList():void
		{
			if(mainWindow.currentButton){
				currentState = NONE;
				mainWindow.currentButton.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
			}
		}
		
		public function closePublishWindow():void
		{
			mainWindow.closePublishWindow();
		}
		
		public function closeTimingWindow():void
		{
			if(timingWindow){
				timingWindow.close();
				timingWindow = null;
			}
		}
		
		public function openPublishWindow(state:String, userData:UserData = null, weiboData:WeiboData = null,
		 repostUserData:UserData = null, repostData:WeiboData = null, additionStr:String = null):void
		{
			if(weiboPublishWindow){
				weiboPublishWindow.close();
				weiboPublishWindow = null;
			}
			weiboPublishWindow = new WeiBoPublisher(getNativeWindowInitOption());
			weiboPublishWindow.displayByState(state, userData, weiboData, repostUserData, repostData);
			weiboPublishWindow.activate();
		}
		
		public function openListWindow(event:MouseEvent):void
		{
			if(event.currentTarget == mainWindow.publishBtn){
				if(weiboPublishWindow){
					weiboPublishWindow.close();
					weiboPublishWindow = null;
					return;
				}
				openPublishWindow(WeiBoPublisher.NORMAL);
				return;
			}
			closeCurrentWindow();
			resetCurrentButton();
			if(event.currentTarget == mainWindow.refreshButton){
				preloader.preload();
				return;
			}
			mainWindow.currentButton = event.currentTarget as DisplayObject;
			if(MewSystem.app.dataCache) MewSystem.app.dataCache.destroy();
			if(MewSystem.app.assetsCache) MewSystem.app.assetsCache.destroy();
			switch(event.currentTarget){
				case mainWindow.indexBtn:
					if(mainWindow.unreadStatusButton){
						currentState = NONE;
						mainWindow.container.removeChild(mainWindow.unreadStatusButton);
						mainWindow.unreadStatusButton = null;
					}
					if(currentState == INDEX){
						currentState = NONE;
						mainWindow.currentButton = null;
						return;
					}
					currentState = INDEX;
					break;
				case mainWindow.atBtn:
					if(mainWindow.unreadAtButton){
						currentState = NONE;
						mainWindow.container.removeChild(mainWindow.unreadAtButton);
						mainWindow.unreadAtButton = null;
					}
					if(currentState == AT){
						currentState = NONE;
						mainWindow.currentButton = null;
						return;
					}
					currentState = AT;
					break;
				case mainWindow.commentBtn:
					if(mainWindow.unreadCommentButton){
						currentState = NONE;
						mainWindow.container.removeChild(mainWindow.unreadCommentButton);
						mainWindow.unreadCommentButton = null;
					}
					if(currentState == COMMENT){
						currentState = NONE;
						mainWindow.currentButton = null;
						return;
					}
					currentState = COMMENT;
					break;
				case mainWindow.dmBtn:
					if(mainWindow.unreadDMButton){
						currentState = NONE;
						mainWindow.container.removeChild(mainWindow.unreadDMButton);
						mainWindow.unreadDMButton = null;
					}
					if(currentState == DIRECT_MESSAGE){
						currentState = NONE;
						mainWindow.currentButton = null;
						return;
					}
					currentState = DIRECT_MESSAGE;
					break;
				case mainWindow.collectBtn:
					if(currentState == COLLECT){
						currentState = NONE;
						mainWindow.currentButton = null;
						return;
					}
					currentState = COLLECT;
					break;
				case mainWindow.avatarBtn:
					if(currentState == MY_WEIBO){
						currentState = NONE;
						mainWindow.currentButton = null;
						return;
					}
					currentState = MY_WEIBO;
					break;
				case mainWindow.fansBtn:
					if(mainWindow.unreadFansButton){
						currentState = NONE;
						mainWindow.container.removeChild(mainWindow.unreadFansButton);
						mainWindow.unreadFansButton = null;
					}
					if(currentState == FANS){
						currentState = NONE;
						mainWindow.currentButton = null;
						return;
					}
					currentState = FANS;
					break;
				case mainWindow.followBtn:
					if(currentState == FOLLOW){
						currentState = NONE;
						mainWindow.currentButton = null;
						return;
					}
					currentState = FOLLOW;
					break;
				case mainWindow.sysBtn:
					if(currentState == SYSTEM){
						currentState = NONE;
						mainWindow.currentButton = null;
						if(dropListWindow){
							dropListWindow.close();
							dropListWindow = null;
						}
						return;
					}
					currentState = SYSTEM;
					dropListWindow = new DropListWindow(getNativeWindowInitOption());
					var dataProvider:DataProvider = new DataProvider();
					dataProvider.addItem({label: "设 置", func: openSystemSettingWindow});
					dataProvider.addItem({label: "定时微博", func: openTimingWeiboWindow});
					dataProvider.addItem({label: "在线更新", func: openUpdateCheckWindow});
					dataProvider.addItem({label: "注 销", func: logOut});
					dataProvider.addItem({label: "退 出", func: exitApp});
					dropListWindow.showList(dataProvider, 200);
					dropListWindow.activate();
					currentActiveWindow = dropListWindow;
					return;
					break;
				case mainWindow.mewBtn:
					if(currentState == MEW){
						currentState = NONE;
						mainWindow.currentButton = null;
						if(dropListWindow){
							dropListWindow.close();
							dropListWindow = null;
						}
						return;
					}
					currentState = MEW;
					dropListWindow = new DropListWindow(getNativeWindowInitOption());
					var dp:DataProvider = new DataProvider();
					dp.addItem({label: "Bugs提交", func: openBugsSubmitWindow});
					dp.addItem({label: "用户意见", func: openUserSuggestionWindow});
					dp.addItem({label: "更新日志", func: updateLogs});
					dp.addItem({label: "进入官网", func: goOfficialSite});
					dp.addItem({label: "关于Mew微博", func: openAboutWindow});
					dropListWindow.showList(dp, 200);
					dropListWindow.activate();
					currentActiveWindow = dropListWindow;
					return;
					break;
				case mainWindow.listBtn:
					if(currentState == ACCOUNT_LIST){
						currentState = NONE;
						mainWindow.currentButton = null;
						if(dropListWindow){
							dropListWindow.close();
							dropListWindow = null;
						}
						return;
					}
					currentState = ACCOUNT_LIST;
					dropListWindow = new DropListWindow(getNativeWindowInitOption());
					dropListWindow.activate();
					currentActiveWindow = dropListWindow;
					return;
					break;
				case mainWindow.searchBtn:
					if(currentState == SEARCH){
						currentState = NONE;
						mainWindow.currentButton = null;
						return;
					}
					currentState = SEARCH;
					searchWindow = new SearchWindow(getNativeWindowInitOption());
					searchWindow.activate();
					currentActiveWindow = searchWindow;
					return;
					break;
				case mainWindow.themeChooserBtn:
					if(currentState == THEME){
						currentState = NONE;
						mainWindow.currentButton = null;
						return;
					}
					currentState = THEME;
					break;
			}
			weiboListWindow = new WeiBoListWindow(getNativeWindowInitOption());
			weiboListWindow.activate();
			currentActiveWindow = weiboListWindow;
			checkAndReadData();
		}
		
		private function checkAndReadData():void
		{
			MewSystem.showCycleLoading(currentActiveWindow.container);
			switch(currentState){
				case INDEX:
					if(!preloader.friendTimlineReadComplete){
						preloader.addEventListener(MewEvent.FRIEND_TIME_LINE_LOADED, onFriendTimelineLoaded);
						return;
					}
					break;
				case AT:
					if(!preloader.mentionsReadComplete){
						preloader.addEventListener(MewEvent.MENTIONS_LOADED, onMentionsLoaded);
						return;
					}
					break;
				case COMMENT:
					if(!preloader.commentsTimelineReadComplete){
						preloader.addEventListener(MewEvent.COMMENTS_TIME_LINE_LOADED, onCommentsLoaded);
						return;
					}
					break;
				case COLLECT:
					if(!preloader.favoriteListReadComplete){
						preloader.addEventListener(MewEvent.FAVORITE_LOADED, onFavoriteLoaded);
						return;
					}
					break;
				case DIRECT_MESSAGE:
					if(!preloader.dmReadComplete){
						preloader.addEventListener(MewEvent.DM_LOADED, onDMLoaded);
						return;
					}
					break;
				case MY_WEIBO:
					if(!preloader.userTimelineReadComplete){
						preloader.addEventListener(MewEvent.USER_TIME_LINE_LOADED, onUserTimelineLoaded);
						return;
					}
					break;
				case FANS:
					if(!preloader.friendsInfoReadComplete){
						preloader.addEventListener(MewEvent.FRIEND_INFO_LOADED, onFriendInfoLoaded);
						return;
					}
					break;
				case FOLLOW:
					if(!preloader.followerInfoReadComplete){
						preloader.addEventListener(MewEvent.FOLLOW_INFO_LOADED, onFollowInfoLoaded);
						return;
					}
					break;
			}
			weiboListWindow.readData();
		}
		
		private function onFollowInfoLoaded(event:MewEvent):void
		{
			preloader.removeEventListener(MewEvent.FOLLOW_INFO_LOADED, onFollowInfoLoaded);
			if(currentState == FOLLOW && event.result && event.result is Array) callFromSQLiteManager(event.result as Array);
		}
		
		private function onFriendInfoLoaded(event:MewEvent):void
		{
			preloader.removeEventListener(MewEvent.FRIEND_INFO_LOADED, onFriendInfoLoaded);
			if(currentState == FANS && event.result && event.result is Array) callFromSQLiteManager(event.result as Array);
		}
		
		private function onUserTimelineLoaded(event:MewEvent):void
		{
			preloader.removeEventListener(MewEvent.USER_TIME_LINE_LOADED, onUserTimelineLoaded);
			if(currentState == MY_WEIBO && event.result && event.result is Array) callFromSQLiteManager(event.result as Array);
		}
		
		private function onDMLoaded(event:MewEvent):void
		{
			preloader.removeEventListener(MewEvent.DM_LOADED, onDMLoaded);
			if(currentState == DIRECT_MESSAGE && event.result && event.result is Array) callFromSQLiteManager(event.result as Array);
		}
		
		private function onFavoriteLoaded(event:MewEvent):void
		{
			preloader.removeEventListener(MewEvent.FAVORITE_LOADED, onFavoriteLoaded);
			if(currentState == COLLECT && event.result && event.result is Array) callFromSQLiteManager(event.result as Array);
		}
		
		private function onCommentsLoaded(event:MewEvent):void
		{
			preloader.removeEventListener(MewEvent.COMMENTS_TIME_LINE_LOADED, onCommentsLoaded);
			if(currentState == COMMENT && event.result && event.result is Array) callFromSQLiteManager(event.result as Array);
		}
		
		private function onMentionsLoaded(event:MewEvent):void
		{
			preloader.removeEventListener(MewEvent.MENTIONS_LOADED, onMentionsLoaded);
			if(currentState == AT && event.result && event.result is Array) callFromSQLiteManager(event.result as Array);
		}
		
		private function onFriendTimelineLoaded(event:MewEvent):void
		{
			preloader.removeEventListener(MewEvent.FRIEND_TIME_LINE_LOADED, onFriendTimelineLoaded);
			if(currentState == INDEX && event.result && event.result is Array) callFromSQLiteManager(event.result as Array);
		}
		
		public function reloadCurrentWindow(win:ALNativeWindow):void
		{
			win.reload();
			checkAndReadData();
		}
		
		private function openBugsSubmitWindow():void
		{
			resetCurrentButton();
			if(!bugWindow){
				bugWindow = new UserSuggestion(getNativeWindowInitOption(), "Bug提交");
				bugWindow.activate();
			}
		}
		
		private function openUserSuggestionWindow():void
		{
			resetCurrentButton();
			if(!suggestionWindow){
				suggestionWindow = new UserSuggestion(getNativeWindowInitOption(), "用户意见");
				suggestionWindow.activate();
			}
		}
		
		public function closeUserSuggestionWindow():void
		{
			if(suggestionWindow){
				suggestionWindow.close();
				suggestionWindow = null;
			}
		}
		
		public function closeBugSubmitWindow():void
		{
			if(bugWindow){
				bugWindow.close();
				bugWindow = null;
			}
		}
		
		private function updateLogs():void
		{
			resetCurrentButton();
			navigateToURL(new URLRequest("http://mew.iabel.com"));
		}
		
		private function goOfficialSite():void
		{
			resetCurrentButton();
			navigateToURL(new URLRequest("http://mew.iabel.com"));
		}
		
		private function openAboutWindow():void
		{
			resetCurrentButton();
			aboutWindow = new AboutWindow(getNativeWindowInitOption());
			aboutWindow.activate();
		}
		
		public function openUpdateCheckWindow(state:String = "check"):void
		{
			resetCurrentButton();
			if(updateCheckingWindow){
				if(state != updateCheckingWindow.curState){
					if(updateCheckingWindow.curState == "download") return;
					else{
						updateCheckingWindow.close();
						updateCheckingWindow = null;
					}
				}
			}
			if(!updateCheckingWindow){
				updateCheckingWindow = new UpdateCheckWindow(getNativeWindowInitOption(), state);
				updateCheckingWindow.activate();
			}
		}
		
		private function exitApp():void
		{
			NativeApplication.nativeApplication.exit();
		}
		
		private function logOut():void
		{
			isLogout = true;
			unreadChecker.stopRunning();
			unreadChecker = null;
			MewSystem.initMicroBlog();
			var activeWindowList:Array = NativeApplication.nativeApplication.openedWindows;
			for each(var win:NativeWindow in activeWindowList){
				win.close();
			}
			
			mainWindow = null;
			loginPanel = null;
			weiboListWindow = null;
			imageViewer = null;
			videoViewer = null;
			systemSetting = null;
			dropListWindow = null;
			emotionWindow = null;
			aboutWindow = null;
			themeWindow = null;
			timingWindow = null;
			updateWindow = null;
			weiboPublishWindow = null;
			userFloat = null;
			searchWindow = null;
			widgetWindow = null;
			updateCheckingWindow = null;
			currentActiveWindow = null;
			
			currentState = NONE;
		
			if(timingWeiboManager) timingWeiboManager.stop();
			timingWeiboManager = null;
			localWriter = null;
			unreadChecker = null;
		
			update = null;                                // 更新检测
			userData = null;
			dataCache = null;
			assetsCache = null;
		
			preloader = null;
		
			alternationCenter = null;
			suggestor = null;
		
			suggestionWindow = null;
			bugWindow = null;
			
			doLogin();
		}
		
		private function openSystemSettingWindow():void
		{
			resetCurrentButton();
			if(systemSetting) return;
			systemSetting = new SystemSetting(getNativeWindowInitOption());
			systemSetting.activate();
		}
		
		public function closeSystemSettingWindow():void
		{
			if(systemSetting){
				systemSetting.close();
				systemSetting = null;
			}
		}
		
		private function openTimingWeiboWindow():void
		{
			resetCurrentButton();
			if(!timingWindow) timingWindow = new TimingWeiboWindow(getNativeWindowInitOption());
			timingWindow.activate();
		}

		private function resetCurrentButton() : void {
			if(!mainWindow) return;
			if(mainWindow.currentButton){
				if(mainWindow.currentButton is UIButton){
					(mainWindow.currentButton as UIButton).toggle = false;
					(mainWindow.currentButton as UIButton).toggle = true;
				}
				mainWindow.currentButton = null;
			}
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
				currentActiveWindow.visible = false;
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
				Widget.linkStyle.setStyle(".mainStyle", {fontFamily: Widget.systemFont, color: Widget.mainTextColor, fontSize: 12, leading: 10});
				Widget.linkStyle.setStyle(".whiteStyle", {fontFamily: Widget.systemFont, color: "#bebebe", fontSize: 12, leading: 10});
				Widget.linkStyle.setStyle("a:link", {fontFamily: Widget.systemFont, color: Widget.linkColor, fontSize: 12, leading: 11, textDecoration: "none"});
				Widget.linkStyle.setStyle("a:hover", {fontFamily: Widget.systemFont, color: Widget.linkColor, fontSize: 12, leading: 11, textDecoration: "underline"});
			}
			if(!timingWeiboManager) timingWeiboManager = new TimingWeiboManager();
			if(!unreadChecker) unreadChecker = new WeiboChecker();
			unreadChecker.startRunning();
			timingWeiboManager.check();
		}
		
		private function loadResource():void
		{
			var context:LoaderContext = new LoaderContext();
			context.allowCodeImport = true;
			var resArr:Array = [new Resource.CycleLoading(), new Resource.LoadingMotion()];
			var cacheArr:Array = ["cycleMotion", "loadingMotion"];
			var index:int = 0;
			var loader:Loader = new Loader();
			var func:Function = function(event:Event):void
			{
				MewSystem[cacheArr[index]] = event.target.content as MovieClip;
				index++;
				if(index >= cacheArr.length){
					loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, func);
					loader = null;
					return;
				}
				loader.loadBytes(resArr[index], context);
			};
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, func);
			loader.loadBytes(resArr[index], context);
		}
		
		public function checkUpdate():void
		{
			// 检测版本更新
			if(!update) update = new Update();
		}
		
		public function destroyUpdate():void
		{
			if(update){
				update.clearSelf();
				update = null;
			}
		}
		
		public function noUpdate():void
		{
			if(updateCheckingWindow){
				updateCheckingWindow.close();
				updateCheckingWindow = null;
			}
			destroyUpdate();
		}
		
		public function openUpdateWindow(vnum:Number, str:String):void
		{
			if(updateCheckingWindow){
				updateCheckingWindow.close();
				updateCheckingWindow = null;
			}
			if(vnum != SystemSettingData.skipVersionNumber || MewSystem.isManual){
				MewSystem.isManual = false;
				if(!updateWindow){
					updateWindow = new UpdateWindow(getNativeWindowInitOption());
					updateWindow.activate();
					updateWindow.showData(vnum, str);
				}
			}else{
				destroyUpdate();
			}
		}
		
		public function callFromSQLiteManager(arr:Array):void
		{
			if(currentActiveWindow){
				MewSystem.removeCycleLoading(currentActiveWindow.container);
				var xml:XML = null;
				var urlLoader:URLLoader = new URLLoader();
				switch(currentState){
					case INDEX:
					case AT:
					case COMMENT:
					case COLLECT:
					case MY_WEIBO:
					case DIRECT_MESSAGE:
						var list:WeiboFormList = new WeiboFormList();
						var func:Function = function(event:Event):void
						{
							urlLoader.removeEventListener(Event.COMPLETE, func);
							xml = XML(urlLoader.data);
							list.listData(arr, currentActiveWindow.getContentWidth(), xml, currentActiveWindow);
							currentActiveWindow.showWeibo(arr, list);
						};
						urlLoader.addEventListener(Event.COMPLETE, func);
						urlLoader.load(new URLRequest("config/emotions.xml"));
						break;
					case FANS:
					case FOLLOW:
						var userList:UserFormList = new UserFormList();
						userList.listData(arr, currentActiveWindow.getContentWidth(), null, currentActiveWindow);
						currentActiveWindow.showWeibo(arr, userList);
						break;
				}
			}else MewSystem.removeCycleLoading(null);
		}
		
		public function showWeiboTextWindow(id:String):void
		{
			if(!id) return;
			closeWidgetWindow();
			MewSystem.showCycleLoading(currentActiveWindow.container);
			alternationCenter.loadStatusInfo(id, currentActiveWindow.container);
		}
		
		public function closeWidgetWindow():void
		{
			if(widgetWindow){
				currentActiveWindow.goodbye(widgetWindow);
				widgetWindow.close();
				widgetWindow = null;
			}
		}

		public function statusInfoLoaded(status:MicroBlogStatus, container:DisplayObjectContainer):void
		{
			if(!widgetWindow && currentActiveWindow.container == container){
				MewSystem.removeCycleLoading(currentActiveWindow.container);
				widgetWindow = new WeiboTextWindow(getNativeWindowInitOption(), null, true);
				(widgetWindow as WeiboTextWindow).loadData(status);
				openWidgetWindow();
			}
		}
		
		public function showSearchWindow(topic:String):void
		{
			if(!topic) return;
			closeWidgetWindow();
			widgetWindow = new SearchWindow(getNativeWindowInitOption());
			
			if(currentActiveWindow){
				openWidgetWindow();
				(widgetWindow as SearchWindow).search(topic);
			}
		}
		
		private function openWidgetWindow():void
		{
			var p:Point = new Point();
			p.x = currentActiveWindow.x + currentActiveWindow.width;
			p.y = currentActiveWindow.y;
			if(p.x + widgetWindow.width > Screen.mainScreen.visibleBounds.width) p.x = currentActiveWindow.x - widgetWindow.width;
			if(p.x < Screen.mainScreen.visibleBounds.x) p.x = Screen.mainScreen.visibleBounds.x;
			currentActiveWindow.iseeu(widgetWindow);
			widgetWindow.relocate(p);
			widgetWindow.activate();
		}
		
		public function showTargetUserWindow(arr:Array, ud:UserData):void
		{
			if(!arr || !ud) return;
			closeWidgetWindow();
			widgetWindow = new WeiBoListWindow(getNativeWindowInitOption(), null, true);
			var xml:XML = null;
			var urlLoader:URLLoader = new URLLoader();
			var list:WeiboFormList = new WeiboFormList();
			var func:Function = function(event:Event):void
			{
				urlLoader.removeEventListener(Event.COMPLETE, func);
				xml = XML(urlLoader.data);
				list.listData(arr, widgetWindow.getContentWidth(), xml, widgetWindow);
				widgetWindow.showWeibo(arr, list, ud);
				if(currentActiveWindow) openWidgetWindow();
			};
			urlLoader.addEventListener(Event.COMPLETE, func);
			urlLoader.load(new URLRequest("config/emotions.xml"));
		}
		
		public function showUnread(cate:String, num:int):void
		{
			if(mainWindow) mainWindow.showUnread(cate, num);
		}
		
		public function loginSuccess():void
		{
			if(!mainWindow) mainWindow = new MainWindow(MewSystem.getNativeWindowInitOption());
			mainWindow.app = this;
			mainWindow.init();
			mainWindow.activate();
			isLogout = false;
			if(loginPanel){
				loginPanel.close();
				loginPanel = null;
			}
			if(!localWriter) localWriter = new WeiboDataCacher();
			if(!preloader) preloader =  new DataPreloader();
			preloader.preload();
			loadUserAvatar();
		}
		
		private function loadUserAvatar():void
		{
			var loader:Loader = new Loader();
			var func:Function = function(event:Event):void
			{
				loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, func);
				var bitmap:Bitmap = event.target.content as Bitmap;
				assetsCache.setAvatarCache(userData.id, bitmap.bitmapData);
				localWriter.writeUserBitmap(userData.id, bitmap.bitmapData);
			};
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, func);
			loader.load(new URLRequest(userData.src));
		}
		
		public function reloadTheme():void
		{
			
		}
	}
}