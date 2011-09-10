package mew.modules {
	import com.greensock.TweenLite;
	import resource.Resource;

	import system.MewSystem;

	import com.iabel.core.UISprite;
	import com.iabel.util.ScaleBitmap;

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
			
			avatar = new (Resource.MewDefault50)();
			addChild(avatar);
			avatar.x = (frame.width - avatar.width) / 2;
			avatar.y = (frame.height - avatar.height) / 2;
			loadAvatar();
		}
		private function loadAvatar():void
		{
			loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loadAvatarComplete);
			loader.load(new URLRequest(MewSystem.app.userData.src));
		}

		private function loadAvatarComplete(event : Event) : void
		{
			loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, loadAvatarComplete);
			if(avatar){
				avatar.bitmapData.dispose();
				avatar = null;
			}
			avatar = event.target.content as Bitmap;
			loader = null;
			avatar.alpha = 0;
			addChild(avatar);
			TweenLite.to(avatar, .3, {alpha: 1});
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
			if(avatar) avatar.bitmapData.dispose();
			avatar = null;
			if(frame){
				frame.bitmapData.dispose();
				frame = null;
			}
		}
	}
}
