package com.iabel.util
{
	public class StringDetector
	{
		public function StringDetector()
		{
		}
		public static function getParam(param:String, prefix:String, suffix:String, str:String):String
		{
			var pattern:RegExp = new RegExp(param + "=" + prefix + "(?P<" + param + ">.+?)" + suffix);
			var arr:Array = str.match(pattern);
			return arr[param];
		}
	}
}