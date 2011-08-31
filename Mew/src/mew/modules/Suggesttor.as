package mew.modules {
	import flash.ui.Keyboard;
	import flash.events.KeyboardEvent;
	import mew.data.SuggestData;
	import mew.windows.ALNativeWindow;

	import flash.display.NativeWindowInitOptions;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;

	/**
	 * @author abellee
	 */
	public class Suggesttor extends ALNativeWindow {
		private var list:Sprite = null;
		private var curIndex:int = 0;
		private var listVector:Vector.<SuggestItem> = null;
		public function Suggesttor(info:NativeWindowInitOptions) {
			super(info);
		}
		override protected function init():void
		{
			list = new Sprite();
			addChild(list);
			
			listVector = new Vector.<SuggestItem>();
			
			addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
		}

		private function keyDownHandler(event : KeyboardEvent) : void
		{
			trace(event.keyCode == Keyboard.KEYNAME_DOWNARROW);
		}
		public function locate(point:Point, h:int):void
		{
			drawBackground(100, h);
			background.alpha = 0;
			this.stage.nativeWindow.alwaysInFront = true;
			super.init();
			this.stage.nativeWindow.x = point.x;
			this.stage.nativeWindow.y = point.y;
		}
		public function showSuggest(data:Vector.<SuggestData>):void
		{
			if(data && data.length){
				for each (var i : SuggestData in data) {
					var suggestItem:SuggestItem = new SuggestItem(i.nickname);
					suggestItem.y = list.numChildren * suggestItem.height;
					list.addChild(suggestItem);
					listVector.push(suggestItem);
				}
			}
			listVector[0].showBackground();
		}
		
		override protected function dealloc(event:Event):void
		{
			super.dealloc(event);
		}
	}
}
