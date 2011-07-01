package com.iabel.core
{
	import com.iabel.system.CoreSystem;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class UISprite extends Sprite
	{
		public function UISprite()
		{
			super();
			addEventListener(Event.ADDED_TO_STAGE, onAdded);
		}
		protected function onAdded(event:Event):void
		{
			this.dispatchEvent(new Event(Event.RESIZE));
			removeEventListener(Event.ADDED_TO_STAGE, onAdded);
			addEventListener(Event.REMOVED_FROM_STAGE, dealloc);
			stage.addEventListener(Event.RENDER, callLaterDispatcher);
		}
		protected function callLaterDispatcher(event:Event):void
		{
			redraw();
		}
		protected function redraw():void
		{
			return;
		}
		public function setSize(w:Number, h:Number, color:Number = 0):void
		{
			drawBackground(w, h, color);
		}
		protected function drawBackground(w:Number, h:Number, color:Number = 0):void
		{
			this.graphics.clear();
			this.graphics.beginFill(color, .1);
			this.graphics.drawRect(0, 0, w, h);
			this.graphics.endFill();
		}
		
		override public function removeChild(child:DisplayObject):DisplayObject
		{
			CoreSystem.objectDestroied();
			return super.removeChild(child);
		}
		
		override public function removeChildAt(index:int):DisplayObject
		{
			CoreSystem.objectDestroied();
			return super.removeChildAt(index);
		}
		
		public function listData(arr:Array, w:Number):void
		{
			return;
		}
		
		protected function dealloc(event:Event):void
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, dealloc);
		}
	}
}