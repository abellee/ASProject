package mew.modules {
	import mew.data.SuggestData;

	import com.iabel.core.UISprite;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;

	/**
	 * @author abellee
	 */
	public class Suggesttor extends UISprite {
		private var list:UISprite = null;
		private var curIndex:int = 0;
		private var listVector:Vector.<SuggestItem> = null;
		private var bk:Sprite = null;
		public function Suggesttor() {
			super();
			
			init();
		}
		private function init():void
		{
			if(!list) list = new UISprite();
			addChild(list);
			
			listVector = new Vector.<SuggestItem>();
		}
		public function locate(point:Point, h:int):void
		{
			drawBK(150, h + 5);
			this.x = point.x - 65;
			this.y = point.y + 15;
		}
		public function showSuggest(data:Vector.<SuggestData>):void
		{
			list.removeAllChildren();
			listVector.length = 0;
			curIndex = 0;
			if(data && data.length){
				for each (var i : SuggestData in data) {
					var suggestItem:SuggestItem = new SuggestItem(i.nickname);
					suggestItem.y = list.numChildren * 30 + 5;
					suggestItem.x = 5;
					list.addChild(suggestItem);
					listVector.push(suggestItem);
				}
			}
			listVector[curIndex].showBackground();
		}
		
		public function get selectedName():String
		{
			return listVector[curIndex].label;
		}
		
		public function previous():void
		{
			listVector[curIndex].hideBackground();
			curIndex--;
			if(curIndex < 0) curIndex = listVector.length - 1;
			listVector[curIndex].showBackground();
		}
		
		public function next():void
		{
			listVector[curIndex].hideBackground();
			curIndex++;
			if(curIndex >= listVector.length) curIndex = 0;
			listVector[curIndex].showBackground();
		}
		
		private function drawBK(w:int, h:int):void
		{
			if(!bk) bk = new Sprite();
			bk.graphics.clear();
			bk.graphics.beginFill(0xFFFFFF, 1.0);
			bk.graphics.drawRect(0, 0, w, h);
			bk.graphics.endFill();
			bk.mouseEnabled = false;
			bk.mouseChildren = false;
			addChildAt(bk, 0);
		}
		
		override protected function dealloc(event:Event):void
		{
			super.dealloc(event);
			
			list = null;
			listVector = null;
			bk = null;
		}
	}
}
