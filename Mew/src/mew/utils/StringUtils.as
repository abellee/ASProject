package mew.utils
{
	import widget.Widget;

	public class StringUtils
	{
		public function StringUtils()
		{
		}
		public static function transformTime(d:Date):String
		{
			var year:Number = d.getFullYear();
			var month:Number = d.getMonth() + 1;
			var date:Number = d.getDate();
			var hour:Number = d.getHours();
			var minute:Number = d.getMinutes();
			var second:Number = d.getSeconds();
			
			var now:Date = new Date();
			var nyear:Number = now.getFullYear();
			var nmonth:Number = now.getMonth() + 1;
			var ndate:Number = now.getDate();
			var nhour:Number = now.getHours();
			var nminute:Number = now.getMinutes();
			var nsecond:Number = now.getSeconds();
			
			if(year != nyear) return year + "年" + month + "月" + date + "日 " + (hour < 10 ? "0" + hour : hour) + ":" + (minute < 10 ? "0" + minute : minute);
			if(month != nmonth) return month  + "月" + date + "日 " + (hour < 10 ? "0" + hour : hour) + ":" + (minute < 10 ? "0" + minute : minute);
			if(date != ndate) return month  + "月" + date + "日 " + (hour < 10 ? "0" + hour : hour) + ":" + (minute < 10 ? "0" + minute : minute);
			else{
				if(hour != nhour) return "今天 " + (hour < 10 ? "0" + hour : hour) + ":" + (minute < 10 ? "0" + minute : minute);
				if(minute != nminute) return (nminute - minute) + "分钟前";
				else return (nsecond - second) + "秒前";
			}
		}
		public static function displayTopicAndAt(str:String):String
		{
			var topicPattern:RegExp = /#.+?#/g;
			var atPattern:RegExp = /@[\u4e00-\u9fa5\da-zA-Z_-]+/g;
			var topicArr:Array = str.match(topicPattern);
			var atArr:Array = str.match(atPattern);
			var s:String = "";
			var len:int = 0;
			if(topicArr){
				len = topicArr.length;
				for(var i:int = 0; i<len; i++){
					str = str.replace(new RegExp(topicArr[i], "g"), "<font color='" + Widget.topicColor + "'><a href='event:topic|"
						+ String(topicArr[i]).substring(1, String(topicArr[i]).length-1) + "'>" + topicArr[i] + "</a></font>");
				}
			}
			if(atArr){
				len = atArr.length;
				for(var j:int = 0; j<len; j++){
					str = str.replace(new RegExp(atArr[j], "g"), "<font color='" + Widget.atColor + "'><a href='event:at|" + String(atArr[j]).substr(1) + "'>" + atArr[j] + "</a></font>");
				}
			}
			return str;
		}
		public static function getURLs(str:String):Array
		{
			var urlPattern:RegExp = /(http|https):\/\/[a-zA-Z.-\d\/\#\?\&\=]+/g;
			return str.match(urlPattern);
		}
		
		public static function getStringLength(str:String):Number
		{
			var chinesePattern:RegExp = /[^\x00-\xff]/g;
			var arr:Array = str.match(chinesePattern);
			var len:Number = 0;
			for each(var s:String in arr){
				len += s.length;
			}
			len += (str.length - len) * .5;
			
			return len;
		}
	}
}