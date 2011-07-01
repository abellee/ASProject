package com.iabel.component
{
	import com.iabel.core.ALSprite;
	
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.events.Event;
	
	public class VGroup extends ALSprite
	{
		public var gap:int = 10;
		public function VGroup()
		{
			super();
		}
		override protected function onAddedToStage(event:Event):void
		{
			super.onAddedToStage(event);
		}
		override protected function draw():void
		{
			super.draw();
			layout();
		}
		public function layout():void
		{
			if(this.numChildren){
				var len:int = this.numChildren;
				for(var i:int = 0; i<len; i++){
					var child:DisplayObject = this.getChildAt(i);
					child.width = this.width;
					if(i){
						var preChild:DisplayObject = this.getChildAt(i - 1);
						child.x = preChild.x;
						child.y = preChild.y + preChild.height + gap;
					}else{
						child.x = 0;
						child.y = 0;
					}
				}
			}
		}
	}
}