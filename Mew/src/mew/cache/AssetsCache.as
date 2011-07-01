package mew.cache
{
	import flash.display.BitmapData;

	public class AssetsCache
	{
		private var avatarCache:Object = null;
		public function AssetsCache()
		{
			init();
		}
		private function init():void
		{
			avatarCache = {};
		}
		public function getAvatarCache(id:String):BitmapData
		{
			return avatarCache[id];
		}
		public function hasAvatarCache(id:String):Boolean
		{
			return avatarCache[id];
		}
		public function setAvatarCache(id:String, bd:BitmapData):void
		{
			if(avatarCache[id]){
				(avatarCache[id] as BitmapData).dispose();
			}
			avatarCache[id] = bd;
		}
		public function destroy():void
		{
			for(var key:String in avatarCache){
				if(avatarCache[key] is BitmapData){
					(avatarCache[key] as BitmapData).dispose();
					delete avatarCache[key];
				}
			}
		}
	}
}