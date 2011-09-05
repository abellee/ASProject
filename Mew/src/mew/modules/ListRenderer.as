package mew.modules {
	import fl.controls.listClasses.ICellRenderer;
	import fl.controls.listClasses.ListData;
	import fl.core.UIComponent;

	import widget.Widget;

	import com.greensock.TweenLite;

	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	/**
	 * @author Abel Lee
	 */
	public class ListRenderer extends UIComponent implements ICellRenderer {
		private var _selected:Boolean = false;
		private var _listData:ListData = null;
		private var _data:Object = null;
		private var background:Sprite = null;
		private var textField:TextField = null;
		private var upFormat:TextFormat = new TextFormat(Widget.systemFont, 14, 0x4c4c4c, true);
		private var outFormat:TextFormat = new TextFormat(Widget.systemFont, 14, 0xFFFFFF, true);
		public function ListRenderer() {
			super();
			
			textField = new TextField();
			textField.defaultTextFormat = upFormat;
			textField.autoSize = TextFieldAutoSize.LEFT;
			textField.selectable = false;
			textField.mouseEnabled = false;
		}

		override public function setSize(arg0 : Number, arg1 : Number) : void {
			super.setSize(arg0, arg1);
			if(arg0 > 0 && arg1 > 0){
				drawBackground();
				background.alpha = 0;
				addEventListener(MouseEvent.MOUSE_OVER, showBackground);
				addEventListener(MouseEvent.MOUSE_UP, showBackground);
				addEventListener(MouseEvent.MOUSE_OUT, removeBackground);
			}
		}
		
		private function showBackground(event : MouseEvent) : void {
			if(event.type == MouseEvent.MOUSE_UP || event.type == MouseEvent.MOUSE_DOWN){
				background.alpha = 1;
				return;
			}
			background.alpha = 0;
			addChildAt(background, 0);
			TweenLite.to(background, .5, {alpha: 1});
			textField.defaultTextFormat = outFormat;
			textField.text = textField.text;
		}

		private function removeBackground(event : MouseEvent) : void {
			background.alpha = 1;
			addChildAt(background, 0);
			TweenLite.to(background, .5, {alpha: 0});
			textField.defaultTextFormat = upFormat;
			textField.text = textField.text;
		}

		private function drawBackground() : void {
			if(background) return;
			if(!background) background = new Sprite();
			background.graphics.clear();
			background.graphics.beginFill(Widget.mainColor);
			background.graphics.drawRect(0, 0, this.width, this.height);
			background.graphics.endFill();
			background.mouseEnabled = false;
			background.mouseChildren = false;
			addChildAt(background, 0);
		}

		public function setMouseState(arg0 : String) : void {
			trace(arg0);
		}

		public function get listData() : ListData {
			return _listData;
		}

		public function get data() : Object {
			return _data;
		}

		public function get selected() : Boolean {
			return _selected;
		}

		public function set data(arg0 : Object) : void {
			_data = arg0;
			if(_data.label){
				textField.text = _data.label;
				textField.width = textField.textWidth;
				textField.height = textField.textHeight;
				textField.x = 10;
				textField.y = (height - textField.height) / 2;
				addChild(textField);
			}
		}

		public function set selected(arg0 : Boolean) : void {
			_selected = arg0;
		}

		public function set listData(arg0 : ListData) : void {
			_listData = arg0;
		}
	}
}
