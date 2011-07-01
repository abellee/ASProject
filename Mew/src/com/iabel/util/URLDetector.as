package com.iabel.util
{
	public class URLDetector
	{
		public function URLDetector()
		{
		}
		public static function getParam(param:String, url:String):String
		{
			var pattern:RegExp = new RegExp(param + "=(?P<" + param + ">.+?)&*");
			var arr:Array = url.match(pattern);
			return arr[param];
		}
		public static function getParamsList(url:String):Object
		{
			var obj:Object = null;
			var arr:Array = url.split("?");
			if(arr.length == 1) return null;
			else if(arr.length >= 2){
				var str:String = arr[1];
				arr = str.split("&");
				for each(var s:String in arr){
					var tempArr:Array = s.split("=");
					if(tempArr.length == 2){
						if(!obj) obj = {};
						obj[tempArr[0]] = tempArr[1];
					}
				}
			}
			return obj;
		}
	}
}