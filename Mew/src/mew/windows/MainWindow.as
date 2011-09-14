package mew.windows {
	import fl.controls.Button;
	import mew.data.SystemSettingData;
	import mew.factory.ButtonFactory;
	import mew.modules.UIButton;
	import mew.modules.UnreadTip;
	import mew.modules.UserAvatar;
	import widget.Widget;
	import com.greensock.TweenLite;
	import flash.display.DisplayObject;
	import flash.display.NativeWindow;
	import flash.display.NativeWindowInitOptions;
	import flash.display.Screen;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.MouseEvent;

	/**
	 * @author Abel Lee
	 */
	public class MainWindow extends NativeWindow {
		
		public var app:Mew = null;
		public var container:Sprite = null;
		
		public var unreadStatusButton:UnreadTip = null;
		public var unreadCommentButton:UnreadTip = null;
		public var unreadFansButton:UnreadTip = null;
		public var unreadDMButton:UnreadTip = null;
		public var unreadAtButton:UnreadTip = null;
		
		private var background:Sprite;     	   // 主界面背景
		
		public var indexBtn:UIButton;         // 首页按钮
		public var atBtn:UIButton;            // @按钮
		public var commentBtn:UIButton;       // 评论按钮
		public var dmBtn:UIButton;            // 私信按钮
		public var collectBtn:UIButton;       // 收藏按钮
		public var avatarBtn:UserAvatar;      // 头像按钮
		public var fansBtn:UIButton;          // 粉丝按钮
		public var followBtn:UIButton;        // 关注按钮
		public var sysBtn:UIButton;           // 系统按钮
		public var searchBtn:UIButton;        // 搜索按钮
		public var mewBtn:Button;             // Mew图标按钮
		public var publishBtn:UIButton;       // 发布按钮
		public var themeChooserBtn:UIButton;  // 主题按钮
		public var listBtn:UIButton;          // 帐号列表按钮
		public var refreshButton:UIButton;
		
		public var currentButton:DisplayObject = null;
		
		public function MainWindow(initOptions : NativeWindowInitOptions) {
			super(initOptions);
		}
		
		public function init():void
		{
			this.stage.scaleMode = StageScaleMode.NO_SCALE;
			this.stage.align = StageAlign.TOP_LEFT;
			
			// 初始化主界面
//			this.visible = false;
			this.stage.nativeWindow.width = Screen.mainScreen.visibleBounds.width;
			this.stage.nativeWindow.height = 90;
			this.stage.nativeWindow.x = Screen.mainScreen.visibleBounds.x;
			this.stage.nativeWindow.y = Screen.mainScreen.visibleBounds.y;
			this.stage.nativeWindow.alwaysInFront = SystemSettingData.alwaysInfront;
			
			container = new Sprite();
			this.stage.addChild(container);
			
			//TODO: 正式版需要在登陆后绘制主界面
			drawBackground();
			drawButtons();
		}
		
		private function drawBackground():void
		{
			if(!background) background = new Sprite();
			background.mouseChildren = false;
			background.graphics.beginFill(Widget.mainColor, 1.0);
			background.graphics.drawRect(0, 0, this.stage.nativeWindow.width, this.stage.nativeWindow.height - 10);
			background.graphics.endFill();
			container.addChildAt(background, 0);
			Widget.widgetGlowFilter(background, 5, 5);
			container.addEventListener(MouseEvent.MOUSE_OVER, showMainPanel);
			container.addEventListener(MouseEvent.ROLL_OUT, hideMainPanel);
		}
		
		private function showMainPanel(event:MouseEvent):void
		{
			if(SystemSettingData.autoHide && !app.currentActiveWindow && app.currentState == app.NONE){
				var pos:int = Screen.mainScreen.visibleBounds.y;
				switch(SystemSettingData.hideDirection){
					case 0:
						TweenLite.to(this.stage.nativeWindow, .3, {x: Screen.mainScreen.visibleBounds.x});
						break;
					case 1:
						this.stage.nativeWindow.x = Screen.mainScreen.visibleBounds.x;
						TweenLite.to(this.stage.nativeWindow, .3, {y: pos});
						break;
					case 2:
						TweenLite.to(this.stage.nativeWindow, .3, {x: Screen.mainScreen.visibleBounds.x});
						break;
				}
			}
		}
		
		public function noHide():void
		{
			this.stage.nativeWindow.x = Screen.mainScreen.visibleBounds.x;
			this.stage.nativeWindow.y = Screen.mainScreen.visibleBounds.y;
		}
		
		private function hideMainPanel(event:MouseEvent):void
		{
			if(SystemSettingData.autoHide && !app.currentActiveWindow && app.currentState == app.NONE){
				var pos:int = Screen.mainScreen.visibleBounds.y - this.stage.nativeWindow.height + 13;
				var xpos:int;
				switch(SystemSettingData.hideDirection){
					case 0:
						xpos = Screen.mainScreen.visibleBounds.x - this.stage.nativeWindow.width + 10;
						TweenLite.to(this.stage.nativeWindow, .3, {x: xpos});
						break;
					case 1:
						TweenLite.to(this.stage.nativeWindow, .3, {y: pos});
						break;
					case 2:
						xpos = Screen.mainScreen.visibleBounds.width - 10;
						TweenLite.to(this.stage.nativeWindow, .3, {x: xpos});
						break;
				}
			}
		}
		
		private function drawButtons():void
		{
			if(!indexBtn) indexBtn = ButtonFactory.MainIndexButton();
			if(!atBtn) atBtn = ButtonFactory.MainAtButton();
			if(!commentBtn) commentBtn = ButtonFactory.MainCommentButton();
			if(!dmBtn) dmBtn = ButtonFactory.MainDMButton();
			if(!collectBtn) collectBtn= ButtonFactory.MainCollectButton();
			if(!avatarBtn) avatarBtn = new UserAvatar();
			if(!fansBtn) fansBtn= ButtonFactory.MainFansButton();
			if(!followBtn) followBtn = ButtonFactory.MainFollowButton();
			if(!sysBtn) sysBtn = ButtonFactory.MainSystemButton();
			if(!searchBtn) searchBtn = ButtonFactory.MainSearchButton();
			if(!mewBtn) mewBtn = ButtonFactory.MainMewButton();
			if(!publishBtn) publishBtn = ButtonFactory.MainPublishButton();
			if(!refreshButton) refreshButton = ButtonFactory.RefreshButton();
//			if(!listBtn) listBtn = new Button();
//			if(!themeChooserBtn) themeChooserBtn = new Button();
			
//			listBtn.label = "下拉箭头";
//			listBtn.width = 60;
			
//			themeChooserBtn.label = "主题";
//			themeChooserBtn.width = 60;
			
			container.addChild(indexBtn);
			container.addChild(atBtn);
			container.addChild(commentBtn);
			container.addChild(dmBtn);
			container.addChild(collectBtn);
			container.addChild(avatarBtn);
			container.addChild(fansBtn);
			container.addChild(followBtn);
			container.addChild(sysBtn);
			container.addChild(mewBtn);
			container.addChild(publishBtn);
//			container.addChild(listBtn);
			container.addChild(searchBtn);
//			container.addChild(themeChooserBtn);
			container.addChild(refreshButton);
			
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
//			addListener(listBtn);
			addListener(searchBtn);
//			addListener(themeChooserBtn);
			addListener(refreshButton);
			
			var gap:uint = 40;
			var bottomSpace:uint = 20;
			
			avatarBtn.x = (this.stage.nativeWindow.width - avatarBtn.width) / 2;
			avatarBtn.y = (this.stage.nativeWindow.height - avatarBtn.height) / 2 - 5;
			
			var screenWidth:int = Screen.mainScreen.visibleBounds.width;
			if(screenWidth <= 1024){
				gap = 20;
				avatarBtn.x = (screenWidth - mewBtn.width - 20 - avatarBtn.width) / 2;
			}
			
//			listBtn.x = avatarBtn.x + (avatarBtn.width - listBtn.width) / 2;
//			listBtn.y = avatarBtn.y + avatarBtn.height + 5;
			
			/**
			 * 左边按钮
			 */
			collectBtn.toggle = true;
			collectBtn.x = avatarBtn.x - collectBtn.width - gap;
			collectBtn.y = this.stage.nativeWindow.height - collectBtn.height - bottomSpace;
			
			dmBtn.toggle = true;
			dmBtn.x = collectBtn.x - dmBtn.width - gap;
			dmBtn.y = this.stage.nativeWindow.height - dmBtn.height - bottomSpace;
			
			commentBtn.toggle = true;
			commentBtn.x = dmBtn.x - commentBtn.width - gap;
			commentBtn.y = this.stage.nativeWindow.height - commentBtn.height - bottomSpace;
			
			atBtn.toggle = true;
			atBtn.x = commentBtn.x - atBtn.width - gap;
			atBtn.y = this.stage.nativeWindow.height - atBtn.height - bottomSpace;
			
			indexBtn.toggle = true;
			indexBtn.x = atBtn.x - indexBtn.width - gap;
			indexBtn.y = this.stage.nativeWindow.height - indexBtn.height - bottomSpace;
			
			/**
			 * 右边按钮
			 */
			fansBtn.toggle = true;
			fansBtn.x = avatarBtn.x + avatarBtn.width + gap;
			fansBtn.y = this.stage.nativeWindow.height - fansBtn.height - bottomSpace;
			
			followBtn.toggle = true;
			followBtn.x = fansBtn.x + fansBtn.width + gap;
			followBtn.y = this.stage.nativeWindow.height - followBtn.height - bottomSpace;
			
			sysBtn.toggle = true;
			sysBtn.x = followBtn.x + followBtn.width + gap;
			sysBtn.y = this.stage.nativeWindow.height - sysBtn.height - bottomSpace;
			
			searchBtn.toggle = true;
			searchBtn.x = sysBtn.x + sysBtn.width + gap;
			searchBtn.y = this.stage.nativeWindow.height - searchBtn.height - bottomSpace;
			
//			themeChooserBtn.x = searchBtn.x + searchBtn.width + gap;
//			themeChooserBtn.y = this.stage.nativeWindow.height - themeChooserBtn.height - bottomSpace;
			
			publishBtn.x = searchBtn.x + searchBtn.width + gap;
			publishBtn.y = this.stage.nativeWindow.height - publishBtn.height - bottomSpace;
			
			refreshButton.x = publishBtn.x + publishBtn.width + gap;
			refreshButton.y = this.stage.nativeWindow.height - refreshButton.height - bottomSpace;
			
			mewBtn.x = this.stage.nativeWindow.width - mewBtn.width - 20;
			mewBtn.y = (this.stage.nativeWindow.height - mewBtn.height) / 2 - 10;
			
		}
		
		private function addListener(displayObject:DisplayObject):void
		{
			displayObject.addEventListener(MouseEvent.CLICK, app.openListWindow);
			displayObject.addEventListener(MouseEvent.MOUSE_OVER, mouseOverHandler);
			displayObject.addEventListener(MouseEvent.MOUSE_OUT, mouseOutHandler);
		}
		
		private function removeListener(displayObject:DisplayObject):void
		{
			displayObject.removeEventListener(MouseEvent.CLICK, app.openListWindow);
			displayObject.removeEventListener(MouseEvent.MOUSE_OVER, mouseOverHandler);
			displayObject.removeEventListener(MouseEvent.MOUSE_OUT, mouseOutHandler);
		}
		
		public function closePublishWindow():void
		{
			publishBtn.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
		}
		
		public function showUnread(cate:String, num:int):void
		{
			var curButton:UnreadTip;
			var finalNum:int = num;
			switch(cate){
				case app.INDEX:
					if(!unreadStatusButton){
						unreadStatusButton = new UnreadTip(num);
						unreadStatusButton.x = indexBtn.x + indexBtn.width + 2;
						container.addChild(unreadStatusButton);
					}else finalNum = uint(unreadStatusButton.label) + num;
					curButton = unreadStatusButton;
					break;
				case app.FANS:
					if(!unreadFansButton){
						unreadFansButton = new UnreadTip(num);
						unreadFansButton.x = fansBtn.x + fansBtn.width;
						container.addChild(unreadFansButton);
					}else finalNum = uint(unreadFansButton.label) + num;
					curButton = unreadFansButton;
					break;
				case app.DIRECT_MESSAGE:
					if(!unreadDMButton){
						unreadDMButton = new UnreadTip(num);
						unreadDMButton.x = dmBtn.x + dmBtn.width + 5;
						container.addChild(unreadDMButton);
					}else finalNum = uint(unreadDMButton.label) + num;
					curButton = unreadDMButton;
					break;
				case app.COMMENT:
					if(!unreadCommentButton){
						unreadCommentButton = new UnreadTip(num);
						unreadCommentButton.x = commentBtn.x + commentBtn.width + 4;
						container.addChild(unreadCommentButton);
					}else finalNum = uint(unreadCommentButton.label) + num;
					curButton = unreadCommentButton;;
					break;
				case app.AT:
					if(!unreadAtButton){
						unreadAtButton = new UnreadTip(num);
						unreadAtButton.x = atBtn.x + atBtn.width + 2;
						container.addChild(unreadAtButton);
					}else finalNum = uint(unreadAtButton.label) + num;
					curButton = unreadAtButton;;
					break;
			}
			curButton.y = 8;
			if(curButton){
				if(finalNum > 10) curButton.label = "10+";
				else curButton.label = finalNum + "";
			}
		}
		
		private function mouseOverHandler(event:MouseEvent):void{}
		private function mouseOutHandler(event:MouseEvent):void{}
		
		override public function close():void
		{
			unreadStatusButton = null;
			unreadCommentButton = null;
			unreadFansButton = null;
			unreadDMButton = null;
			unreadAtButton = null;
			
			if(container){
				container.removeEventListener(MouseEvent.MOUSE_OVER, showMainPanel);
				container.removeEventListener(MouseEvent.ROLL_OUT, hideMainPanel);
				container = null;
			}
		
			background = null;
			if(indexBtn) removeListener(indexBtn);
			if(atBtn) removeListener(atBtn);
			if(commentBtn) removeListener(commentBtn);
			if(dmBtn) removeListener(dmBtn);
			if(collectBtn) removeListener(collectBtn);
			if(avatarBtn) removeListener(avatarBtn);
			if(fansBtn) removeListener(fansBtn);
			if(followBtn) removeListener(followBtn);
			if(sysBtn) removeListener(sysBtn);
			if(searchBtn) removeListener(searchBtn);
			if(mewBtn) removeListener(mewBtn);
			if(publishBtn) removeListener(publishBtn);
			if(themeChooserBtn) removeListener(themeChooserBtn);
			if(listBtn) removeListener(listBtn);
			if(refreshButton) removeListener(refreshButton);
			indexBtn = null;
			atBtn = null;
			commentBtn = null;
			dmBtn = null;
			collectBtn = null;
			avatarBtn = null;
			fansBtn = null;
			followBtn = null;
			sysBtn = null;
			searchBtn = null;
			mewBtn = null;
			publishBtn = null;
			themeChooserBtn = null;
			listBtn = null;
			refreshButton = null;
			currentButton = null;
			app = null;
			
			super.close();
		}
	}
}
