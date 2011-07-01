package mew.data
{
	import flash.desktop.NativeApplication;
	import flash.display.NativeWindow;
	import flash.events.MouseEvent;
	
	import system.MewSystem;

	public class SystemSettingData
	{
		public static var autoLogin:Boolean = false;              // 自动登陆
		public static var autoRun:Boolean = false;                // 系统启动自动运行
		public static var needSQLite:Boolean = false;             // 是否需要连DB
		public static var checkUpdateAtStart:Boolean = true;      // 启动检测更新
		
		private static var _autoHide:Boolean = true;              // 鼠标离开时自动隐藏
		private static var _alwaysInfront:Boolean = true;         // 界面始终在最顶部

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

		public static function get alwaysInfront():Boolean
		{
			return _alwaysInfront;
		}

		public static function set alwaysInfront(value:Boolean):void
		{
			if(_alwaysInfront == value) return;
			if(NativeApplication.nativeApplication.openedWindows){
				for each(var win:NativeWindow in NativeApplication.nativeApplication.openedWindows){
					win.alwaysInFront = value;
				}
			}
			_alwaysInfront = value;
		}


	}
}