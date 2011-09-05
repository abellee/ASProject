package mew.modules {
	import resource.Resource;

	import system.MewSystem;

	import com.iabel.core.UISprite;
	import com.iabel.utils.ScaleBitmap;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;

	/**
	 * @author Abel Lee
	 */
	public class UserAvatar extends UISprite {
		private var frame:Bitmap = null;
		private var loader:Loader = null;
		private var avatar:Bitmap = null;
		public function UserAvatar() {
			super();
			
			this.mouseChildren = false;
			init();
		}
		private function init():void
		{
			var bd:BitmapData = (new (Resource.ImageBackgroundSkin)() as Bitmap).bitmapData;
			frame = new ScaleBitmap(bd, "auto", true);
			frame.scale9Grid = new Rectangle(5, 5, 10, 10);
			frame.width = 66;
			frame.height = 66;
			addChild(frame);
			loadAvatar();
		}
		private function loadAvatar():void
		{
			var bd:BitmapData = null;
			if(!bd){
				loader = new Loader();
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loadAvatarComplete);
				loader.load(new URLRequest("http://tp1.sinaimg.cn/1579288532/50/5603442187/1"));
			}else{
				avatar = new Bitmap(bd);
				addChild(avatar);
				avatar.x = (frame.width - avatar.width) / 2;
				avatar.y = (frame.height - avatar.height) / 2;
			}
		}

		private function loadAvatarComplete(event : Event) : void
		{
			loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, loadAvatarComplete);
			var bd:BitmapData = null;
			if(!bd){
				avatar = event.target.content as Bitmap;
//				MewSystem.app.assetsCache.setAvatarCache(MewSystem.app.userData.id, avatar.bitmapData);
			}else{
				avatar = new Bitmap(bd);
			}
			loader = null;
			addChild(avatar);
			avatar.x = (frame.width - avatar.width) / 2;
			avatar.y = (frame.height - avatar.height) / 2;
		}
		
		override protected function dealloc(event:Event):void
		{
			super.dealloc(event);
			if(loader){
				try{
					loader.close();
				}catch(e:Error){}
				loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, loadAvatarComplete);
				loader = null;
			}
			if(frame){
				frame.bitmapData.dispose();
				frame = null;
			}
		}
	}
}
