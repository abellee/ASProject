package mew.utils {
	/**
	 * @author Abel Lee
	 */
	public class MewUtils {
		public function MewUtils() {
		}
		public static function ObjectToArray(obj:Object):Array
		{
			var arr:Array = [];
			for(var key:String in obj){
				arr.push(obj[key]);
				delete obj[key];
			}
			return arr;
		}
		
		public static function ArrayToObject(arr:Array):Object
		{
			var obj:Object = {};
			for each (var i : Object in arr) {
				obj[i.id] = i;
			}
			return obj;
		}
	}
}
