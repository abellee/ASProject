package system
{
	import config.Config;
	
	import flash.system.Capabilities;

	public class SystemDetection
	{
		public function SystemDetection()
		{
		}
		public static function isWindows():Boolean
		{
			if(Capabilities.os.toLowerCase().indexOf("win") != -1) return true;
			else return false;
		}
		
		public static function isXP():Boolean
		{
			if(Capabilities.os.indexOf("Windows XP") != -1) return true;
			else return false;
		}
		
		public static function isWin7():Boolean
		{
			if(Capabilities.os == "Windows 7") return true;
			else return false;
		}
		
		public static function isMac():Boolean
		{
			if(Capabilities.os.toLowerCase().indexOf("mac") != -1) return true;
			else return false;
		}
		
	}
}