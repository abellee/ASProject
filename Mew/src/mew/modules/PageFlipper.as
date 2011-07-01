package mew.modules
{
	import com.iabel.core.ALSprite;
	
	import fl.controls.Button;
	
	import flash.events.MouseEvent;
	
	import mew.windows.ALNativeWindow;
	
	public class PageFlipper extends ALSprite
	{
		public var curPageNum:int = 0;
		public var view:ALNativeWindow = null;
		private var prePageBtn:Button = null;
		private var nextPageBtn:Button = null;
		private var indexPageBtn:Button = null;
		public function PageFlipper()
		{
			super();
			
			init();
		}
		private function init():void
		{
			
			addListener();
		}
		private function addListener():void
		{
			prePageBtn.addEventListener(MouseEvent.CLICK, prePageBtn_mouseClickHandler);
			nextPageBtn.addEventListener(MouseEvent.CLICK, nextPageBtn_mouseClickHandler);
			indexPageBtn.addEventListener(MouseEvent.CLICK, indexPageBtn_mouseClickHandler);
		}
		private function prePageBtn_mouseClickHandler(event:MouseEvent):void
		{
			
		}
		private function nextPageBtn_mouseClickHandler(event:MouseEvent):void
		{
			
		}
		private function indexPageBtn_mouseClickHandler(event:MouseEvent):void
		{
			
		}
	}
}