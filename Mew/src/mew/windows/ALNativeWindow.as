package mew.windows
{
	import com.greensock.TweenLite;
	import com.iabel.core.UISprite;
	import com.iabel.system.CoreSystem;
	import com.iabel.util.ScaleBitmap;
	
	import config.SQLConfig;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.NativeWindow;
	import flash.display.NativeWindowInitOptions;
	import flash.display.Screen;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	
	import mew.data.SystemSettingData;
	
	import org.bytearray.gif.player.GIFPlayer;
	
	import system.MewSystem;
	
	import widget.Widget;
	
	public class ALNativeWindow extends NativeWindow
	{
		protected var _listenerList:Object = null;
		protected var background:UISprite = null;
		protected var cover:Sprite = null;
		public function ALNativeWindow(initOptions:NativeWindowInitOptions)
		{
			super(initOptions);
			
			addEventListener(Event.CLOSE, dealloc);
			
			this.stage.align = StageAlign.TOP_LEFT;
			this.stage.scaleMode = StageScaleMode.NO_SCALE;
			this.stage.nativeWindow.alwaysInFront = SystemSettingData.alwaysInfront;
			
			init();
		}
		
		protected function init():void
		{
			this.stage.nativeWindow.width = background.width + 20;
			this.stage.nativeWindow.height = background.height + 20;
			
			var xpos:int = 0;
			if(MewSystem.app.currentState != MewSystem.app.NONE){
			
				xpos = MewSystem.app.currentButton.x + MewSystem.app.currentButton.width / 2 - this.stage.nativeWindow.width / 2;
				
			}
			var startPos:int = Screen.mainScreen.visibleBounds.height + this.stage.nativeWindow.height;
			var ypos:int = Screen.mainScreen.visibleBounds.y + MewSystem.app.height;
			this.stage.nativeWindow.x = xpos;
			this.stage.nativeWindow.y = ypos;
//			TweenLite.to(this.stage.nativeWindow, .3, {y: ypos});
		}
		
		protected function drawBackground(w:int, h:int):void
		{
			if(!background) background = new UISprite();
			background.mouseChildren = false;
			background.graphics.clear();
			background.graphics.beginFill(0xdddddd, 1.0);
			background.graphics.drawRoundRect(10, 10, w, h, 10, 10);
			background.graphics.endFill();
			Widget.widgetGlowFilter(background);
			addChild(background);
		}
		
		public function readData():void
		{
			switch(MewSystem.app.currentState){
				case MewSystem.app.INDEX:
					MewSystem.app.localWriter.readData(SQLConfig.MEW_INDEX);
					break;
				case MewSystem.app.AT:
					MewSystem.app.localWriter.readData(SQLConfig.MEW_AT);
					break;
				case MewSystem.app.COMMENT_ME:
					MewSystem.app.localWriter.readData(SQLConfig.MEW_COMMENT_ME);
					break;
				case MewSystem.app.COLLECT:
					MewSystem.app.localWriter.readData(SQLConfig.MEW_COLLECT);
					break;
				case MewSystem.app.MY_WEIBO:
					MewSystem.app.localWriter.readData(SQLConfig.MEW_MY_WEIBO);
					break;
				case MewSystem.app.DIRECT_MESSAGE:
					MewSystem.app.localWriter.readData(SQLConfig.MEW_DIRECT);
					break;
				case MewSystem.app.FANS:
					MewSystem.app.localWriter.readData(SQLConfig.MEW_FANS);
					break;
				case MewSystem.app.FOLLOW:
					MewSystem.app.localWriter.readData(SQLConfig.MEW_FOLLOW);
					break;
			}
		}
		public function showWeibo(arr:Array, content:UISprite):void
		{
			return;
		}
		
		public function getContentWidth():Number
		{
			return 0;
		}
		
		public function showResult(value:int, mode:Boolean = false):void
		{
			
		}
		
		protected function drawCover():void
		{
			if(!cover) cover = new Sprite();
			cover.graphics.clear();
			cover.graphics.beginFill(0x000000, .2);
			cover.graphics.drawRect(10, 10, background.width, background.height);
			cover.graphics.endFill();
			cover.mouseChildren = false;
			addChild(cover);
		}
		
		public function addChild(displayObject:DisplayObject):DisplayObject
		{
			this.stage.addChild(displayObject);
			CoreSystem.objectDestroied();
			return displayObject;
		}
		
		public function addChildAt(displayObject:DisplayObject, index:uint):DisplayObject
		{
			this.stage.addChildAt(displayObject, index);
			CoreSystem.objectDestroied();
			return displayObject;
		}
		
		public function removeChild(displayObject:DisplayObject):DisplayObject
		{
			this.stage.removeChild(displayObject);
			CoreSystem.objectDestroied();
			return displayObject;
		}
		
		public function removeChildAt(index:uint):void
		{
			this.stage.removeChildAt(index);
			CoreSystem.objectDestroied();
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
		
		public function removeAllChildren():void
		{
			while(this.stage.numChildren)
			{
				var child:DisplayObject = this.stage.getChildAt(0);
				if(child){
					
					if(child is ScaleBitmap){
						(child as ScaleBitmap).dealloc();
					}else if(child is Bitmap){
						(child as Bitmap).bitmapData.dispose();
						(child as Bitmap).bitmapData = null;
					}else if(child is GIFPlayer){
						(child as GIFPlayer).dispose();
					}
					child = null;
				}
				this.stage.removeChildAt(0);
			}
		}
		
		public function reloadTheme():void
		{
			return;
		}
		
		protected function dealloc(event:Event):void
		{
			removeAllChildren();
			for (var key:String in _listenerList) this.removeEventListener(key, _listenerList[key]);
			if(_listenerList ) _listenerList = null;
			if(background){
				background.filters = null;
				background = null;
			}
			cover = null;
		}
	}
}