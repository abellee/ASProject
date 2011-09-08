package mew.modules {
	import system.MewSystem;

	import widget.Widget;

	import com.iabel.core.UISprite;
	import com.sina.microblog.data.MicroBlogCount;
	import com.sina.microblog.events.MicroBlogErrorEvent;
	import com.sina.microblog.events.MicroBlogEvent;

	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;

	/**
	 * @author Abel Lee
	 */
	public class RepostAndCommentCount extends UISprite {
		private var repostLabel:TextField = null;
		private var commentLabel:TextField = null;
		public var sid:String = null;
		public function RepostAndCommentCount() {
			super();
		}
		
		public function init():void
		{
			if(!repostLabel) repostLabel = new TextField();
			repostLabel.autoSize = TextFieldAutoSize.LEFT;
			repostLabel.selectable = false;
			repostLabel.defaultTextFormat = Widget.normalFormat;
			repostLabel.mouseEnabled = false;
			
			if(!commentLabel) commentLabel = new TextField();
			commentLabel.autoSize = TextFieldAutoSize.LEFT;
			commentLabel.selectable = false;
			commentLabel.defaultTextFormat = Widget.normalFormat;
			
			addChild(repostLabel);
			addChild(commentLabel);
			
			MewSystem.microBlog.addEventListener(MicroBlogEvent.LOAD_STATUS_COUNTS_RESULT, onResult);
			MewSystem.microBlog.addEventListener(MicroBlogErrorEvent.LOAD_STATUS_COUNTS_ERROR, onError);
			MewSystem.microBlog.loadStatusCounts([sid]);
		}
		
		private function onResult(event:MicroBlogEvent):void
		{
			MewSystem.microBlog.removeEventListener(MicroBlogEvent.LOAD_STATUS_COUNTS_RESULT, onResult);
			MewSystem.microBlog.removeEventListener(MicroBlogErrorEvent.LOAD_STATUS_COUNTS_ERROR, onError);
			var count:MicroBlogCount = (event.result as Array)[0];
			repostLabel.text = "转发(" + count.repostsCount + ")";
			repostLabel.width = repostLabel.textWidth;
			repostLabel.height = repostLabel.textHeight;
			
			commentLabel.text = "评论(" + count.commentsCount + ")";
			commentLabel.width = commentLabel.textWidth;
			commentLabel.height = commentLabel.textHeight;
			commentLabel.x = repostLabel.x + repostLabel.width + 5;
			
			setSize(commentLabel.width + repostLabel.width + 5, repostLabel.height);
			this.dispatchEvent(new Event(Event.RESIZE));
		}
		
		private function onError(event:MicroBlogErrorEvent):void
		{
			MewSystem.microBlog.removeEventListener(MicroBlogEvent.LOAD_STATUS_COUNTS_RESULT, onResult);
			MewSystem.microBlog.removeEventListener(MicroBlogErrorEvent.LOAD_STATUS_COUNTS_ERROR, onError);
			repostLabel.text = "转发(0)";
			repostLabel.width = repostLabel.textWidth;
			repostLabel.height = repostLabel.textHeight;
			
			commentLabel.text = "评论(0)";
			commentLabel.width = commentLabel.textWidth;
			commentLabel.height = commentLabel.textHeight;
			commentLabel.x = repostLabel.x + repostLabel.width + 5;
			setSize(commentLabel.width + repostLabel.width + 5, repostLabel.height);
			this.dispatchEvent(new Event(Event.RESIZE));
		}
		
		override protected function dealloc(event:Event):void
		{
			super.dealloc(event);
			repostLabel = null;
			commentLabel = null;
			sid = null;
		}
	}
}
