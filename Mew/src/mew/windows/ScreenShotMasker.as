package mew.windows {
	import com.iabel.util.GuideTipMask;
	
	import flash.display.NativeWindow;
	import flash.display.NativeWindowInitOptions;
	import flash.display.Screen;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.ui.Keyboard;
	
	import mew.modules.ScreenShotor;

	/**
	 * @author Abel Lee
	 */
	public class ScreenShotMasker extends NativeWindow {
		private var frame:Sprite = new Sprite();
		private var startX:int = 0;
		private var startY:int = 0;
		private var gtm:GuideTipMask = null;
		public var screenShotor:ScreenShotor = null;
		public function ScreenShotMasker(initOptions : NativeWindowInitOptions) {
			super(initOptions);
			
			this.stage.scaleMode = StageScaleMode.NO_SCALE;
			this.stage.align = StageAlign.TOP_LEFT;
			this.stage.nativeWindow.alwaysInFront = true;
			this.stage.addEventListener(KeyboardEvent.KEY_DOWN, window1_keyDownHandler);
			init();
		}
		private function init():void
		{
			this.stage.nativeWindow.width = Screen.mainScreen.bounds.width;
			this.stage.nativeWindow.height = Screen.mainScreen.bounds.height;
			this.stage.nativeWindow.x = Screen.mainScreen.bounds.x;
			this.stage.nativeWindow.y = Screen.mainScreen.bounds.y;
			gtm = new GuideTipMask(this.stage.nativeWindow.width, this.stage.nativeWindow.height);
			this.stage.addChild(gtm);
			this.stage.addEventListener(MouseEvent.MOUSE_DOWN, readyDrawRect);
			this.stage.addEventListener(MouseEvent.MOUSE_UP, stopDrawRect);
		}
		
		private function readyDrawRect(event:MouseEvent):void
		{
			startX = this.stage.mouseX;
			startY = this.stage.mouseY;
			this.stage.addEventListener(MouseEvent.MOUSE_MOVE, startDrawRect);
		}
		
		private function startDrawRect(event:MouseEvent):void
		{
			frame.graphics.clear();
			frame.graphics.lineStyle(2, 0xffffff);
			frame.graphics.drawRect(startX, startY, this.stage.mouseX - startX, this.stage.mouseY - startY); 
			frame.graphics.endFill();
			this.stage.addChild(frame);
			gtm.masker(new Rectangle(startX, startY, this.stage.mouseX - startX, this.stage.mouseY - startY));
		}
		
		private function stopDrawRect(event:MouseEvent):void{
				
			this.stage.removeEventListener(MouseEvent.MOUSE_MOVE, startDrawRect);
			if(screenShotor) screenShotor.shotForWindow(new Rectangle(startX, startY, this.stage.mouseX - startX, this.stage.mouseY - startY));
		}
		
		override public function close():void
		{
			screenShotor = null;
			this.stage.removeEventListener(KeyboardEvent.KEY_DOWN, window1_keyDownHandler);
			this.stage.removeEventListener(MouseEvent.MOUSE_DOWN, readyDrawRect);
			this.stage.removeEventListener(MouseEvent.MOUSE_UP, stopDrawRect);
			this.stage.removeEventListener(MouseEvent.MOUSE_MOVE, startDrawRect);
			frame = null;
			gtm = null;
			super.close();
		}
		
		protected function window1_keyDownHandler(event:KeyboardEvent):void
		{
			if(event.keyCode == Keyboard.ESCAPE) screenShotor.shotForWindow(null);
		}
	}
}
