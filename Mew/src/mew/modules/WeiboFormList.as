package mew.modules {
	import mew.windows.ALNativeWindow;
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
		
		override public function listData(arr:Array, w:Number, xml:XML, win:ALNativeWindow, showRepost:Boolean = true):void
		{
			fromIndex = this.numChildren;
			for each(var obj:Object in arr){
				var entry:DirectMessageBox;
				if(obj is MicroBlogStatus) entry = new WeiboEntry();
				else if(obj is MicroBlogComment){
					entry = new CommentEntry();
					(entry as CommentEntry).showRepost = showRepost;
					(entry as CommentEntry).finalStep = true;
				}else if(obj is MicroBlogDirectMessage){
					entry = new DirectMessageBox();
					entry.finalStep = true;
				}
				entry.parentWin = win;
				entry.x = 0;
				entry.setSize(w - entry.x, 10);
				entry.initStatus(obj, xml);
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
			for(var i:int = 0; i<num; i++){
				var entry:DirectMessageBox = this.getChildAt(i) as DirectMessageBox;
				entry.x = 0;
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
		
		override protected function dealloc(event:Event):void
		{
			super.dealloc(event);
		}
	}
}