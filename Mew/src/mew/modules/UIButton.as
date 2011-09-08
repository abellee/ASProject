package mew.modules {
	import fl.controls.Button;

	import widget.Widget;

	import com.iabel.core.UISprite;

	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;

	/**
	 * @author Abel Lee
	 */
	public class UIButton extends UISprite {
		private var btn:Button = null;
		private var label:TextField = null;
		public function UIButton(button:Button, str:String, gap:int, position:String = "bottom") {
			super();
			
			btn = button;
			label = new TextField();
			label.defaultTextFormat = Widget.mainPanelButtonFormat;
			label.autoSize = TextFieldAutoSize.LEFT;
			label.selectable = false;
			label.mouseEnabled = false;
			label.mouseWheelEnabled = false;
			label.width = label.textWidth;
			label.height = label.textHeight;
			label.text = str;
			
			if(position == "right"){
				label.y = button.height - label.height;
				label.x = button.width + gap;
			}else{
				label.y = button.height + 5;
				label.x = (button.width - label.textWidth) / 2 - gap;
			}
			
			addChild(btn);
			addChild(label);
		}
		
		public function set enabled(bool:Boolean):void
		{
			btn.enabled = bool;
		}
		
		public function set toggle(bool:Boolean):void
		{
			btn.toggle = bool;
		}
		
		public function get toggle():Boolean
		{
			return btn.toggle;
		}
		
		override protected function dealloc(event:Event):void
		{
			super.dealloc(event);
			btn = null;
			label = null;
		}
	}
}
