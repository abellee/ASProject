package mew.windows {
	import fl.controls.Button;
	import fl.controls.CheckBox;
	import fl.controls.ComboBox;
	import fl.controls.Label;
	import fl.data.DataProvider;

	import mew.communication.LocalManager;
	import mew.data.SystemSettingData;
	import mew.factory.ButtonFactory;
	import mew.factory.StaticAssets;

	import resource.Resource;

	import system.MewSystem;

	import widget.Widget;

	import com.greensock.TweenLite;
	import com.iabel.utils.ScaleBitmap;
	import com.sina.microblog.data.MicroBlogUser;
	import com.sina.microblog.events.MicroBlogErrorEvent;
	import com.sina.microblog.events.MicroBlogEvent;

	import flash.desktop.NativeApplication;
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.NativeWindowInitOptions;
	import flash.display.Screen;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.text.TextFormat;
	
	public class LoginWindow extends ALNativeWindow
	{
		public static var instance:LoginWindow = null;
		private var loginBtn:Button;
		private var closeBtn:Button;
		private var accChooser:ComboBox;
		private var registLabel:Label;
		private var forgetLabel:Label;
		private var mewLoginLabel:Label;
		private var autoLogin:CheckBox;
		private var topBitmap:Bitmap;
		private var imageFrame:Bitmap;
		private var weiboButton:Button;
		private var userAvatar:Bitmap;
		private var defaultAvatar:Bitmap;
		private var clearAccount:Label;
		
		private var labelMouseOutFormat:TextFormat = new TextFormat(Widget.systemFont, 12, 0x434343);
		private var labelMouseOverFormat:TextFormat = new TextFormat(Widget.systemFont, 12, 0x767676);
		
		private var oauthWindow:OAuthWindow;              // oauth授权界面
		
		public function LoginWindow(initOptions:NativeWindowInitOptions)
		{
			super(initOptions);
		}
		
		override protected function init():void
		{
			instance = this;
			
			drawBackground(350, 380);
			
			this.stage.nativeWindow.width = background.width + 20;
			this.stage.nativeWindow.height = background.height + 20;
			this.stage.nativeWindow.x = (Screen.mainScreen.visibleBounds.width - this.stage.nativeWindow.width) / 2;
			this.stage.nativeWindow.y = (Screen.mainScreen.visibleBounds.height - this.stage.nativeWindow.height) / 2;
			
			closeBtn = ButtonFactory.CloseButton();
			addChild(closeBtn);
			closeBtn.x = this.stage.nativeWindow.width - 20 - closeBtn.width;
			closeBtn.y = 20;
			closeBtn.addEventListener(MouseEvent.CLICK, exitApplication);
			
			topBitmap = new Resource.LoginTop();
			addChild(topBitmap);
			topBitmap.x = 10;
			topBitmap.y = 20;
			
			imageFrame = new ScaleBitmap((new (Resource.ImageBackgroundSkin)() as Bitmap).bitmapData, "auto", true);
			imageFrame.scale9Grid = new Rectangle(5, 5, 10, 10);
			imageFrame.width = 66;
			imageFrame.height = 66;
			addChild(imageFrame);
			imageFrame.x = 45;
			imageFrame.y = topBitmap.y + topBitmap.height + 30;
			
			weiboButton = ButtonFactory.BlackButton();
			weiboButton.width = 180;
			weiboButton.height = 40;
			weiboButton.setStyle("textFormat", Widget.normalGrayFormat);
			weiboButton.setStyle("icon", Resource.SinaLogo);
			weiboButton.label = "新浪微博";
			addChild(weiboButton);
			weiboButton.x = imageFrame.x + imageFrame.width + 30;
			weiboButton.y = imageFrame.y - 4;
			
			var userAccounts:Object = LocalManager.getUserAccount();
			var dp:DataProvider = new DataProvider();
			for(var key:String in userAccounts){
				if(userAccounts[key]["default"]) dp.addItemAt({label:userAccounts[key]["username"], isDefault:userAccounts[key]["default"], account:key, password:userAccounts[key]["password"], id:userAccounts[key]["id"]}, 0);
				else dp.addItem({label:userAccounts[key]["username"], isDefault:false, account:key, password:userAccounts[key]["password"], id:userAccounts[key]["id"]});
			}
			dp.addItem({label: "其它帐号登录..."});
			accChooser = ButtonFactory.SystemComboBox();
			accChooser.textField.setStyle("textFormat", Widget.normalGrayFormat);
			accChooser.textField.setStyle("textPadding", 4);
			addChild(accChooser);
			accChooser.width = 180;
			accChooser.height = 30;
			accChooser.x = weiboButton.x;
			accChooser.y = weiboButton.y + weiboButton.height + 5;
			accChooser.dataProvider = dp;
			accChooser.addEventListener(Event.CHANGE, reloadAvatar);
			
			clearAccount = new Label();
			clearAccount.setStyle("textFormat", labelMouseOutFormat);
			clearAccount.text = "清除当前帐户";
			addChild(clearAccount);
			clearAccount.addEventListener(MouseEvent.MOUSE_OVER, onLabelMouseOver);
			clearAccount.addEventListener(MouseEvent.MOUSE_OUT, onLabelMouseOut);
			clearAccount.addEventListener(MouseEvent.CLICK, onLabelMouseClick);
			clearAccount.x = accChooser.x;
			clearAccount.y = accChooser.y + accChooser.height + 5;
			
			loginBtn = ButtonFactory.OrangeButton();
			loginBtn.width = 100;
			loginBtn.height = 40;
			loginBtn.setStyle("textFormat", new TextFormat(Widget.systemFont, 18, Widget.orangeButtonFontColor, true));
			loginBtn.label = "登  录";
			addChild(loginBtn);
			loginBtn.x = accChooser.x + accChooser.width - loginBtn.width;
			loginBtn.y = accChooser.y + accChooser.height + 45;
			loginBtn.addEventListener(MouseEvent.CLICK, oauthLogin);
			
			autoLogin = ButtonFactory.SystemCheckBox();
			autoLogin.setStyle("textFormat", Widget.normalGrayFormat);
			autoLogin.label = "自动登录";
			autoLogin.selected = SystemSettingData.autoLogin;
			addChild(autoLogin);
			autoLogin.x = imageFrame.x;
			autoLogin.y = loginBtn.y + (loginBtn.height - autoLogin.height) / 2;
			autoLogin.addEventListener(Event.CHANGE, setAutoLogin);
			
			registLabel = new Label();
			registLabel.setStyle("textFormat", Widget.normalFormat);
			registLabel.text = "立即注册新浪用户";
			registLabel.width = registLabel.textField.textWidth + 5;
			registLabel.addEventListener(MouseEvent.CLICK, registSinaUser);
			registLabel.addEventListener(MouseEvent.MOUSE_OVER, registLabel_mouseOverHander);
			registLabel.addEventListener(MouseEvent.MOUSE_OUT, registLabel_mouseOutHander);
			
			forgetLabel = new Label();
			forgetLabel.setStyle("textFormat", Widget.normalFormat);
			forgetLabel.text = "忘记密码了?";
			forgetLabel.width = forgetLabel.textField.textWidth + 5;
			forgetLabel.addEventListener(MouseEvent.CLICK, forgetPassword);
			forgetLabel.addEventListener(MouseEvent.MOUSE_OVER, registLabel_mouseOverHander);
			forgetLabel.addEventListener(MouseEvent.MOUSE_OUT, registLabel_mouseOutHander);
			
			mewLoginLabel = new Label();
			mewLoginLabel.setStyle("textFormat", Widget.normalFormat);
			mewLoginLabel.enabled = false;
			mewLoginLabel.text = "Mew用户登录";
			mewLoginLabel.width = mewLoginLabel.textField.textWidth + 9;
//			mewLoginLabel.addEventListener(MouseEvent.CLICK, mewUserLogin);
			
			addChild(registLabel);
			addChild(forgetLabel);
			addChild(mewLoginLabel);
			
			var gap:uint = (accChooser.x + accChooser.width - imageFrame.x - registLabel.width - forgetLabel.width - mewLoginLabel.width) / 2;
			
			registLabel.x = imageFrame.x;
			registLabel.y = background.y + background.height - registLabel.height - 10;
			
			forgetLabel.x = gap + registLabel.x + registLabel.width;
			forgetLabel.y = registLabel.y;
			
			mewLoginLabel.x = loginBtn.width + loginBtn.x - mewLoginLabel.width;
			mewLoginLabel.y = registLabel.y;
			
			loadAvatar(0);
			
			if(SystemSettingData.autoLogin){
				if(SystemSettingData._verified){
					verifyCredential();
				}
			}
		}

		private function registLabel_mouseOutHander(event : MouseEvent) : void
		{
			(event.currentTarget as Label).setStyle("textFormat", Widget.normalFormat);
		}

		private function registLabel_mouseOverHander(event : MouseEvent) : void
		{
			(event.currentTarget as Label).setStyle("textFormat", labelMouseOverFormat);
		}

		private function onLabelMouseClick(event : MouseEvent) : void
		{
			LocalManager.removeUserSharedObject(accChooser.selectedItem.account, accChooser.selectedItem.isDefault);
			accChooser.removeItemAt(accChooser.selectedIndex);
			accChooser.textField.setStyle("textFormat", Widget.normalGrayFormat);
			accChooser.textField.setStyle("textPadding", 4);
			loadAvatar(accChooser.selectedIndex);
		}

		private function onLabelMouseOut(event : MouseEvent) : void
		{
			clearAccount.setStyle("textFormat", labelMouseOutFormat);
		}

		private function onLabelMouseOver(event : MouseEvent) : void
		{
			clearAccount.setStyle("textFormat", labelMouseOverFormat);
		}

		private function reloadAvatar(event : Event) : void
		{
			loadAvatar(accChooser.selectedIndex);
		}
		
		private function loadAvatar(index:int):void
		{
			var id:String = accChooser.getItemAt(index).id;
			if(id){
				var file:File = File.applicationStorageDirectory.resolvePath("cache/" + id + ".jpg");
				if(file.exists){
					var func:Function = function(event:Event):void
					{
						file.removeEventListener(Event.COMPLETE, func);
						var loader:Loader = new Loader();
						var nfunc:Function = function(event:Event):void
						{
							if(userAvatar) userAvatar.bitmapData.dispose();
							userAvatar = null;
							loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, nfunc);
							userAvatar = loader.content as Bitmap;
							if(defaultAvatar){
								if(container.contains(defaultAvatar)) removeChild(defaultAvatar);
								defaultAvatar = null;
							}
							addChild(userAvatar);
							userAvatar.alpha = 0;
							userAvatar.x = imageFrame.x + (imageFrame.width - userAvatar.width) / 2;
							userAvatar.y = imageFrame.y + (imageFrame.height - userAvatar.height) / 2;
							TweenLite.to(userAvatar, .3, {alpha: 1});
						};
						loader.contentLoaderInfo.addEventListener(Event.COMPLETE, nfunc);
						loader.loadBytes(file.data);
					};
					file.addEventListener(Event.COMPLETE, func);
					file.load();
				}else{
					//TODO: 显示默认图片
					addDefault();
				}
			}else{
				addDefault();
			}
		}
		
		private function addDefault():void
		{
			if(!defaultAvatar) defaultAvatar = new Bitmap(StaticAssets.DefaultAvatar50());
			addChild(defaultAvatar);
			defaultAvatar.x = imageFrame.x + (imageFrame.width - defaultAvatar.width) / 2;
			defaultAvatar.y = imageFrame.y + (imageFrame.height - defaultAvatar.height) / 2;
		}
		
		private function mewUserLogin(event:MouseEvent):void
		{
			
		}
		
		private function registSinaUser(event:MouseEvent):void
		{
			navigateToURL(new URLRequest("http://weibo.com/reg.php"));
		}
		
		private function forgetPassword(event:MouseEvent):void
		{
			navigateToURL(new URLRequest("http://login.sina.com.cn/member/getpwd/getpwd0.php?entry=sso"));
		}
		
		private function setAutoLogin(event:Event):void
		{
			SystemSettingData.autoLogin = autoLogin.selected;
		}
		
		private function exitApplication(event:MouseEvent):void
		{
			NativeApplication.nativeApplication.exit();
		}
		
		private function oauthLogin(event:MouseEvent):void
		{
			if(!SystemSettingData._verified || accChooser.selectedIndex == (accChooser.dataProvider.length - 1)){
				SystemSettingData._verified = false;
				SystemSettingData._accessTokenKey = "";
				SystemSettingData._accessTokenSecret = "";
				var nativeWindowInitOption:NativeWindowInitOptions = new NativeWindowInitOptions();
				
				if(!oauthWindow) oauthWindow = new OAuthWindow(nativeWindowInitOption);
				oauthWindow.addEventListener(Event.CLOSE, oauthWindow_closeHandler);
				oauthWindow.activate();
				
				var centerX:uint = (Screen.mainScreen.visibleBounds.width - oauthWindow.width) / 2;
				var oauthTargetPos:uint = centerX - this.stage.nativeWindow.width / 2 - 20;
				oauthWindow.x = oauthTargetPos;
				oauthWindow.y = (Screen.mainScreen.visibleBounds.height - oauthWindow.height) / 2;
				var thisTargetPos:int = oauthTargetPos + oauthWindow.stage.nativeWindow.width + 20;
				if(Screen.mainScreen.visibleBounds.width >= 1200){
					TweenLite.to(this.stage.nativeWindow, .3, {x:thisTargetPos});
				}
				
			}else{
				verifyCredential();
			}
		}
		
		private function oauthWindow_closeHandler(event:Event):void
		{
			oauthWindow.removeEventListener(Event.CLOSE, oauthWindow_closeHandler);
			oauthWindow = null;
			if(!SystemSettingData._verified){
				SystemSettingData._accessTokenKey = "";
				SystemSettingData._accessTokenSecret = "";
				var centerX:uint = (Screen.mainScreen.visibleBounds.width - this.stage.nativeWindow.width) / 2;
				TweenLite.to(this.stage.nativeWindow, .3, {x:centerX});
			}else{
				MewSystem.app.loginSuccess();
			}
		}
		
		public function verifyCredential():void
		{
			MewSystem.microBlog.addEventListener(MicroBlogEvent.VERIFY_CREDENTIALS_RESULT, onVerifyCredentialResult);
			MewSystem.microBlog.addEventListener(MicroBlogErrorEvent.VERIFY_CREDENTIALS_ERROR, onVerifyCredentialError);
			if(accChooser.selectedItem["account"]){
				SystemSettingData._accessTokenKey = accChooser.selectedItem["account"];
				SystemSettingData._accessTokenSecret = accChooser.selectedItem["password"];
				MewSystem.microBlog.accessTokenKey = accChooser.selectedItem["account"];
				MewSystem.microBlog.accessTokenSecrect = accChooser.selectedItem["password"];
			}else{
				MewSystem.microBlog.accessTokenKey = SystemSettingData._accessTokenKey;
				MewSystem.microBlog.accessTokenSecrect = SystemSettingData._accessTokenSecret;
			}
			MewSystem.microBlog.verifyCredentials();
		}
		
		/**
		 * 认证失败
		 * 重新打开oauth界面进入认证
		 */
		private function onVerifyCredentialError(event:MicroBlogErrorEvent):void
		{
			MewSystem.microBlog.removeEventListener(MicroBlogEvent.VERIFY_CREDENTIALS_RESULT, onVerifyCredentialResult);
			MewSystem.microBlog.removeEventListener(MicroBlogErrorEvent.VERIFY_CREDENTIALS_ERROR, onVerifyCredentialError);
			SystemSettingData._accessTokenKey = "";
			SystemSettingData._accessTokenSecret = "";
			SystemSettingData._verified = false;
			if(oauthWindow.active){
				oauthWindow.close();
				oauthWindow = null;
			}
			loginBtn.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
			MewSystem.showLightAlert("登录失败，请重新授权!", container);
		}
		
		private function onVerifyCredentialResult(event:MicroBlogEvent):void
		{
			// 尽可能晚的创建周边的功能块 所以在验证成功后再创建
			MewSystem.app.initWidgets();
			
			SystemSettingData._verified = true;
			MewSystem.microBlog.removeEventListener(MicroBlogEvent.VERIFY_CREDENTIALS_RESULT, onVerifyCredentialResult);
			MewSystem.app.userData = MewSystem.app.dataCache.getUserDataCache(event.result as MicroBlogUser);
			LocalManager.setUserSharedObject(SystemSettingData._accessTokenKey, SystemSettingData._accessTokenSecret,
			MewSystem.app.userData.username, MewSystem.app.userData.id);
			if(oauthWindow){
				oauthWindow.close();
				return;
			}
			MewSystem.app.loginSuccess();
		}
		
		override protected function drawBackground(w:int, h:int, position:String = null):void
		{
			super.drawBackground(w, h, null);
			background.addEventListener(MouseEvent.MOUSE_DOWN, dragLoginPanel);
		}
		
		private function dragLoginPanel(event:MouseEvent):void
		{
			this.stage.nativeWindow.startMove();
		}
		
		override protected function dealloc(event:Event):void
		{
			super.dealloc(event);
			if(loginBtn) loginBtn.removeEventListener(MouseEvent.CLICK, oauthLogin);
			if(closeBtn) closeBtn.removeEventListener(MouseEvent.CLICK, exitApplication);
			if(autoLogin) autoLogin.removeEventListener(Event.CHANGE, setAutoLogin);
			if(registLabel) registLabel.removeEventListener(MouseEvent.CLICK, registSinaUser);
			if(forgetLabel) forgetLabel.removeEventListener(MouseEvent.CLICK, forgetPassword);
			if(mewLoginLabel) mewLoginLabel.removeEventListener(MouseEvent.CLICK, mewUserLogin);
			if(autoLogin) autoLogin.removeEventListener(Event.CHANGE, setAutoLogin);
			if(oauthWindow) oauthWindow.removeEventListener(Event.CLOSE, oauthWindow_closeHandler);
			if(accChooser) accChooser.removeEventListener(Event.CHANGE, reloadAvatar);
			if(clearAccount){
				clearAccount.removeEventListener(MouseEvent.MOUSE_OVER, onLabelMouseOver);
				clearAccount.removeEventListener(MouseEvent.MOUSE_OUT, onLabelMouseOut);
				clearAccount.removeEventListener(MouseEvent.CLICK, onLabelMouseClick);
				clearAccount = null;
			}
			loginBtn = null;
			closeBtn = null;
			autoLogin = null;
			instance = null;
			accChooser = null;
			registLabel = null;
			forgetLabel = null;
			mewLoginLabel = null;
			oauthWindow = null;
			if(topBitmap && topBitmap.bitmapData) topBitmap.bitmapData.dispose();
			if(imageFrame && imageFrame.bitmapData) imageFrame.bitmapData.dispose();
			if(userAvatar && userAvatar.bitmapData) userAvatar.bitmapData.dispose();
			topBitmap = null;
			imageFrame = null;
			userAvatar = null;
			labelMouseOutFormat = null;
			labelMouseOverFormat = null;
			defaultAvatar = null;
		}
	}
}