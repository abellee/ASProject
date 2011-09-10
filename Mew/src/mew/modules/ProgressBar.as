package mew.modules
{
	import com.greensock.TweenLite;
	import com.iabel.core.UISprite;
	import com.iabel.util.ScaleBitmap;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;
	
	import resource.Resource;
	
	import system.MewSystem;
	
	public class ProgressBar extends UISprite
	{
		private var bk:ScaleBitmap = null;
		private var masker:Sprite = null;
		public function ProgressBar()
		{
			super();
			
			init();
		}
		private function init():void
		{
			drawMasker();
			var bitmap:Bitmap = new (Resource.LoadingBackground)();
			bk = new ScaleBitmap(bitmap.bitmapData, "auto", true);
			bk.scale9Grid = new Rectangle(10, 0, 20, 15);
			bk.width = 182;
			bk.height = 15;
			addChild(bk);
			addChild(MewSystem.loadingMotion);
			addChild(masker);
			masker.scaleX = 0;
			MewSystem.loadingMotion.mask = masker;
		}
		
		public function showPercent(value:Number):void
		{
			TweenLite.to(masker, .5, {scaleX: value});
		}
		
		private function drawMasker():void
		{
			if(!masker) masker = new Sprite();
			masker.graphics.clear();
			masker.graphics.beginFill(0x000000, 1.0);
			masker.graphics.drawRect(0, 0, 182, 20);
			masker.graphics.endFill();
		}
		
		override protected function dealloc(event:Event):void
		{
			super.dealloc(event);
			bk = null;
			masker = null;
			MewSystem.loadingMotion.mask = null;
		}
	}
}