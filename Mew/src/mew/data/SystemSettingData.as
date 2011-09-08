package mew.data
{
	import config.Theme;
	
	import flash.desktop.NativeApplication;
	import flash.display.NativeWindow;
	import flash.events.MouseEvent;
	
	import system.MewSystem;

	public class SystemSettingData
	{
		/**
		 * 帐号设置
		 */
		public static var autoLogin:Boolean = false;              // 自动登陆
		
		/**
		 * 系统设置
		 */
		public static var hideDirection:int = 1;                  // 主界面隐藏的方向 0：左 1：上 2：右
		public static var _autoRun:Boolean = false;               // 系统启动自动运行
		public static var checkUpdateDelay:int = 0;               // 检测更新间隔天数
		private static var _autoHide:Boolean = true;              // 鼠标离开时自动隐藏
		private static var _alwaysInfront:Boolean = true;         // 界面始终在最顶部
		
		/**
		 * 提示设置
		 */
		public static var isVoice:Boolean = true;
		public static var atNotice:Boolean = true;
		public static var dmNotice:Boolean = true;
		public static var fansNotice:Boolean = true;
		public static var weiboNotice:Boolean = true;
		public static var commentNotice:Boolean = true;
		
		/**
		 * 自动登录的帐号
		 */
		public static var _accessTokenKey:String = "";
		public static var _accessTokenSecret:String = "";
		public static var _verified:Boolean = false;
		public static var curTheme:String = Theme.DEFAULT;
		
		/**
		 * 跳过的版本号
		 */
		public static var skipVersionNumber:Number = 0;
		
		public static function get autoHide():Boolean
		{
			return _autoHide;
		}

		public static function set autoHide(value:Boolean):void
		{
			if(_autoHide == value) return;
			if(!value) MewSystem.app.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_OVER));
			_autoHide = value;
		}
		
		public static function get autoRun():Boolean
		{
			return _autoRun;
		}
		
		public static function set autoRun(value:Boolean):void
		{
			if(value == _autoRun) return;
			NativeApplication.nativeApplication.startAtLogin = value;
			_autoRun = value;
		}

		public static function get alwaysInfront():Boolean
		{
			return _alwaysInfront;
		}

		public static function set alwaysInfront(value:Boolean):void
		{
			if(_alwaysInfront == value) return;
			_alwaysInfront = value;
			if(NativeApplication.nativeApplication.openedWindows){
				for each(var win:NativeWindow in NativeApplication.nativeApplication.openedWindows){
					win.alwaysInFront = value;
				}
			}
		}


	}
}