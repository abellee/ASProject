package {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.external.ExternalInterface;
	import flash.filters.BitmapFilter;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	import flash.text.TextField;
	import flash.utils.Timer;
	
	[SWF(width="1000", height="600")]
	public class FlashMarket extends Sprite
	{
		private var urlLoader:URLLoader = null;
		private var imageLoader:Loader = null;
		private var cellWidth:int = 0;
		private var cellHeight:int = 0;
		private var bkImage:String = "";
		private var spriteList:Object = null;
		private var infoPanel:InfoPanel = null;
		private var baseURL:String = "";
		private var highlightedList:Array = null;
		private var urlLoaderFunc:Function = null;
		private var houseContainer:Sprite = new Sprite();
		public static var instance:FlashMarket = null;
		public function FlashMarket()
		{
			instance = this;
			Cache.bitmapDataList = {};
			spriteList = {};
			addChild(houseContainer);
			if(!urlLoader) urlLoader = new URLLoader();
			urlLoader.addEventListener(Event.COMPLETE, xmlDataFile_loadCompleteHandler);
			urlLoader.load(new URLRequest("data.xml?t="+ new Date().getTime()));
		}
		
		private function xmlDataFile_loadCompleteHandler(event:Event):void
		{
			urlLoader.removeEventListener(Event.COMPLETE, xmlDataFile_loadCompleteHandler);
			XML.ignoreWhitespace = true;
			var xml:XML = XML(event.target.data);
			urlLoader = null;
			cellWidth = xml.@width;
			cellHeight = xml.@height;
			bkImage = xml.@background;
			baseURL = xml.@baseURL;
			if(bkImage && bkImage != null){
				loadBackground();
			}
			var xmlList:XMLList = xml.children();
			for each(var item:XML in xmlList){
				var house:Item = new Item();
				house.keywords = item.keyword.split(",");
				house.pos = new Point(item.x, item.y);
				house.content = String(item.text);
				house.tid = item.tid;
				house.rotate = item.rotation;
				house.offsetX = item.offsetX;
				house.offsetY = item.offsetY;
				if(Cache.bitmapDataList[baseURL + item.image]){
					house.background = Cache.bitmapDataList[baseURL + item.image];
					setHouse(house);
				}else{
					if(!spriteList[baseURL + item.image]) spriteList[baseURL + item.image] = [];
					spriteList[baseURL + item.image].push(house);
					var loader:Loader = new Loader();
					loader.contentLoaderInfo.addEventListener(Event.COMPLETE, bitmapLoaded);
					var lc:LoaderContext = new LoaderContext();
					lc.checkPolicyFile = true;
					loader.load(new URLRequest(baseURL + item.image), lc);
				}
			}
			if(ExternalInterface.available) ExternalInterface.addCallback("searchHouse", searchHouseFromJs);
		}
		
		private function searchHouseFromJs(str:String):void
		{
			removeHighlightedFromItems();
			if(str && str != "" && houseContainer.numChildren){
				var len:int = houseContainer.numChildren;
				for(var i:int = 0; i<len; i++){
					var item:Item = houseContainer.getChildAt(i) as Item;
					if(item){
						if(item.hasKeyword(str)){
							highlightedItem(item);
							if(!highlightedList) highlightedList = [];
							highlightedList.push(item);
						}
					}
				}
			}
		}
		
		private function highlightedItem(item:Item):void
		{
//			item.filters = [getBitmapFilter()];
			item.showFilter(getBitmapFilter());
		}
		
		private function removeHighlightedFromItems():void
		{
			if(highlightedList && highlightedList.length){
				while(highlightedList.length){
					var item:Item = highlightedList[highlightedList.length - 1] as Item;
					if(item){
						item.removeFilter();
					}
					highlightedList.pop();
				}
			}
		}
		
		private function getBitmapFilter():BitmapFilter {
            var color:Number = 0x000000;
            var alpha:Number = 1;
            var blurX:Number = 3;
            var blurY:Number = 3;
            var strength:Number = 5;
            var inner:Boolean = false;
            var knockout:Boolean = false;
            var quality:Number = BitmapFilterQuality.HIGH;

            return new GlowFilter(color,
                                  alpha,
                                  blurX,
                                  blurY,
                                  strength,
                                  quality,
                                  inner,
                                  knockout);
        }
		
		private function loadBackground():void
		{
			imageLoader = new Loader();
			imageLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, background_loadCompleteHandler);
			imageLoader.load(new URLRequest(baseURL + bkImage));
		}
		
		private function background_loadCompleteHandler(event:Event):void
		{
			imageLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, background_loadCompleteHandler);
			var bitmap:Bitmap = event.target.content as Bitmap;
			addChildAt(bitmap, 0);
			imageLoader = null;
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
			houseContainer.addChild(item);
			item.x = cellWidth * item.pos.x + item.offsetX;
			item.y = cellHeight * item.pos.y + item.offsetY;
			item.addEventListener(MouseEvent.ROLL_OVER, swapCurrentHouse);
			item.addEventListener(MouseEvent.ROLL_OUT, reswapCurrentHouse);
		}
		
		private function swapCurrentHouse(event:MouseEvent):void
		{
			var item:Item = event.currentTarget as Item;
			if(!item.tid) return;
			houseContainer.setChildIndex(item, houseContainer.numChildren - 1);
//			initInfoPanel(null);
//			item.showInfoPanel(infoPanel);
			
			urlLoaderFunc = function(event:Event):void
			{
				urlLoader.removeEventListener(Event.COMPLETE, urlLoaderFunc);
				var xml:XML = XML(event.target.data);
				if(xml){
					initInfoPanel(xml);
					item.showInfoPanel(infoPanel);
				}
				urlLoader = null;
				urlLoaderFunc = null;
			};
			
			if(!urlLoader) urlLoader = new URLLoader();
			urlLoader.addEventListener(Event.COMPLETE, urlLoaderFunc);
			urlLoader.load(new URLRequest(baseURL + "api.php?op=booth&tid=" + item.tid + "&rad="+ new Date().getTime()));
		}
		
		private function reswapCurrentHouse(event:MouseEvent):void
		{
			if(urlLoader){
				urlLoader.removeEventListener(Event.COMPLETE, urlLoaderFunc);
				try{
					urlLoader.close();
				}catch(e:Error){}
				urlLoader = null;
				urlLoaderFunc = null;
			}
			var item:Item = event.currentTarget as Item;
			houseContainer.setChildIndex(item, item.index);
			if(!infoPanel) return;
			item.removeInfoPanel(infoPanel);
			infoPanel = null;
		}
		
		private function initInfoPanel(data:XML):void
		{
			if(!infoPanel) infoPanel = new InfoPanel();
//			var xml:XML = new XML("<root>" +
//			"<number>096</number>" +
//			"<name>秋水伊人服饰店</name>" +
//			"<detailPage>http://www.iabel.com</detailPage>" +
//			"<info>" +
//			"<detailPage>http://www.iabel.com</detailPage>" +
//			"<entry>" +
//			"<name>皮衣处理</name>" +
//			"<time>11-10-10</time>" +
//			"</entry>" +
//			"<entry>" +
//			"<name>皮衣处理2</name>" +
//			"<time>11-10-10</time>" +
//			"</entry>" +
//			"</info>" +
//			"<products>" +
//			"<detailPage>http://www.iabel.com</detailPage>" +
//			"<product>" +
//			"<image>" + baseURL + "images/img0.jpg</image>" +
//			"<url>http://www.iabel.com</url>" +
//			"</product>" +
//			"<product>" +
//			"<image>" + baseURL + "images/img0.jpg</image>" +
//			"<url>http://www.iabel.com</url>" +
//			"</product>" +
//			"<product>" +
//			"<image>" + baseURL + "images/img0.jpg</image>" +
//			"<url>http://www.iabel.com</url>" +
//			"</product>" +
//			"<product>" +
//			"<image>" + baseURL + "images/img0.jpg</image>" +
//			"<url>http://www.iabel.com</url>" +
//			"</product>" +
//			"</products>" +
//			"</root>");
			infoPanel.initInfoPanel(data);
		}
	}
}