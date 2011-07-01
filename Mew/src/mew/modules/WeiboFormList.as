package mew.modules
{
	import com.iabel.core.UISprite;
	import com.sina.microblog.data.MicroBlogComment;
	import com.sina.microblog.data.MicroBlogDirectMessage;
	import com.sina.microblog.data.MicroBlogStatus;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	
	public class WeiboFormList extends UISprite
	{
		protected var changed:Boolean = false;
		protected var fromIndex:int = 0;
		public function WeiboFormList()
		{
			super();
		}
		
		override public function listData(arr:Array, w:Number):void
		{
			fromIndex = this.numChildren;
			for each(var obj:Object in arr){
				var entry:DirectMessageBox;
				if(obj is MicroBlogStatus) entry = new WeiboEntry();
				else if(obj is MicroBlogComment) entry = new CommentEntry();
				else if(obj is MicroBlogDirectMessage) entry = new DirectMessageBox();
				entry.x = 10;
				entry.setSize(w - entry.x, 10);
				entry.initStatus(obj);
				entry.addEventListener(Event.RESIZE, onResize);
				if(this.numChildren){
					var pre:DisplayObject = this.getChildAt(this.numChildren - 1);
					entry.y = pre.y + int(pre.height) + 10;
				}else{
					entry.y = 0;
				}
				addChild(entry);
			}
		}
		
		override protected function callLaterDispatcher(event:Event):void
		{
			if(changed) return;
			super.callLaterDispatcher(event);
		}
		
		override protected function redraw():void
		{
			changed = true;
			var num:int = this.numChildren;
			for(var i:int = fromIndex; i<num; i++){
				var entry:DirectMessageBox = this.getChildAt(i) as DirectMessageBox;
				entry.x = 10;
				if(i){
					var pre:DisplayObject = this.getChildAt(i - 1);
					entry.y = pre.y + int(pre.height) + 10;
				}else{
					entry.y = 0;
				}
			}
			this.dispatchEvent(new Event(Event.RESIZE));
		}
		
		protected function onResize(event:Event):void
		{
			changed = false;
			if(stage) stage.invalidate();
		}
	}
}