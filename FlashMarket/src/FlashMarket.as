package
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	[SWF(width="1000", height="600")]
	public class FlashMarket extends Sprite
	{
		private var urlLoader:URLLoader = null;
		private var cellWidth:int = 0;
		private var cellHeight:int = 0;
		private var spriteList:Object = null;
		private var infoPanel:InfoPanel = null;
		public function FlashMarket()
		{
			Cache.bitmapDataList = {};
			spriteList = {};
			if(!urlLoader) urlLoader = new URLLoader();
			urlLoader.addEventListener(Event.COMPLETE, xmlDataFile_loadCompleteHandler);
			urlLoader.load(new URLRequest("data.xml"));
		}
		
		private function xmlDataFile_loadCompleteHandler(event:Event):void
		{
			urlLoader.removeEventListener(Event.COMPLETE, xmlDataFile_loadCompleteHandler);
			XML.ignoreWhitespace = true;
			var xml:XML = XML(event.target.data);
			urlLoader = null;
			cellWidth = xml.@width;
			cellHeight = xml.@height;
			var xmlList:XMLList = xml.children();
			for each(var item:XML in xmlList){
				var house:Item = new Item();
				house.keywords = item.keyword.split(",");
				house.pos = new Point(item.x, item.y);
				house.content = String(item.text);
				house.tid = item.tid;
				house.rotate = item.rotation;
				if(Cache.bitmapDataList["http://localhost/" + item.image]){
					house.background = Cache.bitmapDataList["http://localhost/" + item.image];
					setHouse(house);
				}else{
					if(!spriteList["http://localhost/" + item.image]) spriteList["http://localhost/" + item.image] = [];
					spriteList["http://localhost/" + item.image].push(house);
					var loader:Loader = new Loader();
					loader.contentLoaderInfo.addEventListener(Event.COMPLETE, bitmapLoaded);
					loader.load(new URLRequest("http://localhost/" + item.image));
				}
			}
		}
		private function bitmapLoaded(event:Event):void
		{
			var loaderInfo:LoaderInfo = event.target as LoaderInfo;
			loaderInfo.removeEventListener(Event.COMPLETE, bitmapLoaded);
			var bd:BitmapData = (loaderInfo.content as Bitmap).bitmapData;
			if(!Cache.bitmapDataList[loaderInfo.url]) Cache.bitmapDataList[loaderInfo.url] = bd;
			if(spriteList[loaderInfo.url]){
				for each(var house:Item in spriteList[loaderInfo.url]){
					house.background = Cache.bitmapDataList[loaderInfo.url];
					setHouse(house);
				}
				delete spriteList[loaderInfo.url];
			}
		}
		
		private function setHouse(item:Item):void
		{
			item.init();
			item.index = this.numChildren;
			addChild(item);
			item.x = (cellWidth + 10) * item.pos.x;
			item.y = (cellHeight + 10) * item.pos.y;
			item.addEventListener(MouseEvent.ROLL_OVER, swapCurrentHouse);
			item.addEventListener(MouseEvent.ROLL_OUT, reswapCurrentHouse);
		}
		
		private function swapCurrentHouse(event:MouseEvent):void
		{
			var item:Item = event.currentTarget as Item;
			this.setChildIndex(item, this.numChildren - 1);
			initInfoPanel();
			item.showInfoPanel(infoPanel);
		}
		
		private function reswapCurrentHouse(event:MouseEvent):void
		{
			var item:Item = event.currentTarget as Item;
			this.setChildIndex(item, item.index);
			item.removeInfoPanel(infoPanel);
			infoPanel = null;
		}
		
		private function initInfoPanel():void
		{
			if(!infoPanel) infoPanel = new InfoPanel();
			infoPanel.initInfoPanel("<a href=\"http://www.qq.com\">qq.comqq.comqq.comqq.comqq.comqq.comqq.comqq.comqq.comqq.comqq.comqq.com</a>", [{url:"http://www.163.com", path:"http://localhost/images/img0.jpg"},
				{url:"http://www.sina.com.cn", path:"http://localhost/images/img0.jpg"}, {url:"http://www.sohu.com", path:"http://localhost/images/img0.jpg"}, {url:"http://www.sohu.com", path:"http://localhost/images/img0.jpg"}]);
		}
	}
}