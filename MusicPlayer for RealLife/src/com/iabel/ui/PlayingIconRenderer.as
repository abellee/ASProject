package com.iabel.ui
{
	import fl.controls.Button;
	import fl.controls.DataGrid;
	import fl.controls.listClasses.CellRenderer;
	import fl.controls.listClasses.ICellRenderer;
	import fl.controls.listClasses.ListData;
	import fl.core.UIComponent;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	
	import resource.UIResource;
	
	public class PlayingIconRenderer extends Button implements ICellRenderer
	{
		private var _data:Object;
		private var _listData:ListData;
		public function PlayingIconRenderer()
		{
			super();
			init();
		}
		private function init():void{
			
			this.label = "";
			this.visible = false;
			this.mouseEnabled = false;
			this.mouseChildren = false;
			this.setStyle("upSkin", new Sprite);
			this.setStyle("overSkin", new Sprite);
			this.setStyle("downSkin", new Sprite);
			this.setStyle("disabledSkin", new Sprite);
			this.setStyle("icon", UIResource.CurrentPlay);
			
		}
		public function set data(value:Object):void{
			
			_data = value;
			
		}
		public function set isPlaying(bool:Boolean):void{
			
			this.visible = bool;
			
		}
		public function get data():Object{
			
			return _data;
			
		}
		public function set listData(value:ListData):void{
			
			_listData = value;
			
		}
		public function get listData():ListData{
			
			return _listData;
			
		}
	}
}