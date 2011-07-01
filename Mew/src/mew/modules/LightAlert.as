package mew.modules
{
	import com.greensock.TweenLite;
	import com.iabel.core.ALSprite;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	import widget.Widget;
	
	public class LightAlert extends ALSprite
	{
		protected var txt:TextField;
		public function LightAlert()
		{
			super();
			
			init();
		}
		
		protected function init():void
		{
			if(!txt) txt = new TextField();
			txt.selectable = false;
			txt.mouseEnabled = false;
			txt.mouseWheelEnabled = false;
			txt.autoSize = TextFieldAutoSize.LEFT;
			addChild(txt);
			txt.x = (background.width - txt.textWidth) / 2;
			txt.y = (background.height - txt.textHeight) / 2;
		}
		
		override protected function configUI():void
		{
			if(!background) background = new Sprite();
			background.graphics.lineStyle(1, 0x000000);
			background.graphics.beginFill(0x0f0ddd, 1.0);
			background.graphics.drawRoundRect(0, 0, 100, 40, 10, 10);
			background.graphics.endFill();
			if(!this.contains(background)){
				addChild(background);
				Widget.widgetGlowFilter(background);
				background.width = 100;
				background.height = 40;
			}
		}
		
		public function show(text:String):void
		{
			txt.text = text;
			txt.x = (background.width - txt.textWidth) / 2;
			txt.y = (background.height - txt.textHeight) / 2;
		}
	}
}