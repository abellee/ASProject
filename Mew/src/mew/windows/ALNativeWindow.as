package mew.windows {
	import com.greensock.TweenLite;
	import flash.events.TimerEvent;
	import config.SQLConfig;

	import mew.data.SystemSettingData;
	import mew.data.UserData;
	import mew.modules.FloatUserInfo;

	import system.MewSystem;

	import widget.Widget;

	import com.iabel.core.UISprite;
	import com.iabel.system.CoreSystem;
	import com.iabel.util.ScaleBitmap;

	import org.bytearray.gif.player.GIFPlayer;

	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.NativeWindow;
	import flash.display.NativeWindowInitOptions;
	import flash.display.Screen;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.utils.Timer;
	
	public class ALNativeWindow extends NativeWindow
	{
		protected var _listenerList:Object = null;
		protected var background:UISprite = null;
		protected var cover:Sprite = null;
		protected var showTimer:Timer = null;
		protected var curPoint:Point = null;
		protected var curUD:UserData = null;
		protected var ownWindow:Vector.<ALNativeWindow> = null;
		public var container:UISprite = null;
		protected var newLocation:Point = null;
		public function ALNativeWindow(initOptions:NativeWindowInitOptions)
		{
			super(initOptions);
			
			container = new UISprite();
			this.stage.addChild(container);
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
			
			if(newLocation){
				this.stage.nativeWindow.x = newLocation.x;
				this.stage.nativeWindow.y = newLocation.y;
				return;
			}
			var xpos:int = 0;
			if(MewSystem.app.currentState != MewSystem.app.NONE){
			
				xpos = MewSystem.app.currentButton.x + MewSystem.app.currentButton.width / 2 - this.stage.nativeWindow.width / 2;
				
			}
//			var startPos:int = Screen.mainScreen.visibleBounds.height + this.stage.nativeWindow.height;
			var ypos:int = Screen.mainScreen.visibleBounds.y + MewSystem.app.height;
			if(xpos < Screen.mainScreen.visibleBounds.x) xpos = Screen.mainScreen.visibleBounds.x;
			else if(xpos + this.stage.nativeWindow.width > Screen.mainScreen.visibleBounds.width) xpos = Screen.mainScreen.visibleBounds.width - this.stage.nativeWindow.width;
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
			addChildAt(background, 0);
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
				case MewSystem.app.COMMENT:
					MewSystem.app.localWriter.readData(SQLConfig.MEW_COMMENT);
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
		public function iseeu(win:ALNativeWindow):void
		{
			if(!ownWindow) ownWindow = new Vector.<ALNativeWindow>();
			ownWindow.push(win);
		}
		public function goodbye(win:ALNativeWindow):void
		{
			if(ownWindow){
				var index:int = ownWindow.indexOf(win);
				if(index != -1){
					ownWindow.splice(index, 1);	
				}
			}
		}
		public function showWeibo(arr:Array, content:UISprite, ud:UserData = null):void
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
		
		public function showUserFloat(p:Point, ud:UserData):void
		{
			return;
			curPoint = p;
			curUD = ud;
			if(showTimer){
				showTimer.stop();
				showTimer.removeEventListener(TimerEvent.TIMER, showFloatFrame);
				showTimer = null;
			}
			showTimer = new Timer(1000);
			showTimer.addEventListener(TimerEvent.TIMER, showFloatFrame);
			showTimer.start();
		}
		
		protected function showFloatFrame(event:TimerEvent):void
		{
			if(showTimer){
				showTimer.stop();
				showTimer.removeEventListener(TimerEvent.TIMER, showFloatFrame);
				showTimer = null;
			}
			if(MewSystem.app.userFloat){
				if(container.contains(MewSystem.app.userFloat)) container.removeChild(MewSystem.app.userFloat);
				MewSystem.app.userFloat = null;
			}
			MewSystem.app.userFloat = new FloatUserInfo();
			MewSystem.app.userFloat.initData(curUD);
			addChild(MewSystem.app.userFloat);
			MewSystem.app.userFloat.x = curPoint.x + 54;
			MewSystem.app.userFloat.y = curPoint.y;
		}
		
		public function removeUserFloat():void
		{
			return;
			curPoint = null;
			curUD = null;
			if(MewSystem.app.userFloat && container.contains(MewSystem.app.userFloat)){
				container.removeChild(MewSystem.app.userFloat);
				MewSystem.app.userFloat = null;
			}
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
			container.addChild(displayObject);
			CoreSystem.objectDestroied();
			return displayObject;
		}
		
		public function addChildAt(displayObject:DisplayObject, index:uint):DisplayObject
		{
			container.addChildAt(displayObject, index);
			CoreSystem.objectDestroied();
			return displayObject;
		}
		
		public function removeChild(displayObject:DisplayObject):DisplayObject
		{
			container.removeChild(displayObject);
			CoreSystem.objectDestroied();
			return displayObject;
		}
		
		public function removeChildAt(index:uint):void
		{
			container.removeChildAt(index);
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
		
		public function relocate(p:Point):void
		{
			newLocation = p;
			this.stage.nativeWindow.x = p.x;
			this.stage.nativeWindow.y = p.y;
		}
		
		public function removeAllChildren():void
		{
			while(container.numChildren)
			{
				var child:DisplayObject = container.getChildAt(0);
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
				container.removeChildAt(0);
			}
		}
		
		public function reloadTheme():void
		{
			return;
		}
		
		protected function dealloc(event:Event):void
		{
			removeAllChildren();
			container.removeAllChildren();
			for (var key:String in _listenerList) this.removeEventListener(key, _listenerList[key]);
			if(_listenerList ) _listenerList = null;
			if(background){
				background.filters = null;
				background = null;
			}
			cover = null;
			if(showTimer){
				showTimer.stop();
				showTimer.removeEventListener(TimerEvent.TIMER, showFloatFrame);
				showTimer = null;
			}
			curPoint = null;
			curUD = null;
			if(ownWindow){
				while(ownWindow.length){
					var win:ALNativeWindow = ownWindow.pop();
					win.close();
				}
				ownWindow = null;
				MewSystem.app.widgetWindow = null;
			}
			container = null;
			newLocation = null;
		}
	}
}