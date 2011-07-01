package system
{
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import mew.data.TimingWeiboData;
	import mew.data.TimingWeiboVariable;

	public class TimingWeiboManager
	{
		private var timer:Timer = null;
		public var timingWeiboData:TimingWeiboData = null;
		
		public function TimingWeiboManager()
		{
		}
		private function init(time:int):void
		{
			timer = new Timer(time);
			timer.addEventListener(TimerEvent.TIMER, timingWeibo_sendHandler);
			timer.start();
		}
		public function set data(arr:Array):void
		{
			if(!timingWeiboData) timingWeiboData = new TimingWeiboData();
			var vec:Vector.<TimingWeiboVariable> = new Vector.<TimingWeiboVariable>();
			for each(var obj:Object in arr){
				var twv:TimingWeiboVariable = new TimingWeiboVariable();
				for(var key:String in obj){
					twv[key] = obj[key];
				}
				vec.push(twv);
			}
			timingWeiboData.data = vec;
		}
		private function timingWeibo_sendHandler(event:TimerEvent):void
		{
			// 发送定时微博 在微博发布成功后更新数据库中的状态
		}
	}
}