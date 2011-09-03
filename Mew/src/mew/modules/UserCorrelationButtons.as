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
		private var followButton:Button = null;
		private var fansButton:Button = null;
		public function UserCorrelationButtons()
		{
			super();
			
			init();
		}
		private function init():void
		{
			homeButton = ButtonFactory.UserHomeButton();
			followButton = ButtonFactory.UserFollowButton();
			fansButton = ButtonFactory.UserFansButton();
			
			homeButton.label = "微博";
			followButton.label = "关注";
			fansButton.label = "粉丝";
			addChild(homeButton);
			addChild(followButton);
			addChild(fansButton);
			
			var h:int = Math.max(followButton.height, fansButton.height);
			homeButton.x = 0;
			homeButton.y = h - homeButton.height;
			followButton.x = homeButton.x + homeButton.width + 10;
			followButton.y = h - followButton.height;
			fansButton.x = followButton.x + followButton.width + 10;
			fansButton.y = h - fansButton.height;
			
			setSize(fansButton.x + fansButton.width, h);
			
			addListener();
		}
		
		private function addListener():void
		{
			homeButton.addEventListener(MouseEvent.CLICK, homeButton_mouseClickHandler);
			followButton.addEventListener(MouseEvent.CLICK, followButton_mouseClickHandler);
			fansButton.addEventListener(MouseEvent.CLICK, fansButton_mouseClickHandler);
		}
		
		protected function fansButton_mouseClickHandler(event:MouseEvent):void
		{
			this.dispatchEvent(new MewEvent(MewEvent.USER_FANS));
		}
		
		protected function followButton_mouseClickHandler(event:MouseEvent):void
		{
			this.dispatchEvent(new MewEvent(MewEvent.USER_FOLLOW));
		}
		
		protected function homeButton_mouseClickHandler(event:MouseEvent):void
		{
			this.dispatchEvent(new MewEvent(MewEvent.USER_HOME));
		}
		
		override protected function dealloc(event:Event):void
		{
			super.dealloc(event);
			homeButton.removeEventListener(MouseEvent.CLICK, homeButton_mouseClickHandler);
			followButton.removeEventListener(MouseEvent.CLICK, followButton_mouseClickHandler);
			fansButton.removeEventListener(MouseEvent.CLICK, fansButton_mouseClickHandler);
			homeButton = null;
			followButton = null;
			fansButton = null;
		}
	}
}