package com.iabel.ui
{
	import flash.display.Sprite;
	
	public class RendererStyle extends Sprite
	{
		public function RendererStyle()
		{
			super();
			init();
		}
		private function init():void{
			
			this.graphics.beginFill(0x0099ff, .5);
			this.graphics.drawRect(0, 0, 100, 30);
			this.graphics.endFill();
			
		}
	}
}