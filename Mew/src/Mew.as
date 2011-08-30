package
{
	import com.greensock.TweenLite;
	import com.iabel.core.ALSprite;
	import com.iabel.core.UISprite;
	import com.iabel.system.CoreSystem;
	import com.iabel.util.StringDetector;
	import com.iabel.util.URLDetector;
	import com.sina.microblog.data.MicroBlogComment;
	import com.sina.microblog.data.MicroBlogCount;
	import com.sina.microblog.data.MicroBlogDirectMessage;
	import com.sina.microblog.data.MicroBlogRelationshipDescriptor;
	import com.sina.microblog.data.MicroBlogStatus;
	import com.sina.microblog.data.MicroBlogUser;
	import com.sina.microblog.data.MicroBlogUsersRelationship;
	import com.sina.microblog.events.MicroBlogEvent;
	
	import config.Config;
	
	import fl.controls.Button;
	
	import flash.data.SQLResult;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.NativeWindow;
	import flash.display.NativeWindowInitOptions;
	import flash.display.NativeWindowType;
	import flash.display.Screen;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.net.SharedObject;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.net.registerClassAlias;
	import flash.text.Font;
	
	import mew.cache.AssetsCache;
	import mew.cache.DataCache;
	import mew.cache.WeiboDataCacheWriter;
	import mew.cache.WeiboDataCacher;
	import mew.communication.DataPreloader;
	import mew.communication.LocalManager;
	import mew.communication.SQLiteManager;
	import mew.data.SystemSettingData;
	import mew.data.UserData;
	import mew.modules.UserFormList;
	import mew.modules.WeiboEntry;
	import mew.modules.WeiboFormList;
	import mew.update.Update;
	import mew.utils.StringUtils;
	import mew.utils.VideoChecker;
	import mew.windows.ALNativeWindow;
	import mew.windows.AboutWindow;
	import mew.windows.AlertWindow;
	import mew.windows.DropListWindow;
	import mew.windows.EmotionWindow;
	import mew.windows.ImageViewer;
	import mew.windows.LoginWindow;
	import mew.windows.OAuthWindow;
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
	
	[SWF(frameRate=30)]
	public class Mew extends Sprite
	{
		private var loginPanel:LoginWindow;               // 登录界面
		private var imagerView:ImageViewer;               // 查看大图界面 
		private var videoView:VideoViewer;                // 视频界面
		private var systemSetting:SystemSetting;          // 系统设置界面
		private var alertWindow:AlertWindow;              // confirm界面
		private var dropListWindow:DropListWindow;        // 下拉列表界
		private var emotionWindow:EmotionWindow;          // 表情界面
		private var aboutWindow:AboutWindow;              // 关于界面
		private var themeWindow:ThemeWindow;              // 主题选择界面
		private var timingWindow:TimingWeiboWindow;       // 定时微博界面
		private var updateWindow:UpdateWindow;            // 更新界面
		private var weiboListWindow:WeiBoListWindow;      // 微博列表界面
		private var weiboPublishWindow:WeiBoPublisher;    // 微博发布器
		
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
		public var sqliteManager:SQLiteManager = null;                  // 本地数据库管理器
		public var localWriter:WeiboDataCacher = null;
		
		public var update:Update = null;                                // 更新检测
		public var userData:UserData = null;
		public var dataCache:DataCache = null;
		public var assetsCache:AssetsCache = null;
		
		private var preloader:DataPreloader = null;
		
		public function Mew()
		{
			super();
			
			init();
		}
		private function init():void
		{
			/*var videoChecker:VideoChecker = new VideoChecker();
			videoChecker.isVideoURL(["http://v.youku.com/v_show/id_XMjkzNzU0MTAw.html",
				"http://news.joy.cn/video/3064577.htm", "http://bugu.cntv.cn/ent/C20352/classpage/video/20110820/100389.shtml",
				"http://tv.v1.cn/tpjs/2011-8-22/1313978608564v.shtml", "http://www.yinyuetai.com/video/241881",
				"http://tv.sohu.com/20110803/n315253285.shtml", "http://www.56.com/u38/v_NjI0NzI1NDc.html",
				"http://video.sina.com.cn/p/sports/c/v/2011-08-21/234961451709.html", "http://v.ku6.com/film/show_129913/yYpl6lVQsGZNJal6.html",
				"http://www.tudou.com/playlist/p/a67218i93826498.html", "http://v.youku.com/v_show/id_XMjk3MjAzMjE2.html"]);*/
			
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
			
			if(SystemSettingData.checkUpdateAtStart) checkUpdate();
			
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
					navigateToURL(new URLRequest("http://mew.iabel.com"));
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
			// 初始化本地数据库管理器
			if(!dataCache) dataCache = new DataCache();
			if(!assetsCache) assetsCache = new AssetsCache();
		}
		
		public function checkUpdate():void
		{
			// 检测版本更新
			if(!update) update = new Update();
			update.checkUpdate();
		}
		
		public function destroyUpdate():void
		{
			if(update){
				update = null;
			}
		}
		
		public function callFromSQLiteManager(arr:Array):void
		{
			if(currentActiveWindow){
				switch(currentState){
					case INDEX:
					case AT:
					case COMMENT_ME:
					case COLLECT:
					case MY_WEIBO:
					case DIRECT_MESSAGE:
						var list:WeiboFormList = new WeiboFormList();
						list.listData(arr, currentActiveWindow.getContentWidth());
						currentActiveWindow.showWeibo(arr, list);
						break;
					case FANS:
					case FOLLOW:
						var userList:UserFormList = new UserFormList();
						userList.listData(arr, currentActiveWindow.getContentWidth());
						currentActiveWindow.showWeibo(arr, userList);
						break;
				}
			}
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
		private function loadFriendTimeLine(event:MicroBlogEvent):void
		{
//			list = event.result as Array;
//			var sh:SharedObject = SharedObject.getLocal("testData");
//			sh.data.arr = list;
//			sh.flush();
			if(this.currentActiveWindow){
//				this.currentActiveWindow.showWeibo(list);
			}
		}
		
		public function reloadTheme():void
		{
			
		}
	}
}