package mew.modules {
	import mew.windows.WeiboTextWindow;
	import mew.windows.ALNativeWindow;
	import fl.controls.Button;

	import mew.data.UserData;
	import mew.data.WeiboData;
	import mew.events.MewEvent;
	import mew.factory.ButtonFactory;
	import mew.windows.WeiBoPublisher;

	import system.MewSystem;

	import com.iabel.core.UISprite;

	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class OperationGroup extends UISprite
	{
		public var data:WeiboData = null;
		public var userData:UserData = null;
		public var sid:String = null;
		public var repostData:WeiboData = null;
		public var repostUserData:UserData = null;
		public var finalStep:Boolean = false;
		public var parentBox:DirectMessageBox = null;
		public var cid:String = null;
		public var parentWin:ALNativeWindow = null;
		
		private var repostBtn:Button = null;
		private var commentBtn:Button = null;
		private var deleteBtn:Button = null;
		private var collectionBtn:Button = null;
		private var messageBtn:Button = null;
		private var atBtn:Button = null;
		private var readCommentsButton:Button = null;
		public function OperationGroup()
		{
			super();
		}
		public function showAllButtons():void
		{
			readCommentsButton = ButtonFactory.ReadCommentButton();
			repostBtn = ButtonFactory.RepostButton();
			commentBtn = ButtonFactory.CommentButton();
			deleteBtn = ButtonFactory.DeleteButton();
			collectionBtn = ButtonFactory.CollectionButton();
			
			addChild(readCommentsButton);
			addChild(repostBtn);
			addChild(commentBtn);
			addChild(deleteBtn);
			addChild(collectionBtn);
			
			var h:int = 25;
			deleteBtn.x = 0;
//			deleteBtn.y = (h - deleteBtn.height) / 2;
			collectionBtn.x = deleteBtn.x + deleteBtn.width + 5;
//			collectionBtn.y = (h - collectionBtn.height) / 2;
			repostBtn.x = collectionBtn.x + collectionBtn.width + 5;
//			repostBtn.y = (h - repostBtn.height) / 2;
			commentBtn.x = repostBtn.x + repostBtn.width + 5;
//			commentBtn.y = (h - commentBtn.height) / 2;
			readCommentsButton.x = commentBtn.x + commentBtn.width + 5;
			
			setSize(readCommentsButton.x + readCommentsButton.width, h);
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
		
		public function showReadComment():void
		{
			readCommentsButton = ButtonFactory.ReadCommentButton();
			readCommentsButton.addEventListener(MouseEvent.CLICK, readCommentsButton_mouseClickHandler);
			orientation(readCommentsButton);
			addChild(readCommentsButton);
		}
		
		public function showCommentButton():void
		{
			commentBtn = ButtonFactory.CommentButton();
			commentBtn.label = "";
			orientation(commentBtn);
			commentBtn.addEventListener(MouseEvent.CLICK, commentBtn_mouseClickHandler);
			addChild(commentBtn);
		}
		
		public function showAtButton():void
		{
			atBtn = ButtonFactory.AtButton();
			atBtn.label = "";
			orientation(atBtn);
			atBtn.addEventListener(MouseEvent.CLICK, atBtn_mouseClickHandler);
			addChild(atBtn);
		}
		
		private function atBtn_mouseClickHandler(event:MouseEvent):void
		{
			MewSystem.app.openPublishWindow(WeiBoPublisher.NORMAL, userData);
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
				setSize(messageBtn.x + messageBtn.width, 25);
				return;
			}
			if(atBtn){
				setSize(atBtn.x + atBtn.width, 25);
				return;
			}
			if(readCommentsButton) setSize(readCommentsButton.x + readCommentsButton.width, 25);
			else setSize(commentBtn.x + commentBtn.width, 25);
		}

		private function orientation(btn:Button):void
		{
			if(this.numChildren){
				var preBtn:Button = this.getChildAt(this.numChildren - 1) as Button;
				btn.x = preBtn.x + preBtn.width + 5;
			}
		}
		
		private function addListener():void
		{
			repostBtn.addEventListener(MouseEvent.CLICK, repostBtn_mouseClickHandler);
			commentBtn.addEventListener(MouseEvent.CLICK, commentBtn_mouseClickHandler);
			deleteBtn.addEventListener(MouseEvent.CLICK, deleteBtn_mouseClickHandler);
			collectionBtn.addEventListener(MouseEvent.CLICK, collectionBtn_mouseClickHandler);
			readCommentsButton.addEventListener(MouseEvent.CLICK, readCommentsButton_mouseClickHandler);
		}
		
		private function messageBtn_mouseClickHandler(event : MouseEvent) : void
		{
			this.dispatchEvent(new MewEvent(MewEvent.DIRECT_MESSAGE));
		}
		
		private function repostBtn_mouseClickHandler(event:MouseEvent):void
		{
//			this.dispatchEvent(new MewEvent(MewEvent.REPOST_STATUS));
			MewSystem.app.openPublishWindow(WeiBoPublisher.REPOST, userData, data, repostUserData, repostData);
		}
		
		private function commentBtn_mouseClickHandler(event:MouseEvent):void
		{
			if(finalStep){
				if(data.cid && data.cid != "0") MewSystem.app.openPublishWindow(WeiBoPublisher.REPLY, userData, data, repostUserData, repostData);
				else MewSystem.app.openPublishWindow(WeiBoPublisher.COMMENT, userData, data, repostUserData, repostData);
				return;
			}
		}
		
		private function readCommentsButton_mouseClickHandler(event:MouseEvent):void
		{
			if(sid) MewSystem.app.showWeiboTextWindow(sid);
		}
		
		private function deleteBtn_mouseClickHandler(event:MouseEvent):void
		{
//			this.dispatchEvent(new MewEvent(MewEvent.DELETE_STATUS));
			if(parentBox is CommentEntry){
				MewSystem.app.alternationCenter.deleteComment(cid, parentWin, sid);
				return;
			}else if(parentBox is WeiboEntry){
				if(MewSystem.app.currentState == MewSystem.app.COLLECT){
					MewSystem.app.alternationCenter.removeFavorite(data.id, parentWin);
					return;
				}
				MewSystem.app.alternationCenter.deleteStatus(data.id, parentWin);
				return;
			}else if(parentBox is RepostBox){
				MewSystem.app.alternationCenter.deleteStatus(data.id, parentWin);
				return;
			}else if(parentBox is DirectMessageBox){
				MewSystem.app.alternationCenter.deleteDirectMessage(data.id, parentWin);
				return;
			}
			
		}
		private function collectionBtn_mouseClickHandler(event:MouseEvent):void
		{
//			this.dispatchEvent(new MewEvent(MewEvent.COLLECT_STATUS));
			MewSystem.app.alternationCenter.collectStatus(data.id, parentWin);
		}
		
		override protected function dealloc(event:Event):void
		{
			super.dealloc(event);
			
			data = null;
			userData = null;
			sid = null;
			
			if(repostBtn) repostBtn.removeEventListener(MouseEvent.CLICK, repostBtn_mouseClickHandler);
			if(commentBtn) commentBtn.removeEventListener(MouseEvent.CLICK, commentBtn_mouseClickHandler);
			if(deleteBtn) deleteBtn.removeEventListener(MouseEvent.CLICK, deleteBtn_mouseClickHandler);
			if(collectionBtn) collectionBtn.removeEventListener(MouseEvent.CLICK, collectionBtn_mouseClickHandler);
			if(messageBtn) messageBtn.removeEventListener(MouseEvent.CLICK, messageBtn_mouseClickHandler);
			if(atBtn) atBtn.removeEventListener(MouseEvent.CLICK, atBtn_mouseClickHandler);
			if(readCommentsButton) readCommentsButton.removeEventListener(MouseEvent.CLICK, readCommentsButton_mouseClickHandler);
			
			repostBtn = null;
			commentBtn = null;
			deleteBtn = null;
			collectionBtn = null;
			messageBtn = null;
			atBtn = null;
			readCommentsButton = null;
			
			data = null;
			userData = null;
			sid = null;
			repostData = null;
			repostUserData = null;
			parentBox = null;
			cid = null;
			parentWin = null;
		}
	}
}