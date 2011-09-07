package mew.modules {
	import mew.data.TimingWeiboVariable;

	import resource.Resource;

	import com.iabel.core.UISprite;

	import flash.display.Bitmap;
	import flash.events.Event;
	
	public class TimingPoint extends UISprite
	{
		private var bitmapBK:Bitmap = null;
		private var pointSkin:Bitmap = null;
		public var data:TimingWeiboVariable = null;
		public var index:int = 0;
		public function TimingPoint()
		{
			super();
		}
		
		public function initPoint():void
		{
			bitmapBK = new Resource.TimingPointBackground();
			switch(data.state){
				case 0:
					pointSkin = new Resource.TimingPointUnsend();
					break;
				case 1:
					pointSkin = new Resource.TimingPointSend();
					break;
				case 2:
					pointSkin = new Resource.TimingPointSendFailed();
					break;
			}
			addChild(bitmapBK);
			addChild(pointSkin);
			pointSkin.x = (bitmapBK.width - pointSkin.width) / 2;
			pointSkin.y = (bitmapBK.height - pointSkin.height) / 2;
		}
		override protected function dealloc(event:Event):void
		{
			super.dealloc(event);
			bitmapBK.bitmapData.dispose();
			pointSkin.bitmapData.dispose();
			data = null;
			bitmapBK = null;
			pointSkin = null;
		}
	}
}