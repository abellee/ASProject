package mew.modules
{
	import com.iabel.core.UISprite;
	
	import flash.display.Bitmap;
	
	import mew.data.WeiboData;
	
	public class TimingPoint extends UISprite
	{
		private var pointSkin:Bitmap = null;
		public var data:WeiboData = null;
		public function TimingPoint()
		{
			super();
		}
		
		public function initPoint():void
		{
			var now:Date = new Date();
			var time:Number = now.time;
			var dataTime:Number = data.time;
			if(!data.success) pointSkin = new Bitmap();
		}
	}
}