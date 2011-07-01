package mew.modules
{
	import com.greensock.TweenLite;
	import com.iabel.core.UISprite;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.URLRequest;
	
	import mew.data.UserData;
	import mew.factory.StaticAssets;
	
	import system.MewSystem;
	
	public class Avatar extends UISprite
	{
		private var loader:Loader;
		private var bk:DisplayObject;
		public var userData:UserData;
		public function Avatar()
		{
			super();
			
			init();
		}
		private function init():void
		{
			bk = StaticAssets.getDefaultAvatar();
			addChildAt(bk, 0);
			setSize(bk.width, bk.height);
			
			drawBorder();
		}
		
		public function loadAvatar(size:int = 50):void
		{
			var src:String = userData.src;
			if(size == 180) src = src.replace(/\/50\//, "/180/");
			var cache:BitmapData = MewSystem.app.assetsCache.getAvatarCache(userData.id);
			if(cache){
				var bitmap:Bitmap = new Bitmap(cache);
				addAvatar(bitmap);
				return;
			}
			if(!loader) loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loadAvatar_completeHandler);
			loader.load(new URLRequest(src));
		}
		private function addAvatar(bitmap:Bitmap):void
		{
			addChild(bitmap);
			bitmap.alpha = 0;
			bitmap.x = (this.width - bitmap.width) / 2;
			bitmap.y = (this.height - bitmap.height) / 2;
			TweenLite.to(bitmap, .5, {alpha: 1});
			if(bk){
				removeChild(bk);
				bk = null;
			}
		}
		private function loadAvatar_completeHandler(event:Event):void
		{
			loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, loadAvatar_completeHandler);
			var bitmap:Bitmap
			var cache:BitmapData = MewSystem.app.assetsCache.getAvatarCache(userData.id);
			if(cache){
				bitmap = new Bitmap(cache);
			}else{
				bitmap = event.target.content as Bitmap;
				MewSystem.app.assetsCache.setAvatarCache(userData.id, bitmap.bitmapData);
			}
			loader.unloadAndStop();
			loader = null;
			addAvatar(bitmap);
		}
		
		private function drawBorder():void
		{
			this.graphics.clear();
			this.graphics.lineStyle(1, 0x000000);
			this.graphics.beginFill(0x000000, 0);
			this.graphics.drawRect(0, 0, this.width-1, this.height-1);
			this.graphics.endFill();
		}
	}
}