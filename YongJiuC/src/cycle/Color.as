package cycle
{
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.URLRequest;
	
	public class Color extends Sprite
	{
		private var _value:Number = 0;
		private var _order:uint = 0;
		private var _com:String = "";
		private var iconLoader:Loader = null;
		public function Color(comStr:String, orderValue:uint, colorValue:Number)
		{
			super();
			
			_value = colorValue;
			_order = orderValue;
			_com = comStr;
			loadIcon();
		}
		
		private function loadIcon():void
		{
			if(!iconLoader){
				
				iconLoader = new Loader();
				iconLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, iconLoad_completeHandler);
				
			}
			iconLoader.load(new URLRequest(Config.resPath + _com + "/" + Config.colorPath + _order + Config.iconFormat));
		}
		
		private function iconLoad_completeHandler(event:Event):void
		{
			iconLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, iconLoad_completeHandler);
			var bitmap:Bitmap = event.target.content as Bitmap;
			addChild(bitmap);
			iconLoader = null;
		}
		
		public function set value(num:Number):void
		{
			_value = num;
		}
		
		public function get value():Number
		{
			return _value;
		}
		
		public function set order(num:Number):void
		{
			_order = num;
		}
		
		public function get order():Number
		{
			return _order;
		}
	}
}