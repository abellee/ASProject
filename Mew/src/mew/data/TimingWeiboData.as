package mew.data
{
	public class TimingWeiboData
	{
		public var timingWeiboList:Vector.<TimingWeiboVariable> = null;
		public function TimingWeiboData()
		{
		}
		public function set data(d:Vector.<TimingWeiboVariable>):void
		{
			timingWeiboList = d;
		}
	}
}