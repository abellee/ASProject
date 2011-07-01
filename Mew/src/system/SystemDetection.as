package system
{
	import config.Config;
	
	import flash.system.Capabilities;

	public class SystemDetection
	{
		public function SystemDetection()
		{
		}
		
		public static function isLion():Boolean
		{
			if(Capabilities.os == Config.LION) return true;
			else return false;
		}
		
		public static function isWindows():Boolean
		{
			if(Capabilities.os.toLowerCase().indexOf("win") != -1) return true;
			else return false;
		}
		
		public static function isMac():Boolean
		{
			if(Capabilities.os.toLowerCase().indexOf("mac") != -1) return true;
			else return false;
		}
		
	}
}