package mew.windows
{
	import com.greensock.TweenLite;
	import com.sina.microblog.data.MicroBlogUser;
	import com.sina.microblog.events.MicroBlogErrorEvent;
	import com.sina.microblog.events.MicroBlogEvent;
	
	import fl.controls.Button;
	import fl.controls.CheckBox;
	import fl.controls.ComboBox;
	import fl.controls.Label;
	
	import flash.desktop.NativeApplication;
	import flash.display.NativeWindowInitOptions;
	import flash.display.Screen;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	import mew.communication.LocalManager;
	import mew.data.SystemSettingData;
	
	import system.MewSystem;
	
	public class LoginWindow extends ALNativeWindow
	{
		public static var instance:LoginWindow = null;
		private var loginBtn:Button;
		private var closeBtn:Button;
		private var weiboChooser:ComboBox;
		private var registLabel:Label;
		private var forgetLabel:Label;
		private var mewLoginLabel:Label;
		private var autoLogin:CheckBox;
		
		private var oauthWindow:OAuthWindow;              // oauth授权界面
		
		public function LoginWindow(initOptions:NativeWindowInitOptions)
		{
			super(initOptions);
		}
		
		override protected function init():void
		{
			instance = this;
			
			drawBackground(350, 400);
			
			this.stage.nativeWindow.width = background.width + 20;
			this.stage.nativeWindow.height = background.height + 20;
			this.stage.nativeWindow.x = (Screen.mainScreen.visibleBounds.width - this.stage.nativeWindow.width) / 2;
			this.stage.nativeWindow.y = (Screen.mainScreen.visibleBounds.height - this.stage.nativeWindow.height) / 2;
			
			closeBtn = new Button();
			closeBtn.label = "关闭";
			addChild(closeBtn);
			closeBtn.x = this.stage.nativeWindow.width - 15 - closeBtn.width;
			closeBtn.y = 15;
			closeBtn.addEventListener(MouseEvent.CLICK, exitApplication);
			
			weiboChooser = new ComboBox();
			addChild(weiboChooser);
			weiboChooser.width = background.width - 40;
			weiboChooser.x = (background.width - weiboChooser.width) / 2 + background.x;
			weiboChooser.y = (background.height - weiboChooser.height) / 2 + background.y;
			
			loginBtn = new Button();
			loginBtn.label = "登录";
			addChild(loginBtn);
			loginBtn.x = weiboChooser.x + weiboChooser.width - loginBtn.width;
			loginBtn.y = weiboChooser.y + weiboChooser.height + 20;
			loginBtn.addEventListener(MouseEvent.CLICK, oauthLogin);
			
			autoLogin = new CheckBox();
			autoLogin.setStyle("focusRectSkin", new Sprite());
			autoLogin.label = "自动登录";
			autoLogin.selected = SystemSettingData.autoLogin;
			addChild(autoLogin);
			autoLogin.x = weiboChooser.x;
			autoLogin.y = loginBtn.y + (loginBtn.height - autoLogin.height) / 2;
			autoLogin.addEventListener(Event.CHANGE, setAutoLogin);
			
			registLabel = new Label();
			registLabel.text = "立即注册新浪用户";
			registLabel.width = registLabel.textField.textWidth;
			registLabel.addEventListener(MouseEvent.CLICK, registSinaUser);
			
			forgetLabel = new Label();
			forgetLabel.text = "忘记密码了?";
			forgetLabel.width = forgetLabel.textField.textWidth + 2;
			forgetLabel.addEventListener(MouseEvent.CLICK, forgetPassword);
			
			mewLoginLabel = new Label();
			mewLoginLabel.text = "Mew用户登录";
			mewLoginLabel.width = mewLoginLabel.textField.textWidth;
			mewLoginLabel.addEventListener(MouseEvent.CLICK, mewUserLogin);
			
			addChild(registLabel);
			addChild(forgetLabel);
			addChild(mewLoginLabel);
			
			var gap:uint = (weiboChooser.width - registLabel.width - forgetLabel.width - mewLoginLabel.width) / 2;
			
			registLabel.x = weiboChooser.x;
			registLabel.y = background.y + background.height - registLabel.height - 10;
			
			forgetLabel.x = gap + registLabel.x + registLabel.width;
			forgetLabel.y = registLabel.y;
			
			mewLoginLabel.x = loginBtn.width + loginBtn.x - mewLoginLabel.width;
			mewLoginLabel.y = registLabel.y;
			if(SystemSettingData.autoLogin){
				if(SystemSettingData._verified){
					verifyCredential();
				}
			}
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
			if(!SystemSettingData._verified){
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
			MewSystem.microBlog.accessTokenKey = SystemSettingData._accessTokenKey;
			MewSystem.microBlog.accessTokenSecrect = SystemSettingData._accessTokenSecret;
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
			loginBtn.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
		}
		
		private function onVerifyCredentialResult(event:MicroBlogEvent):void
		{
			// 尽可能晚的创建周边的功能块 所以在验证成功后再创建
			MewSystem.app.initWidgets();
			
			SystemSettingData._verified = true;
			MewSystem.microBlog.removeEventListener(MicroBlogEvent.VERIFY_CREDENTIALS_RESULT, onVerifyCredentialResult);
			LocalManager.setSettingsInSharedObject("accessTokenKey", SystemSettingData._accessTokenKey);
			LocalManager.setSettingsInSharedObject("accessTokenSecret", SystemSettingData._accessTokenSecret);
			MewSystem.app.userData = MewSystem.app.dataCache.getUserDataCache(event.result as MicroBlogUser);
			if(oauthWindow){
				oauthWindow.close();
				return;
			}
			MewSystem.app.loginSuccess();
		}
		
		override protected function drawBackground(w:int, h:int):void
		{
			super.drawBackground(w, h);
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
			loginBtn = null;
			closeBtn = null;
			autoLogin = null;
			instance = null;
			weiboChooser = null;
			registLabel = null;
			forgetLabel = null;
			mewLoginLabel = null;
			oauthWindow = null;
		}
	}
}