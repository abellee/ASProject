package {
	import fl.controls.DataGrid;
	import flash.events.MouseEvent;
	import fl.controls.Button;
	import fl.controls.listClasses.ICellRenderer;
	import fl.controls.listClasses.ListData;
	import fl.core.UIComponent;

	import flash.display.Sprite;

	/**
	 * @author Abel Lee
	 */
	public class DataGridDeleteColumnCellRenderer extends UIComponent implements ICellRenderer {
		private var _listData:ListData;
        private var _data:Object;
		
		private var deleteButton:Button = null;
		private var overSkin:Sprite = null;
		private var upSkin:Sprite = null;
		private var colorNum:Number = 0xf7f7f7;
        
        public function DataGridDeleteColumnCellRenderer() {
			super();
        }
		
		override public function setSize(v0:Number, v1:Number):void
		{
			super.setSize(v0, v1);
		}
		
		public function set selected(bool:Boolean):void
		{
		}
		
		public function get selected():Boolean
		{
			return false;
		}
		
		public function setMouseState(str:String):void
		{
			switch(str){
				case "up":
					if(overSkin) overSkin.visible = false;
					if(!upSkin){
						upSkin = new Sprite();
						upSkin.graphics.clear();
						upSkin.graphics.lineStyle(.5, 0xadc0d4);
						upSkin.graphics.beginFill(colorNum);
						upSkin.graphics.drawRect(0, 0, this.width, this.height);
						upSkin.graphics.endFill();
					}
					addChildAt(upSkin, 0);
					upSkin.visible = true;
					break;
				case "over":
					if(upSkin) upSkin.visible = false;
					if(!overSkin){
						overSkin = new Sprite();
						overSkin.graphics.clear();
						overSkin.graphics.beginFill(0xa3ceff);
						overSkin.graphics.drawRect(0, 0, this.width, this.height);
						overSkin.graphics.endFill();
					}
					addChildAt(overSkin, 0);
					overSkin.visible = true;
					break;
				default:
					break;
			}
			deleteButton.x = (this.width - deleteButton.width) / 2;
			deleteButton.y = (this.height - deleteButton.height) / 2;
		}

        public function set listData(newListData:ListData):void {
            _listData = newListData;
			if(_listData.index % 2 != 0) colorNum = 0xffffff;
        }

        public function get listData():ListData {
            return _listData;
        }

        public function set data(newData:Object):void {
            _data = newData;
			if(!deleteButton){
				deleteButton = new Button();
				deleteButton.setStyle("upSkin", Resource.DELETE);
				deleteButton.setStyle("downSkin", Resource.DELETE);
				deleteButton.setStyle("overSkin", Resource.DELETE);
				deleteButton.setStyle("disabledSkin", Resource.DELETE);
				deleteButton.label = "";
				deleteButton.width = 10;
				deleteButton.height = 12;
				deleteButton.addEventListener(MouseEvent.CLICK, onMouseClick);
			}
			addChild(deleteButton);
			deleteButton.x = (this.width - deleteButton.width) / 2;
			deleteButton.y = (this.height - deleteButton.height) / 2;
			deleteButton.drawNow();
        }
		
		private function onMouseClick(event:MouseEvent):void
		{
			if(_listData.owner) (_listData.owner as DataGrid).removeItemAt(_listData.index);
		}

        public function get data():Object {
            return _data;
        }
	}
}
