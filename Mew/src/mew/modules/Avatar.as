package mew.modules {
	import mew.data.UserData;

	import resource.Resource;

	import system.MewSystem;

	import com.greensock.TweenLite;
	import com.iabel.core.UISprite;
	import com.iabel.util.ScaleBitmap;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.net.URLRequest;
	
	public class Avatar extends UISprite
	{
		private var loader:Loader;
		private var bk:DisplayObject;
		public var userData:UserData;
		public function Avatar(size:int = 50)
		{
			super();
			
			init(size);
		}
		private function init(s:int):void
		{
			if(s == 50) bk = new (Resource.MewDefault50)();
			else{
				bk = new (Resource.MewDefault180)();
				bk.width = 100;
				bk.height = 100;
			}
			addChildAt(bk, 0);
			setSize(bk.width, bk.height);
			
			drawBorder();
			
			bk.x = (this.width - bk.width) / 2;
			bk.y = (this.height - bk.height) / 2;
		}
		
		override public function removeAllChildren():void
		{
			while(this.numChildren)
			{
				var child:DisplayObject = this.getChildAt(0);
				if(child){
					
					if(child is ScaleBitmap){
						(child as ScaleBitmap).dealloc();
					}else if(child is Bitmap){
						if(MewSystem.app.currentState == MewSystem.app.FANS || MewSystem.app.currentState == MewSystem.app.FOLLOW){
							var cache:BitmapData = MewSystem.app.assetsCache.getAvatarCache(userData.id);
							if(!cache) (child as Bitmap).bitmapData.dispose();
						}
					}
					child = null;
				}
				this.removeChildAt(0);
			}
		}
		
		public function loadAvatar(size:int = 50):void
		{
			if(!userData) return;
			var src:String = userData.src;
			if(size == 180) src = src.replace(/\/50\//, "/180/");
			var cache:BitmapData = MewSystem.app.assetsCache.getAvatarCache(userData.id);
			if(cache && size == 50){
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
			var bitmap:Bitmap;
			var cache:BitmapData = MewSystem.app.assetsCache.getAvatarCache(userData.id);
			if(cache && (event.target.content as Bitmap).width == 50){
				bitmap = new Bitmap(cache);
			}else{
				bitmap = event.target.content as Bitmap;
				if(bitmap.width >= 180){
					bitmap.width = 100;
					bitmap.height = 100;
				}else{
					if(MewSystem.app.currentState != MewSystem.app.FANS && MewSystem.app.currentState != MewSystem.app.FOLLOW) MewSystem.app.assetsCache.setAvatarCache(userData.id, bitmap.bitmapData);
				}
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
			this.graphics.drawRect(0, 0, this.width + 4, this.height + 4);
			this.graphics.endFill();
		}
		
		override protected function dealloc(event:Event):void
		{
			super.dealloc(event);
			if(loader){
				try{
					loader.close();
				}catch(e:Error){}
				loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, loadAvatar_completeHandler);
			}
			loader = null;
			bk = null;
			userData = null;
		}
	}
}