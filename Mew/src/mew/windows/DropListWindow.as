package mew.windows {
	import system.MewSystem;
	import fl.events.ListEvent;
	import fl.controls.List;
	import fl.data.DataProvider;

	import mew.modules.ListRenderer;

	import widget.Widget;

	import flash.display.NativeWindowInitOptions;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextFormat;
	
	public class DropListWindow extends ALNativeWindow
	{
		private var list:List = null;
		public function DropListWindow(initOptions:NativeWindowInitOptions)
		{
			super(initOptions);
		}
		override protected function init():void
		{
			return;
		}
		
		public function showList(data:DataProvider, height:int):void
		{
			drawBackground(150, height, "top");
			this.stage.nativeWindow.alwaysInFront = true;
			super.init();
			
			if(!list) list = new List();
			list.rowHeight = 30;
			list.setStyle("cellRenderer", ListRenderer);
			list.setStyle("skin", new Sprite());
			list.dataProvider = data;
			list.addEventListener(ListEvent.ITEM_CLICK, onItemClick);
			list.setStyle("textFormat", new TextFormat(Widget.systemFont, 20, 0x4c4c4c, true));
			list.width = whiteBackground.width;
			list.height = whiteBackground.height;
			addChild(list);
			list.x = 20;
			list.y = 30;
		}

		private function onItemClick(event : ListEvent) : void {
			event.item["func"]();
			MewSystem.app.dropListWindow = null;
			MewSystem.app.currentActiveWindow = null;
			MewSystem.app.currentState = MewSystem.app.NONE;
			this.close();
		}
		
		override protected function drawBackground(w:int, h:int, position:String = null):void
		{
			super.drawBackground(w, h, position);
			addChildAt(whiteBackground, 2);
		}
		
		override protected function dealloc(event:Event):void
		{
			super.dealloc(event);
			if(list) list.removeEventListener(ListEvent.ITEM_CLICK, onItemClick);
		}
	}
}