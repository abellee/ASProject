package mew.modules {
	import fl.controls.Button;
	import fl.controls.ButtonLabelPlacement;

	import mew.data.UserData;
	import mew.events.MewEvent;
	import mew.factory.ButtonFactory;

	import com.iabel.core.UISprite;

	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class UserCorrelationButtons extends UISprite
	{
		private var homeButton:UIButton = null;
		private var followButton:UIButton = null;
		private var fansButton:UIButton = null;
		private var userData:UserData = null;
		private var preButton:UIButton = null;
		public function UserCorrelationButtons(data:UserData)
		{
			super();
			
			userData = data;
			init();
		}
		private function init():void
		{
			var hbtn:Button = ButtonFactory.UserHomeButton();
			var fobtn:Button = ButtonFactory.UserFollowButton();
			var fabtn:Button = ButtonFactory.UserFansButton();
			
			homeButton = new UIButton(hbtn, "微博[" + userData.tweetsNum + "]", 5, "right");
			followButton = new UIButton(fobtn, "关注[" + userData.followNum + "]", 5, "right");
			fansButton = new UIButton(fabtn, "粉丝[" + userData.fansNum + "]", 5, "right");
			homeButton.toggle = true;
			followButton.toggle = true;
			fansButton.toggle = true;
			addChild(homeButton);
			addChild(followButton);
			addChild(fansButton);
			
			var h:int = Math.max(followButton.height, fansButton.height);
			homeButton.x = 0;
			homeButton.y = h - homeButton.height - 5;
			followButton.x = homeButton.x + homeButton.width + 10;
			followButton.y = h - followButton.height - 5;
			fansButton.x = followButton.x + followButton.width + 10;
			fansButton.y = h - fansButton.height - 5;
			
			setSize(fansButton.x + fansButton.width, h);
			
			addListener();
		}
		
		private function addListener():void
		{
			homeButton.addEventListener(MouseEvent.CLICK, homeButton_mouseClickHandler);
			followButton.addEventListener(MouseEvent.CLICK, followButton_mouseClickHandler);
			fansButton.addEventListener(MouseEvent.CLICK, fansButton_mouseClickHandler);
		}
		
		private function resetCurrentButton() : void {
			if(preButton){
				if(preButton is UIButton){
					preButton.enabled = true;
					preButton.toggle = false;
					preButton.toggle = true;
				}
				preButton = null;
			}
		}
		
		protected function fansButton_mouseClickHandler(event:MouseEvent):void
		{
			var btn:UIButton = event.currentTarget as UIButton;
			if(preButton == btn){
				btn.enabled = false;
				return;
			}
			resetCurrentButton();
			preButton = btn;
			this.dispatchEvent(new MewEvent(MewEvent.USER_FANS));
		}
		
		protected function followButton_mouseClickHandler(event:MouseEvent):void
		{
			var btn:UIButton = event.currentTarget as UIButton;
			if(preButton == btn){
				btn.enabled = false;
				return;
			}
			resetCurrentButton();
			preButton = btn;
			this.dispatchEvent(new MewEvent(MewEvent.USER_FOLLOW));
		}
		
		protected function homeButton_mouseClickHandler(event:MouseEvent):void
		{
			var btn:UIButton = event.currentTarget as UIButton;
			if(preButton == btn){
				btn.enabled = false;
				return;
			}
			resetCurrentButton();
			preButton = btn;
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