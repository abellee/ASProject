package mew.modules {
	import system.MewSystem;
	import mew.data.WeiboData;
	import mew.data.UserData;
	import fl.controls.Button;

	import mew.data.WeiboCount;
	import mew.events.MewEvent;
	import mew.factory.ButtonFactory;

	import com.iabel.core.UISprite;

	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class OperationGroup extends UISprite
	{
		public var data:WeiboCount = null;
		public var _parent:WeiboCount = null;
		public var sid:String = null;
		
		private var repostBtn:Button = null;
		private var commentBtn:Button = null;
		private var deleteBtn:Button = null;
		private var collectionBtn:Button = null;
		private var messageBtn:Button = null;
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
			repostBtn.label = "";
			commentBtn.label = "";
			deleteBtn.label = "";
			collectionBtn.label = "";
			
			addChild(repostBtn);
			addChild(commentBtn);
			addChild(deleteBtn);
			addChild(collectionBtn);
			
			var h:int = 30;
			deleteBtn.x = 0;
			deleteBtn.y = (h - deleteBtn.height) / 2;
			collectionBtn.x = deleteBtn.x + deleteBtn.width + 5;
			collectionBtn.y = (h - collectionBtn.height) / 2;
			repostBtn.x = collectionBtn.x + collectionBtn.width + 5;
			repostBtn.y = (h - repostBtn.height) / 2;
			commentBtn.x = repostBtn.x + repostBtn.width + 5;
			commentBtn.y = (h - commentBtn.height) / 2;
			
			setSize(commentBtn.x + commentBtn.width, h);
			addListener();
		}
		
		/**
		 * 必需先指定容器高度
		 */
		public function showRepostButton():void
		{
			repostBtn = ButtonFactory.RepostButton();
			repostBtn.label = "";
			orientation(repostBtn);
			repostBtn.addEventListener(MouseEvent.CLICK, repostBtn_mouseClickHandler);
			addChild(repostBtn);
		}
		
		public function showCommentButton():void
		{
			commentBtn = ButtonFactory.CommentButton();
			commentBtn.label = "";
			orientation(commentBtn);
			commentBtn.addEventListener(MouseEvent.CLICK, commentBtn_mouseClickHandler);
			addChild(commentBtn);
		}
		
		public function showDeleteButton():void
		{
			deleteBtn = ButtonFactory.DeleteButton();
			deleteBtn.label = "";
			orientation(deleteBtn);
			deleteBtn.addEventListener(MouseEvent.CLICK, deleteBtn_mouseClickHandler);
			addChild(deleteBtn);
		}
		
		public function showCollectionButton():void
		{
			collectionBtn = ButtonFactory.CollectionButton();
			collectionBtn.label = "";
			orientation(collectionBtn);
			collectionBtn.addEventListener(MouseEvent.CLICK, collectionBtn_mouseClickHandler);
			addChild(collectionBtn);
		}
		
		public function showMessageButton():void
		{
			messageBtn = ButtonFactory.MessageButton();
			messageBtn.label = "";
			orientation(messageBtn);
			messageBtn.addEventListener(MouseEvent.CLICK, messageBtn_mouseClickHandler);
			addChild(messageBtn);
		}
		
		public function calculateSize():void
		{
			if(messageBtn){
				setSize(messageBtn.x + messageBtn.width, 30);
				return;
			}
			setSize(commentBtn.x + commentBtn.width, 30);
		}

		private function orientation(btn:Button):void
		{
			if(this.numChildren){
				var preBtn:Button = this.getChildAt(this.numChildren - 1) as Button;
				btn.x = preBtn.x + preBtn.width + 5;
			}
			btn.y = (30 - btn.height) / 2;
		}
		
		private function addListener():void
		{
			repostBtn.addEventListener(MouseEvent.CLICK, repostBtn_mouseClickHandler);
			commentBtn.addEventListener(MouseEvent.CLICK, commentBtn_mouseClickHandler);
			deleteBtn.addEventListener(MouseEvent.CLICK, deleteBtn_mouseClickHandler);
			collectionBtn.addEventListener(MouseEvent.CLICK, collectionBtn_mouseClickHandler);
		}
		
		private function messageBtn_mouseClickHandler(event : MouseEvent) : void
		{
			this.dispatchEvent(new MewEvent(MewEvent.DIRECT_MESSAGE));
		}
		private function repostBtn_mouseClickHandler(event:MouseEvent):void
		{
			this.dispatchEvent(new MewEvent(MewEvent.REPOST_STATUS));
		}
		private function commentBtn_mouseClickHandler(event:MouseEvent):void
		{
			if(sid) MewSystem.app.showWeiboTextWindow(sid);
		}
		private function deleteBtn_mouseClickHandler(event:MouseEvent):void
		{
			this.dispatchEvent(new MewEvent(MewEvent.DELETE_STATUS));
		}
		private function collectionBtn_mouseClickHandler(event:MouseEvent):void
		{
			this.dispatchEvent(new MewEvent(MewEvent.COLLECT_STATUS));	
		}
		
		override protected function dealloc(event:Event):void
		{
			super.dealloc(event);
			
			data = null;
			_parent = null;
			
			if(repostBtn) repostBtn.removeEventListener(MouseEvent.CLICK, repostBtn_mouseClickHandler);
			if(commentBtn) commentBtn.removeEventListener(MouseEvent.CLICK, commentBtn_mouseClickHandler);
			if(deleteBtn) deleteBtn.removeEventListener(MouseEvent.CLICK, deleteBtn_mouseClickHandler);
			if(collectionBtn) collectionBtn.removeEventListener(MouseEvent.CLICK, collectionBtn_mouseClickHandler);
			if(messageBtn) messageBtn.removeEventListener(MouseEvent.CLICK, messageBtn_mouseClickHandler);
			
			repostBtn = null;
			commentBtn = null;
			deleteBtn = null;
			collectionBtn = null;
			messageBtn = null;
		}
	}
}