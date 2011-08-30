package mew.modules
{
	import com.iabel.core.UISprite;
	
	import fl.controls.Button;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mew.data.WeiboCount;
	import mew.factory.ButtonFactory;
	
	public class OperationGroup extends UISprite
	{
		public var data:WeiboCount = null;
		public var _parent:WeiboCount = null;
		
		private var repostBtn:Button = null;
		private var commentBtn:Button = null;
		private var deleteBtn:Button = null;
		private var collectionBtn:Button = null;
		public function OperationGroup()
		{
			super();
		}
		public function showAllButtons():void
		{
			repostBtn = ButtonFactory.RepostButton();
			commentBtn = ButtonFactory.CommentButton();
			deleteBtn = ButtonFactory.DeleteButton();
			collectionBtn = ButtonFactory.CollectionButton();
			
			addChild(repostBtn);
			addChild(commentBtn);
			addChild(deleteBtn);
			addChild(collectionBtn);
			
			var h:int = Math.max(repostBtn.height, commentBtn.height, deleteBtn.height, collectionBtn.height);
			repostBtn.x = 0;
			repostBtn.y = h - repostBtn.height;
			commentBtn.x = repostBtn.x + repostBtn.width + 5;
			commentBtn.y = h - commentBtn.height;
			deleteBtn.x = commentBtn.x + commentBtn.width + 5;
			deleteBtn.y = h - deleteBtn.height;
			collectionBtn.x = deleteBtn.x + deleteBtn.width + 5;
			collectionBtn.y = h - collectionBtn.height;
			
			setSize(collectionBtn.x + collectionBtn.width, h);
			addListener();
		}
		
		/**
		 * 必需先指定容器高度
		 */
		public function showRepostButton():void
		{
			repostBtn = ButtonFactory.RepostButton();
			orientation(repostBtn);
			addChild(repostBtn);
		}
		
		public function showCommentButton():void
		{
			commentBtn = ButtonFactory.CommentButton();
			orientation(commentBtn);
			addChild(commentBtn);
		}
		
		public function showDeleteButton():void
		{
			deleteBtn = ButtonFactory.DeleteButton();
			orientation(deleteBtn);
			addChild(deleteBtn);
		}
		
		public function showCollectionButton():void
		{
			collectionBtn = ButtonFactory.CollectionButton();
			orientation(collectionBtn);
			addChild(collectionBtn);
		}
		
		private function orientation(btn:Button):void
		{
			if(this.numChildren){
				var preBtn:Button = this.getChildAt(this.numChildren - 1) as Button;
				btn.x = preBtn.x + preBtn.width + 5;
			}
			btn.y = this.height - btn.height;
		}
		
		private function addListener():void
		{
			repostBtn.addEventListener(MouseEvent.CLICK, repostBtn_mouseClickHandler);
			commentBtn.addEventListener(MouseEvent.CLICK, commentBtn_mouseClickHandler);
			deleteBtn.addEventListener(MouseEvent.CLICK, deleteBtn_mouseClickHandler);
			collectionBtn.addEventListener(MouseEvent.CLICK, collectionBtn_mouseClickHandler);
		}
		
		private function repostBtn_mouseClickHandler(event:MouseEvent):void
		{
			
		}
		private function commentBtn_mouseClickHandler(event:MouseEvent):void
		{
			
		}
		private function deleteBtn_mouseClickHandler(event:MouseEvent):void
		{
			
		}
		private function collectionBtn_mouseClickHandler(event:MouseEvent):void
		{
			
		}
		
		override protected function dealloc(event:Event):void
		{
			super.dealloc(event);
			
			data = null;
			_parent = null;
			
			repostBtn.removeEventListener(MouseEvent.CLICK, repostBtn_mouseClickHandler);
			commentBtn.removeEventListener(MouseEvent.CLICK, commentBtn_mouseClickHandler);
			deleteBtn.removeEventListener(MouseEvent.CLICK, deleteBtn_mouseClickHandler);
			collectionBtn.removeEventListener(MouseEvent.CLICK, collectionBtn_mouseClickHandler);
			
			repostBtn = null;
			commentBtn = null;
			deleteBtn = null;
			collectionBtn = null;
		}
	}
}