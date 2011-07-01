package mew.windows
{
	import com.greensock.TweenLite;
	import com.iabel.core.ALSprite;
	import com.iabel.core.UISprite;
	import com.iabel.util.ScaleBitmap;
	
	import config.SQLConfig;
	
	import flash.data.SQLResult;
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.NativeWindow;
	import flash.display.NativeWindowInitOptions;
	import flash.display.Screen;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	
	import mew.communication.SQLiteManager;
	import mew.data.SystemSettingData;
	
	import system.MewSystem;
	
	import widget.Widget;
	
	public class ALNativeWindow extends NativeWindow
	{
		protected var _listenerList:Object = null;
		protected var background:Sprite = null;
		public function ALNativeWindow(initOptions:NativeWindowInitOptions)
		{
			super(initOptions);
			
			addEventListener(Event.CLOSE, dealloc);
			
			init();
		}
		
		protected function init():void
		{
			this.stage.align = StageAlign.TOP_LEFT;
			this.stage.scaleMode = StageScaleMode.NO_SCALE;
			this.stage.nativeWindow.alwaysInFront = SystemSettingData.alwaysInfront;
			
			drawBackground();
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
		
		protected function drawBackground():void
		{
			var h:int = Screen.mainScreen.visibleBounds.height - MewSystem.app.height - 100;
			if(!background) background = new Sprite();
			background.mouseChildren = false;
			background.graphics.beginFill(0xdddddd, 1.0);
			background.graphics.drawRoundRect(10, 10, 465, h, 10, 10);
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
		
		public function addChild(displayObject:DisplayObject):DisplayObject
		{
			this.stage.addChild(displayObject);
			return displayObject;
		}
		
		public function addChildAt(displayObject:DisplayObject, index:uint):DisplayObject
		{
			this.stage.addChildAt(displayObject, index);
			return displayObject;
		}
		
		public function removeChild(displayObject:DisplayObject):DisplayObject
		{
			this.stage.removeChild(displayObject);
			return displayObject;
		}
		
		public function removeChildAt(index:uint):void
		{
			this.stage.removeChildAt(index);
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
			trace("dealloc");
			removeAllChildren();
			for (var key:String in _listenerList){
				this.removeEventListener(key, _listenerList[key]);
			}
			if(_listenerList ) _listenerList = null;
			if(background){
				background.filters = null;
				background = null;
			}
		}
	}
}