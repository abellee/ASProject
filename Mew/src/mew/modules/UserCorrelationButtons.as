package mew.modules
{
	import com.iabel.core.UISprite;
	
	import fl.controls.Button;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mew.events.MewEvent;
	import mew.factory.ButtonFactory;
	
	public class UserCorrelationButtons extends UISprite
	{
		private var homeButton:Button = null;
		private var profileButton:Button = null;
		private var followButton:Button = null;
		private var fansButton:Button = null;
		private var collectionButton:Button = null;
		public function UserCorrelationButtons()
		{
			super();
			
			init();
		}
		private function init():void
		{
			homeButton = ButtonFactory.UserHomeButton();
			profileButton = ButtonFactory.UserProfileButton();
			followButton = ButtonFactory.UserFollowButton();
			fansButton = ButtonFactory.UserFansButton();
			collectionButton = ButtonFactory.UserCollectionButton();
			
			addChild(homeButton);
			addChild(profileButton);
			addChild(followButton);
			addChild(fansButton);
			addChild(collectionButton);
			
			var h:int = Math.max(profileButton.height, followButton.height, fansButton.height, collectionButton.height);
			homeButton.x = 0;
			homeButton.y = h - homeButton.height;
			profileButton.x = homeButton.x + homeButton.width + 10;
			profileButton.y = h - profileButton.height;
			followButton.x = profileButton.x + profileButton.width + 10;
			followButton.y = h - followButton.height;
			fansButton.x = followButton.x + followButton.width + 10;
			fansButton.y = h - fansButton.height;
			collectionButton.x = fansButton.x + fansButton.width + 10;
			collectionButton.y = h - collectionButton.height;
			
			setSize(collectionButton.x + collectionButton.width, h);
			
			addListener();
		}
		
		private function addListener():void
		{
			homeButton.addEventListener(MouseEvent.CLICK, homeButton_mouseClickHandler);
			profileButton.addEventListener(MouseEvent.CLICK, profileButton_mouseClickHandler);
			followButton.addEventListener(MouseEvent.CLICK, followButton_mouseClickHandler);
			fansButton.addEventListener(MouseEvent.CLICK, fansButton_mouseClickHandler);
			collectionButton.addEventListener(MouseEvent.CLICK, collectionButton_mouseClickHandler);
		}
		
		protected function collectionButton_mouseClickHandler(event:MouseEvent):void
		{
			this.dispatchEvent(new MewEvent(MewEvent.USER_COLLECT));
		}
		
		protected function fansButton_mouseClickHandler(event:MouseEvent):void
		{
			this.dispatchEvent(new MewEvent(MewEvent.USER_FANS));
		}
		
		protected function followButton_mouseClickHandler(event:MouseEvent):void
		{
			this.dispatchEvent(new MewEvent(MewEvent.USER_FOLLOW));
		}
		
		protected function profileButton_mouseClickHandler(event:MouseEvent):void
		{
			this.dispatchEvent(new MewEvent(MewEvent.USER_PROFILE));
		}
		
		protected function homeButton_mouseClickHandler(event:MouseEvent):void
		{
			this.dispatchEvent(new MewEvent(MewEvent.USER_HOME));
		}
		
		override protected function dealloc(event:Event):void
		{
			super.dealloc(event);
			homeButton.removeEventListener(MouseEvent.CLICK, homeButton_mouseClickHandler);
			profileButton.removeEventListener(MouseEvent.CLICK, profileButton_mouseClickHandler);
			followButton.removeEventListener(MouseEvent.CLICK, followButton_mouseClickHandler);
			fansButton.removeEventListener(MouseEvent.CLICK, fansButton_mouseClickHandler);
			collectionButton.removeEventListener(MouseEvent.CLICK, collectionButton_mouseClickHandler);
			homeButton = null;
			profileButton = null;
			followButton = null;
			fansButton = null;
			collectionButton = null;
		}
	}
}