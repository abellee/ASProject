package mew.data
{
	public class TimingWeiboVariable
	{
		public var id:int = NaN;
		public var content:String = null;
		public var img:String = null;
		public var time:Number = 0;
		public var state:int = 0;                // 0 未发送 1 发送成功 2 发送失败 3 图片丢失 但已发送文字
		public var createTime:Number = NaN;
		public function TimingWeiboVariable()
		{
		}
		public function toString():void
		{
			trace("id: " + id + " -------- content: " + content + " -------- img: " + img + " ------ time: " + time + " -------- state: " + state + " --------- createTime: " + createTime);
		}
	}
}