package com.iabel.ui
{
	import fl.controls.CheckBox;
	import fl.controls.DataGrid;
	import fl.controls.listClasses.CellRenderer;
	import fl.controls.listClasses.ICellRenderer;
	import fl.controls.listClasses.ListData;
	import fl.core.InvalidationType;
	
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import resource.UIResource;
	
	
	public class CheckRenderer extends CheckBox implements ICellRenderer
	{
		private var _data:Object;
		private var _listData:ListData;
		public function CheckRenderer()
		{
			super();
			init();
			addEventListener(MouseEvent.CLICK, checkBox_clickHandler);
		}
		private function checkBox_clickHandler(event:MouseEvent):void{
			
			_data.selected = !_data.selected;
			
		}
		private function init():void{
			
			this.label = "";
			
		}
		public function set data(value:Object):void{
			
			_data = value;
			
		}
		public function get data():Object{
			
			return _data;
			
		}
		public function set listData(value:ListData):void{
			
			_listData = value;
			invalidate(InvalidationType.DATA);
			invalidate(InvalidationType.STATE);
			
		}
		public function get listData():ListData{
			
			return _listData;
			
		}
		override public function get selected():Boolean{
			
			return _data.selected;
			
		}
		override public function set selected(bool:Boolean):void{
			
			_selected = _data.selected;
			invalidate(InvalidationType.STATE);
			
		}
	}
}