package mew.modules
{
	import com.iabel.core.UISprite;
	
	import fl.controls.Button;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mew.windows.ALNativeWindow;
	
	public class PageFlipper extends UISprite
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
		
		override protected function dealloc(event:Event):void
		{
			super.dealloc(event);
			view = null;
			prePageBtn.removeEventListener(MouseEvent.CLICK, prePageBtn_mouseClickHandler);
			nextPageBtn.removeEventListener(MouseEvent.CLICK, nextPageBtn_mouseClickHandler);
			indexPageBtn.removeEventListener(MouseEvent.CLICK, indexPageBtn_mouseClickHandler);
			prePageBtn = null;
			nextPageBtn = null;
			indexPageBtn = null;
		}
	}
}