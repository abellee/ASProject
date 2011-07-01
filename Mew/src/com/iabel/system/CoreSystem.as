package com.iabel.system
{
	
	public class CoreSystem
	{
		private static var curTime:int = 0;
		private static var totalTimes:int = 1000;
		
//		public static var application:Object;
		
		public function CoreSystem()
		{
		}
		
		/**
		 * 建议在删除多少个可显示物件后进行强制垃圾回收
		 * 默认为 1000
		 * 设置为 0 可禁用建议强制垃圾回收记数
		 */
		public static function adviceGCTimes(times:int):void
		{
			totalTimes = times;
		}
		
		public static function objectDestroied():void
		{
			if(totalTimes == 0) return;
			curTime++;
			if(curTime >= totalTimes){
				trace("gc");
				GC.gc();
				curTime = 0;
			}
		}
	}
}