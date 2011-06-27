package com.iabel.ui
{
	import fl.controls.Label;
	import fl.controls.listClasses.CellRenderer;
	import fl.controls.listClasses.ICellRenderer;
	import fl.controls.listClasses.ListData;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	public class DataGridCellRenderer extends CellRenderer
	{
		public function DataGridCellRenderer()
		{
			super();
			init();
			addEventListener(MouseEvent.DOUBLE_CLICK, cellDouble_clickHandler);
		}
		private function init():void{
			
			this.doubleClickEnabled = true;
			setStyle("upSkin", new Sprite);
			setStyle("downSkin", new RendererStyle);
			setStyle("overSkin", new RendererStyle);
			setStyle("disabledSkin", new Sprite);
			setStyle("selectedDisabledSkin", new Sprite);
			setStyle("selectedDownSkin", new RendererStyle);
			setStyle("selectedOverSkin", new RendererStyle);
			setStyle("selectedUpSkin", new RendererStyle);
			
		}
		private function cellDouble_clickHandler(event:MouseEvent):void{
			
			Main.instance.playMusic(data.url, this.data.id, this.data.name);
			Main.instance.setPlayingIcon(listData.column, listData.row);
			Main.instance.curIndex = listData.index;
			
		}
	}
}