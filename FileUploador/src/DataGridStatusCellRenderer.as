package {
	import fl.core.UIComponent;
	import flash.text.TextFieldAutoSize;
	import fl.controls.Label;
	import fl.controls.listClasses.ICellRenderer;
	import fl.controls.listClasses.ListData;

	import flash.display.Sprite;

	/**
	 * @author Abel Lee
	 */
	public class DataGridStatusCellRenderer extends UIComponent implements ICellRenderer {
		private var _listData:ListData;
        private var _data:Object;
		
		private var overSkin:Sprite = null;
		private var upSkin:Sprite = null;
		private var colorNum:Number = 0xf7f7f7;
		
		private var label:Label = new Label();
        
        public function DataGridStatusCellRenderer() {
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
			addChild(label);
			label.text = newData.status;
			label.textField.autoSize = TextFieldAutoSize.LEFT;
			label.textField.x = 10;
			label.textField.y = (this.height - this.label.height) / 2;
        }
		
		public function showProgress(value:Number):void
		{
			label.text = value + "%";
		}

        public function get data():Object {
            return _data;
        }
	}
}
