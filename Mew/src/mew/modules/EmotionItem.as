package mew.modules {
	import com.iabel.core.UISprite;

	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.UncaughtErrorEvent;
	import flash.net.URLRequest;
	
	public class EmotionItem extends UISprite
	{
		private var loader:Loader = null;
		private var bk:Sprite = null;
		public var emotionText:String = "";
		private var errorTime:int = 0;
		private var path:String = "";
		public function EmotionItem()
		{
			super();
			
			drawBorder();
		}
		
		private function drawBorder():void
		{
			if(!bk) bk = new Sprite();
			bk.graphics.lineStyle(1, 0x000000, .2);
			bk.graphics.beginFill(0x000000, 0);
			bk.graphics.drawRect(0, 0, 26, 26);
			bk.graphics.endFill();
			addChild(bk);
			bk.mouseChildren = false;
			bk.mouseEnabled = false;
		}
		
		public function loadEmotion(src:String, emo:String):void
		{
			path = src;
			loader = new Loader();
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onIOErrorEvent);
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onComplete);
			loader.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, onUncaughtErrorEvent);
			try{
				loader.load(new URLRequest(src));
			}catch(e:IOErrorEvent){
				nullLoader();
			}
			emotionText = emo;
			this.toolTip = emo.substring(1, emo.length - 1);
		}
		
		private function onUncaughtErrorEvent(event:UncaughtErrorEvent):void
		{
			nullLoader();
		}
		
		private function onIOErrorEvent(event:IOErrorEvent):void
		{
			if(errorTime >= 2){
				nullLoader();
				errorTime = 0;
				return;
			}
			errorTime ++;
			try{
				loader.load(new URLRequest(path));
			}catch(e:IOErrorEvent){
				nullLoader();
			}
		}
		
		private function nullLoader():void
		{
			try{
				loader.close();
			}catch(e:Error){
			}
			loader.unloadAndStop();
			loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onIOErrorEvent);
			loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onComplete);
			loader.uncaughtErrorEvents.removeEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, onUncaughtErrorEvent);
			loader = null;
		}
		
		private function onComplete(event:Event):void
		{
			var bitmap:Bitmap = event.target.content;
			nullLoader();
			bitmap.width = 22;
			bitmap.height = 22;
			addChild(bitmap);
			bitmap.x = 3;
			bitmap.y = 3;
		}
		
		override protected function dealloc(event:Event):void
		{
			super.dealloc(event);
			
			if(loader) nullLoader();
			bk = null;
			emotionText = null;
			path = null;
		}
	}
}