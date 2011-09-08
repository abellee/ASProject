package mew.modules {
	import config.Config;

	import fl.controls.Button;
	import fl.controls.CheckBox;

	import mew.data.SystemSettingData;
	import mew.factory.ButtonFactory;

	import com.iabel.core.UISprite;

	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.SharedObject;
	
	public class AccountSettingContainer extends UISprite implements ISystemSettingContainer
	{
		private var clearCacheButton:Button = null;
		private var autoLogin:CheckBox = null;
		public function AccountSettingContainer()
		{
			super();
		}
		
		public function init():void
		{
			if(!autoLogin) autoLogin = ButtonFactory.SystemCheckBox();
			if(!clearCacheButton) clearCacheButton = ButtonFactory.WhiteButton();
			clearCacheButton.width = 120;
			autoLogin.label = "自动登录";
			clearCacheButton.label = "清空帐号缓存";
			
			addChild(autoLogin);
			addChild(clearCacheButton);
			clearCacheButton.x = autoLogin.x;
			clearCacheButton.y = autoLogin.y + autoLogin.height + 10;
			clearCacheButton.addEventListener(MouseEvent.CLICK, clearCacheButton_mouseClickHandler);
			
			customSetting();
		}
		
		private function customSetting():void
		{
			autoLogin.selected = SystemSettingData.autoLogin;
		}
		
		public function setDefault():void
		{
			autoLogin.selected = false;
		}
		
		public function get isAutoLogin():Boolean
		{
			return autoLogin.selected;
		}
		
		private function clearCacheButton_mouseClickHandler(event:MouseEvent):void
		{
			var so:SharedObject = SharedObject.getLocal(Config.MEWCACHE);
			so.data.accessTokenKey = null;
			so.data.accessTokenSecret = null;
			so.data.user = {};
			so.flush();
			so.close();
		}
		
		public function save():void
		{
			var so:SharedObject = SharedObject.getLocal(Config.MEWCACHE);
			so.data.autoLogin = autoLogin.selected;
			so.flush();
			SystemSettingData.autoLogin = autoLogin.selected;
		}
		
		override protected function dealloc(event:Event):void
		{
			super.dealloc(event);
			clearCacheButton.removeEventListener(MouseEvent.CLICK, clearCacheButton_mouseClickHandler);
			autoLogin = null;
			clearCacheButton = null;
		}
		
		/**
		 * for interface
		 */
		public function get isVoice():Boolean
		{
			return true;
		}
		
		public function get isWBNotice():Boolean
		{
			return true;
		}
		
		public function get isAtNotice():Boolean
		{
			return true;
		}
		
		public function get isDMNotice():Boolean
		{
			return true;
		}
		
		public function get isFansComment():Boolean
		{
			return true;
		}
		
		public function get isCommentNotice():Boolean
		{
			return true;
		}
		
		public function get hideDir():int
		{
			return 1;
		}
		
		public function get updateDelay():int
		{
			return 0;
		}
		
		public function get alwaysInFront():Boolean
		{
			return true;
		}
		
		public function get isAutoHide():Boolean
		{
			return true;
		}
		
		public function get isAutoRun():Boolean
		{
			return true;
		}
	}
}