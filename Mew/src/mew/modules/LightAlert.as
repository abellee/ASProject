package mew.modules
{
	import com.greensock.TweenLite;
	import com.iabel.core.UISprite;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	import system.MewSystem;
	
	import widget.Widget;
	
	public class LightAlert extends UISprite
	{
		protected var txt:TextField = null;
		protected var background:Sprite = null;
		public function LightAlert()
		{
			super();
			
			configUI();
			init();
		}
		
		protected function init():void
		{
			if(!txt) txt = new TextField();
			txt.defaultTextFormat = Widget.alertFormat;
			txt.wordWrap = true;
			txt.selectable = false;
			txt.mouseEnabled = false;
			txt.mouseWheelEnabled = false;
			txt.autoSize = TextFieldAutoSize.LEFT;
			addChild(txt);
			txt.width = background.width - 20;
			txt.x = (background.width - txt.width) / 2;
			txt.y = (background.height - txt.textHeight) / 2;
		}
		
		protected function configUI():void
		{
			if(!background) background = new Sprite();
			background.graphics.lineStyle(5, Widget.mainColor);
			background.graphics.beginFill(0xFFFFFF, 1.0);
			background.graphics.drawRoundRect(0, 0, 200, 100, 12, 12);
			background.graphics.endFill();
			if(!this.contains(background)){
				addChild(background);
				Widget.widgetGlowFilter(background, 5, 5);
				background.width = 200;
				background.height = 100;
			}
		}
		
		public function center(container:DisplayObjectContainer):void
		{
			this.x = (container.width - this.width) / 2;
			this.y = (container.height - this.height) / 2;
		}
		
		public function show(text:String):void
		{
			txt.text = text;
			txt.y = (background.height - txt.textHeight) / 2;
			this.alpha = 0;
			TweenLite.to(this, .5, {alpha: 1, onComplete: removeAlert});
		}
		
		protected function removeAlert():void
		{
			TweenLite.to(this, .3, {alpha: 0, delay:.5, onComplete: function():void{
				if(this.parent) this.parent.removeChild(this);
				MewSystem.lightAlert = null;
			}});
		}
		
		override protected function dealloc(event:Event):void
		{
			super.dealloc(event);
			background = null;
			txt = null;
		}
	}
}