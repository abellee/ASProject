package mew.data
{
	import flash.events.EventDispatcher;

	public class MediaData extends EventDispatcher
	{
		protected var _originURL:String = null;
		public var thumbURL:String = null;
		public var title:String = null;
		public function MediaData()
		{
		}
		public function get originURL():String
		{
			return _originURL;
		}

		public function set originURL(value:String):void
		{
			_originURL = value;
		}
		
		public function dealloc():void
		{
			_originURL = null;
			thumbURL = null;
			title = null;
		}
	}
}