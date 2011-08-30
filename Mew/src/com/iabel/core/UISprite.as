package com.iabel.core
{
	import com.iabel.system.CoreSystem;
	import com.iabel.util.ScaleBitmap;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mew.modules.ToolTip;
	
	import org.bytearray.gif.player.GIFPlayer;
	
	import system.MewSystem;
	
	public class UISprite extends Sprite
	{
		protected var _listenerList:Object = null;
		protected var _tooltip:String = "";
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
			var o:DisplayObject = super.removeChild(child);
			CoreSystem.objectDestroied();
			return o;
		}
		
		override public function removeChildAt(index:int):DisplayObject
		{
			var o:DisplayObject = super.removeChildAt(index);
			CoreSystem.objectDestroied();
			return o;
		}
		
		override public function addChild(child:DisplayObject):DisplayObject
		{
			var o:DisplayObject = super.addChild(child);
			CoreSystem.objectDestroied();
			return o;
		}
		
		override public function addChildAt(child:DisplayObject, index:int):DisplayObject
		{
			var o:DisplayObject = super.addChildAt(child, index);
			CoreSystem.objectDestroied();
			return o;
		}
		
		override public function addEventListener(type:String, listener:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=false):void
		{
			if(!_listenerList) _listenerList = {};
			if(_listenerList[type] && _listenerList[type] == listener) return;
			_listenerList[type] = listener;
			
			super.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}
		override public function removeEventListener(type:String, listener:Function, useCapture:Boolean=false):void
		{
			if(_listenerList && _listenerList[type] && _listenerList[type] == listener) delete _listenerList[type];
			
			super.removeEventListener(type, listener, useCapture);
		}
		
		/**
		 * 如果子显示物件不属于本人编写的UIComponent
		 * 需要在调用此方法前取消所有子显示物件的所有事件监听以及相关的会影响垃圾回收的引用等
		 */
		public function removeAllChildren():void
		{
			while(this.numChildren)
			{
				var child:DisplayObject = this.getChildAt(0);
				if(child){
					
					if(child is ScaleBitmap){
						(child as ScaleBitmap).dealloc();
					}else if(child is Bitmap){
						var bt:Bitmap = child as Bitmap;
						if(bt && bt.bitmapData){
							bt.bitmapData.dispose();
							bt.bitmapData = null;
						}
					}else if(child is GIFPlayer){
						(child as GIFPlayer).dispose();
					}
					child = null;
				}
				this.removeChildAt(0);
			}
		}
		
		public function set toolTip(str:String):void
		{
			_tooltip = str;
			if(!str || str == ""){
				this.removeEventListener(MouseEvent.ROLL_OVER, rollOverHandler);
				this.removeEventListener(MouseEvent.ROLL_OUT, rollOutHandler);
				return;
			}
			if(!this.hasEventListener(MouseEvent.ROLL_OVER)){
				this.addEventListener(MouseEvent.ROLL_OVER, rollOverHandler);
				this.addEventListener(MouseEvent.ROLL_OUT, rollOutHandler);
			}
		}
		
		protected function rollOverHandler(event:MouseEvent):void
		{
			if(!MewSystem.toolTip) MewSystem.toolTip = new ToolTip();
			MewSystem.toolTip.text = _tooltip;
			MewSystem.toolTip.show();
			this.stage.addChild(MewSystem.toolTip);
			MewSystem.toolTip.x = this.stage.mouseX + 10;
			if(MewSystem.toolTip.x + MewSystem.toolTip.width + 5 >= this.stage.stageWidth) MewSystem.toolTip.x = this.stage.mouseX - MewSystem.toolTip.width - 10;
			MewSystem.toolTip.y = this.stage.mouseY + 10;
			if(MewSystem.toolTip.y + MewSystem.toolTip.height + 5 >= this.stage.stageHeight) MewSystem.toolTip.y = this.stage.mouseY - MewSystem.toolTip.height - 10;
		}
		
		protected function rollOutHandler(event:MouseEvent):void
		{
			if(this.stage.contains(MewSystem.toolTip)) this.stage.removeChild(MewSystem.toolTip);
			MewSystem.toolTip = null;
		}
		
		public function get toolTip():String
		{
			return _tooltip;
		}
		
		public function listData(arr:Array, w:Number, xml:XML):void
		{
			return;
		}
		
		protected function dealloc(event:Event):void
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, dealloc);
			removeAllChildren();
			for (var key:String in _listenerList) this.removeEventListener(key, _listenerList[key]);
			if(_listenerList )_listenerList = null;
			stage.removeEventListener(Event.RENDER, callLaterDispatcher);
			_tooltip = null;
		}
	}
}