package mew.modules {
	import mew.windows.ALNativeWindow;
	import com.sina.microblog.data.MicroBlogUser;

	import flash.events.Event;
	
	public class UserFormList extends WeiboFormList
	{
		public function UserFormList()
		{
			super();
		}
		override public function listData(arr:Array, w:Number, xml:XML, win:ALNativeWindow, showRepost:Boolean = true):void
		{
			fromIndex = this.numChildren;
			for each(var obj:MicroBlogUser in arr){
				var entry:UserEntry = new UserEntry();
				entry.setSize(130, 10);
				entry.parentWin = win;
				entry.initStatus(obj);
				entry.x = (this.numChildren % 3) * (entry.width + 10);
				entry.y = int(this.numChildren / 3) * 140;
				addChild(entry);
			}
			if(fromIndex) this.dispatchEvent(new Event(Event.RESIZE));
		}

		override protected function redraw():void
		{
			return;
		}
		
		override protected function dealloc(event:Event):void
		{
			super.dealloc(event);
		}
	}
}