package mew.data
{
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.net.URLRequest;

	public class ImageData extends MediaData
	{
		public var midURL:String = null;
		public var originWidth:Number = NaN;
		public var originHeight:Number = NaN;
		private var loader:Loader = null;
		public function ImageData()
		{
		}
		override public function set originURL(value:String):void
		{
			super.originURL = value;
			initSize();
		}
		private function initSize():void
		{
			loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.INIT, imageInitHandler);
			loader.load(new URLRequest(originURL));
		}
		private function imageInitHandler(event:Event):void
		{
			loader.contentLoaderInfo.removeEventListener(Event.INIT, imageInitHandler);
			originWidth = (event.target as LoaderInfo).width;
			originHeight = (event.target as LoaderInfo).height;
			loader = null;
		}
	}
}