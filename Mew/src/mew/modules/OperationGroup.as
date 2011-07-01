package mew.modules
{
	import com.iabel.component.ScrollList;
	import com.iabel.core.ALSprite;
	
	import fl.controls.Button;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mew.data.WeiboCount;
	import mew.factory.ButtonFactory;
	
	public class OperationGroup extends ALSprite
	{
		public var data:WeiboCount = null;
		public var view:ScrollList = null;
		public var parent:WeiboCount = null;
		
		private var repostBtn:Button = null;
		private var commentBtn:Button = null;
		private var deleteBtn:Button = null;
		private var collectionBtn:Button = null;
		public function OperationGroup()
		{
			super();
			
			init();
		}
		override protected function onAddedToStage(event:Event):void
		{
			super.onAddedToStage(event);
		}
		private function init():void
		{
			repostBtn = ButtonFactory.RepostButton();
			commentBtn = ButtonFactory.CommentButton();
			deleteBtn = ButtonFactory.DeleteButton();
			collectionBtn = ButtonFactory.CollectionButton();
			
			addListener();
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
			view = null;
			parent = null;
			
			repostBtn = null;
			commentBtn = null;
			deleteBtn = null;
			collectionBtn = null;
		}
	}
}